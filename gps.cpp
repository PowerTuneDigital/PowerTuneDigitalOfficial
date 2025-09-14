#include <QDebug>
#include <QByteArrayMatcher>
#include <QTime>
#include <QTimer>
#include <QFile>
#include <QTextStream>

#include "gps.h"
#include "dashboard.h"
#include "connect.h"

int initialized = 0;
int rateset = 0;
int raterequ = 0;
int baudrate;
float hdop;
QString GPSPort;
QTime fastestlap(0, 0);
QByteArray ACK10HZ = QByteArray::fromHex("b562050102000608");
QByteArray NACK10HZ = QByteArray::fromHex("050002");
QByteArray line;
int Laps = 0;
qreal startlineX1;   // Longitude
qreal startlineX2;   // Longitude
qreal startlineY1;   // Latitude
qreal startlineY2;   // Latitude
qreal start2lineX1;  // Longitude
qreal start2lineX2;  // Longitude
qreal start2lineY1;  // Latitude
qreal start2lineY2;  // Latitude
qreal m;
qreal b;
qreal m2;
qreal b2;
qreal interrim;
qreal intercept;
qreal currentintercept;
qreal currentintercept2;
qreal previousintercept;
qreal previousintercept2;
int linedirection;       // Direction of the finish line 0 = Latitude 1 = Longitude
int line2direction = 2;  // Direction of the finish line 0 = Latitude 1 = Longitude
int zeroslope;
int zeroslope2;
QString setbaudrate;

int invalidRMCCount = 0;
const int maxInvalidRMC = 30; //Check GPRMC if the time is empty reconnect if more than 30 empty messages

GPS::GPS(QObject *parent)
    : QObject(parent)
    , m_dashboard(Q_NULLPTR)
{
}

GPS::GPS(DashBoard *dashboard, QObject *parent)
    : QObject(parent)
    , m_dashboard(dashboard)
{
}

void GPS::initSerialPort()
{
    m_serialport = new SerialPort(this);
    connect(this->m_serialport, SIGNAL(readyRead()), this, SLOT(readyToRead()));
    connect(&m_timeouttimer, &QTimer::timeout, this, &GPS::handleTimeout);
}

void GPS::clear()
{
    m_serialport->clear();
}

void GPS::openConnection(const QString &portName, const QString &Baud)
{
    GPSPort = portName;
    setbaudrate = Baud;
    initSerialPort();
    m_timeouttimer.stop();
    m_timeouttimer.start(8000);
    baudrate = Baud.toInt();
    m_serialport->setPortName(GPSPort);

    m_dashboard->setgpsFIXtype("Start GPS ...");
    switch (baudrate)
    {
    case 9600:
        m_serialport->setBaudRate(QSerialPort::Baud9600);
        break;
    case 115200:
        m_serialport->setBaudRate(QSerialPort::Baud115200);
        break;
    default:
        m_serialport->setBaudRate(QSerialPort::Baud9600);
        break;
    }

    m_serialport->setParity(QSerialPort::NoParity);
    m_serialport->setDataBits(QSerialPort::Data8);
    m_serialport->setStopBits(QSerialPort::OneStop);
    m_serialport->setFlowControl(QSerialPort::NoFlowControl);

    if (m_serialport->open(QIODevice::ReadWrite) == false)
    {
        GPS::closeConnection();
    }
}

void GPS::removeNMEAmsg()
{
    setGPSOnly();
    m_dashboard->setgpsFIXtype("Disable messages");
    m_serialport->write(QByteArray::fromHex("B56206010800F0050000000000000446"));  // VTG OFF
    m_serialport->waitForBytesWritten(4000);
    m_serialport->write(QByteArray::fromHex("B56206010800F0020000000000000131"));  // GSA_Off
    m_serialport->waitForBytesWritten(4000);
    m_serialport->write(QByteArray::fromHex("B56206010800F0030000000000000238"));  // GSV_Off
    m_serialport->waitForBytesWritten(4000);
    m_serialport->write(QByteArray::fromHex("B56206010800F001000000000000002A"));  // GLL_Off
    m_serialport->waitForBytesWritten(4000);
    m_serialport->write(QByteArray::fromHex("B56206010800F008000000000000075B"));  // ZDA_Off
    m_serialport->waitForBytesWritten(4000);
}

void GPS::setGPSBAUD115()
{
    m_serialport->write(QByteArray::fromHex("B5620600140001000000D008000000C201000700020000000000BF78"));
    m_serialport->waitForBytesWritten(4000);
    initialized = 1;
    handleTimeout();
}

void GPS::setGPS10HZ()
{
    m_serialport->write(QByteArray::fromHex("b562060806006400010001007a12"));
    m_serialport->waitForBytesWritten(4000);
}

void GPS::setGPSOnly()
{
    m_serialport->write(QByteArray::fromHex("B562063E2C0000201005000810000100010101010300000001010308100000000101050003000000010106080E00000001010CD1"));  // GPS Only
    m_serialport->waitForBytesWritten(4000);
}

void GPS::closeConnection()
{
    disconnect(this->m_serialport, SIGNAL(readyRead()), this, SLOT(readyToRead()));
    disconnect(&m_timeouttimer, &QTimer::timeout, this, &GPS::handleTimeout);
    m_serialport->close();
    m_dashboard->setgpsFIXtype("");
}

void GPS::handleError(QSerialPort::SerialPortError serialPortError)
{
    if (m_serialport->errorString() == "No error") {
        // do nothing
    }
}

void GPS::readyToRead()
{
    QByteArray rawData = m_serialport->readAll();
    line.append(rawData);
    while (line.contains("\r\n"))
    {
        int end = line.indexOf("\r\n") + 2;
        QByteArray message = line;
        message.remove(end, line.length());
        line.remove(0, end);
        ProcessMessage(message);
    }
}

void GPS::ProcessMessage(QByteArray messageline)
{
    m_timeouttimer.stop();
    m_timeouttimer.start(8000);

    if (messageline.contains(ACK10HZ)) {
        rateset = 1;
        if (setbaudrate == "9600")
        {
            removeNMEAmsg();
            setGPSBAUD115();
        }
        return;
    }

    if (!messageline.startsWith("$G")) {
        return;
    }

    if (m_dashboard->NMEAlog() == 1) {
        logNMEA(messageline);
    }

    if (messageline.mid(3, 3) == "GGA") {
        if (rateset == 0) {
            setGPS10HZ();
        }
        processGPGGA(messageline);
    }
    if (messageline.mid(3, 3) == "RMC") {
        processGPRMC(messageline);
    }
}

void GPS::logNMEA(const QString & line)
{
    QString logfile = QString("%1/%2.nmea").arg("/home/pi").arg(QDate::currentDate().toString("yyyyMMdd"));
    QFile file(logfile);
    if (!file.open(QIODevice::Append)) {
        return;
    }
    QTextStream out(&file);
    out << line;
    file.close();
}

void GPS::handleTimeout()
{
    m_timeouttimer.stop();
    closeConnection();
    rateset = 0;
    m_dashboard->setgpsLatitude(0);
    m_dashboard->setgpsLongitude(0);
    m_dashboard->setgpsAltitude(0);
    m_dashboard->setgpsVisibleSatelites(0);
    m_dashboard->setgpsbearing(0);
    m_dashboard->setgpsSpeed(0);
    m_dashboard->setgpsTime("0");
    m_dashboard->setgpsHDOP(0);

    QTimer::singleShot(2000, this, SLOT(handleReconnect()));
}

void GPS::handleReconnect()
{
    if (setbaudrate != "9600") {
        openConnection(GPSPort, "9600");
    } else {
        openConnection(GPSPort, "115200");
    }
}

void GPS::processGPRMC(const QString & line)
{
    QStringList fields = line.split(',');

    // Only check if time field is valid
    bool invalidTime = fields[1].isEmpty();

    if (invalidTime) {
        invalidRMCCount++;
        if (invalidRMCCount >= maxInvalidRMC) {
           // qDebug() << "Received" << maxInvalidRMC << "invalid GPRMC messages (time field empty), reconnecting...";
            invalidRMCCount = 0;
            handleTimeout();
        }
        return;
    }

    invalidRMCCount = 0;

    m_timeouttimer.stop();
    m_timeouttimer.start(8000);

    QString time = fields[1];
    time.insert(2, ":");
    time.insert(5, ":");

    float decLat = convertToFloat(fields[3], fields[4]);
    float decLon = convertToFloat(fields[5], fields[6]);

    QString groundspeedknots = fields[7];
    QString bearing = fields[8];
    if (!bearing.isEmpty()) {
        m_dashboard->setgpsbearing(bearing.toDouble());
    }

    double speed = groundspeedknots.toDouble() * 1.852;

    if ((m_dashboard->gpsFIXtype() == "GPS only") || (m_dashboard->gpsFIXtype() == "DGPS")) {
        m_dashboard->setgpsLatitude(decLat);
        m_dashboard->setgpsLongitude(decLon);
        m_dashboard->setgpsSpeed(qRound(speed));
        checknewLap();
    }

    m_dashboard->setgpsTime(time);
}

void GPS::processGPGGA(const QString & line)
{
    QStringList fields = line.split(',');

    int fixquality = fields[6].toInt();
    hdop = fields[8].toFloat();
    m_dashboard->setgpsHDOP(hdop);

    switch (fixquality) {
    case 0:
        m_dashboard->setgpsFIXtype("No fix yet");
        break;
    case 1:
        m_dashboard->setgpsFIXtype("GPS only");
        break;
    case 2:
        m_dashboard->setgpsFIXtype("DGPS");
        break;
    default:
        m_dashboard->setgpsFIXtype("No fix yet");
        break;
    }

    float decLat = convertToFloat(fields[2], fields[3]);
    float decLon = convertToFloat(fields[4], fields[5]);

    QString satelitesinview = fields[7];
    QString altitude = fields[9];
    if ((m_dashboard->gpsFIXtype() == "GPS only") ||(m_dashboard->gpsFIXtype() == "DGPS") )
    {
        m_dashboard->setgpsLatitude(decLat);
        m_dashboard->setgpsLongitude(decLon);
        m_dashboard->setgpsAltitude(altitude.toDouble());
        checknewLap();
    }
    m_dashboard->setgpsVisibleSatelites(satelitesinview.toInt());
}

float GPS::convertToFloat(const QString & coord, const QString & dir)
{
    int decIndex = coord.indexOf('.');
    QString minutes = coord.mid(decIndex - 2);
    float dec = minutes.toDouble() / 60.0;
    float degrees = coord.mid(0, decIndex - 2).toDouble();
    float decCoord = dec + degrees;
    if (dir == "W" || dir == "S")
        decCoord *= -1.0;
    return decCoord;
}

// Laptimer
void GPS::defineFinishLine(const qreal & Y1, const qreal & X1, const qreal & Y2, const qreal & X2)
{
    // linedirection = linedir;

    startlineX1 = X1;  // Longitude
    startlineX2 = X2;  // Longitude
    startlineY1 = Y1;  // Latitude
    startlineY2 = Y2;  // Latitude
    m = (startlineY1-startlineY2) / (startlineX1-startlineX2);

    if (startlineX1 == startlineX2)
    {
         b = startlineY1;
        zeroslope = 0;
    }

    if (startlineY1 == startlineY2)
    {
        zeroslope = 0;
        b = startlineY1;
    }
    if ((startlineY1 != startlineY2) && (startlineX1 != startlineX2))
    {
        zeroslope = 1;
        b = startlineY1 - (m*startlineX1);
    }
}

void GPS::defineFinishLine2(const qreal & Y1, const qreal & X1, const qreal & Y2, const qreal & X2)
{
    start2lineX1 = X1;  // Longitude
    start2lineX2 = X2;  // Longitude
    start2lineY1 = Y1;  // Latitude
    start2lineY2 = Y2;  // Latitude
    m2 = (start2lineY1-start2lineY2) / (start2lineX1-start2lineX2);
    if (start2lineX1 ==  start2lineX2) {
         b2 = start2lineY1;
        zeroslope2 = 0;
    }
    if (start2lineY1 ==  start2lineY2) {
        zeroslope2 = 0;
        b2 = start2lineY1;
    }
    if ((start2lineX1 !=  start2lineX2) && (start2lineY1 !=  start2lineY2)) {
        zeroslope2 = 1;
        b2 = start2lineY1 - (m2*start2lineX1);
    }
}
void GPS::resetLaptimer()
{
    Laps = 0;
    m_timer.invalidate();
    m_dashboard->setbestlaptime("00:00.000");
}
void GPS::checknewLap()
{
    // Somehow we need to add something that if the Second Finishline exists it needs to stop the timer
    // needed for Finish Line1

    // Somehow we need to add something that if the Second Finishline exists it needs to stop the timer
    if (zeroslope == 1) {
        currentintercept = m_dashboard->gpsLatitude() -( (m * m_dashboard->gpsLongitude()) + b);     // needed for Finish Line1
    }
    if (zeroslope == 0) {
        currentintercept = m_dashboard->gpsLatitude() - b;
    }

    // Intercept 2  for second finish line

    if (zeroslope2 != 0) {
        currentintercept2 = m_dashboard->gpsLatitude() -( (m2 * m_dashboard->gpsLongitude()) + b2);  // needed for Finish Line2
    } else {
        currentintercept2 = m_dashboard->gpsLatitude() - b2;  // needed for Finish Line2
    }

    if ((previousintercept <= 0 && currentintercept >= 0) || (previousintercept >= 0 && currentintercept <= 0) || (currentintercept == 0) ||(previousintercept2 <= 0 && currentintercept2 >= 0) || (previousintercept2 >= 0 && currentintercept2 <= 0) || (currentintercept2 == 0))
    {
        // Finish Line 1
        if ((((m_dashboard->gpsLongitude() <= startlineX2 && m_dashboard->gpsLongitude() >= startlineX1 )) || ((m_dashboard->gpsLatitude() <= startlineY2 && m_dashboard->gpsLatitude() >= startlineY1 ))) ||(((m_dashboard->gpsLongitude() <= startlineX1 && m_dashboard->gpsLongitude() >= startlineX2 )) || ((m_dashboard->gpsLatitude() <= startlineY1 && m_dashboard->gpsLatitude() >= startlineY2 ))))
        {
            if (m_timer.isValid() == true) {
                QTime y(0, 0);
                y = y.addMSecs(m_timer.elapsed());
                if (Laps == 1)
                {
                    fastestlap = y;
                    m_dashboard->setbestlaptime(fastestlap.toString("mm:ss.zzz"));
                }
                if (y < fastestlap)
                {
                   // // qDebug() << "y is smaller";
                    fastestlap = y;
                    m_dashboard->setbestlaptime(y.toString("mm:ss.zzz"));
                }
                Laps++;
                m_dashboard->setlaptime(y.toString("mm:ss.zzz"));
                m_dashboard->setcurrentLap(Laps);
                if (line2direction == 2) {
                    m_timer.restart();
                } else {
                    m_timer.invalidate();
                }
            } else {
                m_timer.start();
                Laps++;
                m_dashboard->setcurrentLap(Laps);
            }
        }


        if ((((m_dashboard->gpsLongitude() <= start2lineX2 && m_dashboard->gpsLongitude() >= start2lineX1 ))||((m_dashboard->gpsLatitude() <= start2lineY2 && m_dashboard->gpsLatitude() >= start2lineY1 ))) || (((m_dashboard->gpsLongitude() <= start2lineX1 && m_dashboard->gpsLongitude() >= start2lineX2 ))||((m_dashboard->gpsLatitude() <= start2lineY1 && m_dashboard->gpsLatitude() >= start2lineY2 ))))
        {
            if (m_timer.isValid() == true) {
                QTime y(0, 0);
                y = y.addMSecs(m_timer.elapsed());
                if (Laps == 1) {
                    fastestlap = y;
                    m_dashboard->setbestlaptime(fastestlap.toString("mm:ss.zzz"));
                }
                if (y < fastestlap) {
                   // // qDebug() << "y is smaller";
                   fastestlap = y;
                   m_dashboard->setbestlaptime(y.toString("mm:ss.zzz"));
                }
                Laps++;
                m_dashboard->setlaptime(y.toString("mm:ss.zzz"));
                m_dashboard->setcurrentLap(Laps);
                if (line2direction == 2) {
                    m_timer.restart();
                } else {
                    m_timer.invalidate();
                }
            } else {
                m_timer.start();
                Laps++;
                m_dashboard->setcurrentLap(Laps);
            }
        }
    }
    previousintercept = currentintercept;
    previousintercept2 = currentintercept2;
}
