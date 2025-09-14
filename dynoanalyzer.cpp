#include "dynoanalyzer.h"
#include "dashboard.h"
#include <algorithm>
#include <QDebug>


DynoAnalyzer::DynoAnalyzer(QObject *parent)
    : QObject(parent)
    , m_dashboard(Q_NULLPTR)

{

}
DynoAnalyzer::DynoAnalyzer(DashBoard *dashboard, QObject *parent)
    : QObject(parent)
    , m_dashboard(dashboard)
{
    qDebug() << "restting Timer";
    connect(&m_timer, &QTimer::timeout, this, [this]() {
        double dt = m_elapsed.elapsed() / 1000.0;
        if (dt <= 0.0) dt = 0.02;
        m_elapsed.restart();
        processSample(dt);
    });
}


void DynoAnalyzer::reset() {
    m_minY = 0.0;
    m_maxY = 100.0;
    m_isRunning = false;
    m_peakRpm   = 0.0;
    m_lastSpeed = 0.0;

    m_smoothedTorque = 0.0;
    m_smoothedPower  = 0.0;
    m_smoothedSpeed  = 0.0;
    m_smoothedRpm    = 0.0;

    // reset maxima
    m_maxTorque = 0.0;
    m_maxTorqueRpm = 0.0;
    m_maxPower = 0.0;
    m_maxPowerRpm = 0.0;

}

void DynoAnalyzer::prime() {
    if (!m_dashboard) {
        qWarning() << "DynoAnalyzer::prime() called but dashboard pointer is null!";
        return;
    }

    m_primed = true;
    m_isRunning = false;
    m_peakRpm = 0.0;

    m_elapsed.restart();
    if (!m_timer.isActive())
        m_timer.start(100);  // 100 ms sampling

       m_elapsed.restart();
       qDebug() << "Dyno primed – waiting for 2000 RPM...";
}

void DynoAnalyzer::processSample(double dt) {
    if (!m_dashboard)
        return;

    double rpm   = m_dashboard->rpm();
    double speed = m_dashboard->speed();
    double mass  = m_dashboard->Weight();
    bool metric  = (m_dashboard->speedunits() == "metric");

    if (!metric) {
        speed *= 1.60934;
        mass  *= 0.453592;
    }

    if (!m_primed)
        return;

    // --- Start dyno run ---
    if (!m_isRunning) {
        if (rpm >= 2000) {
            reset();
            m_isRunning = true;
            m_peakRpm   = rpm;
            m_lastSpeed = speed;

            // Warm-start smoothing with actual live values
            m_smoothedSpeed = speed;
            m_smoothedRpm   = rpm;
            m_smoothedTorque = 0.0;
            m_smoothedPower  = 0.0;

            emit runningChanged(true);

        } else {
            return;
        }
    }

    // --- Smooth inputs ---
    const double alphaSpeed = 0.2;
    const double alphaRpm   = 0.2;
    m_smoothedSpeed = alphaSpeed * speed + (1.0 - alphaSpeed) * m_smoothedSpeed;
    m_smoothedRpm   = alphaRpm * rpm + (1.0 - alphaRpm) * m_smoothedRpm;

    // --- Track peak RPM ---
    if (m_smoothedRpm > m_peakRpm)
        m_peakRpm = m_smoothedRpm;

    // --- Stop conditions ---
    if (m_smoothedRpm <= m_peakRpm - 1000 || m_smoothedRpm > 8000) {
        m_isRunning = false;
        m_primed = false;
        emit finished();
        emit runningChanged(false);
        if (m_timer.isActive())
            m_timer.stop();
        return;
    }

    // --- Physics ---
    double dv = (m_smoothedSpeed - m_lastSpeed) / 3.6; // m/s
    m_lastSpeed = m_smoothedSpeed;

    double accel = dv / dt;
    const double MAX_ACCEL = 10.0;
    const double MIN_ACCEL = -10.0;
    if (accel > MAX_ACCEL) accel = MAX_ACCEL;
    if (accel < MIN_ACCEL) accel = MIN_ACCEL;

    double force = mass * accel;
    double torqueWheels = force * m_wheelRadius;
    double totalRatio = m_gearRatio * m_finalDrive * m_efficiency;
    double torqueEngine = torqueWheels / totalRatio;
    double powerKW = (torqueEngine * m_smoothedRpm) / 9550.0;

    // --- Smooth outputs ---
    const double alphaOutput = 0.1; // more aggressive smoothing
    m_smoothedTorque = alphaOutput * torqueEngine + (1.0 - alphaOutput) * m_smoothedTorque;
    m_smoothedPower  = alphaOutput * powerKW + (1.0 - alphaOutput) * m_smoothedPower;

    double torqueOut = m_smoothedTorque;
    double powerOut  = m_smoothedPower;

    if (!metric) {
        torqueOut *= 0.737562;
        powerOut  *= 1.34102;
    }

    // --- Update max values ---
    if (torqueOut > m_maxTorque) {
        m_maxTorque = torqueOut;
        m_maxTorqueRpm = m_smoothedRpm;
        emit maxValuesChanged();
    }

    if (powerOut > m_maxPower) {
        m_maxPower = powerOut;
        m_maxPowerRpm = m_smoothedRpm;
        emit maxValuesChanged();
    }

    emit newTorquePoint(m_smoothedRpm, torqueOut);
    emit newPowerPoint(m_smoothedRpm, powerOut);

    double val = std::max(torqueOut, powerOut);
    if (val > m_maxY) {
        m_maxY = val;
        emit yRangeChanged(m_minY, m_maxY * 1.1);
    }
}
