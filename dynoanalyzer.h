#ifndef DYNOANALYZER_H
#define DYNOANALYZER_H

#include <QObject>
#include <QTimer>
#include <QElapsedTimer>

class DashBoard; // forward declare your dashboard class

class DynoAnalyzer : public QObject {
    Q_OBJECT

    // --- Expose max values to QML ---
    Q_PROPERTY(double maxTorque READ maxTorque NOTIFY maxValuesChanged)
    Q_PROPERTY(double maxTorqueRpm READ maxTorqueRpm NOTIFY maxValuesChanged)
    Q_PROPERTY(double maxPower READ maxPower NOTIFY maxValuesChanged)
    Q_PROPERTY(double maxPowerRpm READ maxPowerRpm NOTIFY maxValuesChanged)

public:
    explicit DynoAnalyzer(QObject *parent = 0);
    explicit DynoAnalyzer(DashBoard *dashboard, QObject *parent = 0);


    Q_INVOKABLE void reset();
    Q_INVOKABLE void prime(); // arm the dyno run
    Q_INVOKABLE void processSample(double dt); // called periodically (polls m_dashboard)

    double maxTorque() const { return m_maxTorque; }
    double maxTorqueRpm() const { return m_maxTorqueRpm; }
    double maxPower() const { return m_maxPower; }
    double maxPowerRpm() const { return m_maxPowerRpm; }

signals:
    void newTorquePoint(double rpm, double torque);
    void newPowerPoint(double rpm, double power);
    void yRangeChanged(double minY, double maxY);
    void runningChanged(bool running);
    void finished();
    void maxValuesChanged();

private:
    double m_smoothedTorque = 0.0;
    double m_smoothedPower  = 0.0;
    double m_smoothedSpeed = 0.0;
    double m_smoothedRpm = 0.0;

    double m_maxTorque = 0.0;
    double m_maxTorqueRpm = 0.0;
    double m_maxPower = 0.0;
    double m_maxPowerRpm = 0.0;

    double m_wheelRadius   = 0.31;   // meters
    double m_gearRatio     = 3.7;
    double m_finalDrive    = 4.1;
    double m_efficiency    = 0.85;

    double m_minY = 0.0;
    double m_maxY = 100.0;

    bool   m_isRunning = false;
    bool   m_primed    = false;
    double m_peakRpm   = 0.0;

    double m_lastSpeed = 0.0;
    QTimer m_timer;
    QElapsedTimer m_elapsed;
    DashBoard *m_dashboard;
};

#endif // DYNOANALYZER_H
