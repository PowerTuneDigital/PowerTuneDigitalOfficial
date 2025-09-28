#include <QDebug>
#include <QByteArrayMatcher>
#include <QTime>
#include <QTimer>

#include "gps.h"
#include "dashboard.h"
#include "connect.h"

int initialized = 0;
int rateset10hz = 0;
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
QString setbaud;
int gpsminute;
int gpssecond;
int dst;

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
    // qDebug() << "Initialize Serial Port" ;
    m_serialport = new SerialPort(this);
    connect(this->m_serialport, SIGNAL(readyRead()), this, SLOT(readyToRead()));
    connect(&m_timeouttimer, &QTimer::timeout, this, &GPS::handleTimeout);
}

// function for flushing all serial buffers
void GPS::clear()
{
    m_serialport->clear();
}
// function to open serial port
void GPS::openConnection(const QString &portName, const QString &Baud)
{
    GPSPort = portName;
    setbaud = Baud;
            logNMEA("openConnection Entered " + GPSPort + " @ " + Baud + " \r\n");
    // qDebug()<< " Open GPS on: " + GPSPort + "@" + Baud;
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
        m_dashboard->setgpsFIXtype("Start 9600");
        break;
    case 115200:
        m_serialport->setBaudRate(QSerialPort::Baud115200);
        m_dashboard->setgpsFIXtype("Start 115200");
        break;
    default:
        m_serialport->setBaudRate(QSerialPort::Baud9600);
        m_dashboard->setgpsFIXtype("Start Default");
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
    // qDebug() << "removeNMEAmsg - Disable unwanted NMEA messages" ;
    // disables all the NMEA mesages that we don't need ( we only need RMC and  GGA)
    m_dashboard->setgpsFIXtype("CFG GPS");
    m_timeouttimer.stop();
    logNMEA("Removing GNSS \r\n");
    m_serialport->write(QByteArray::fromHex("B562063E3C000000200700031000010001010101030001000101020408000000000103081000000000010400080000000001050003000100050106080E0000000001294A"));  // GNSS Config
    m_serialport->waitForBytesWritten(4000);
    logNMEA("Removing NAV5 \r\n");
    m_serialport->write(QByteArray::fromHex("B56206242400FFFF040300000000102700000500FA00FA0064005E01003C00000000000000000000000082C4"));  // NAV5 Config
    m_serialport->waitForBytesWritten(4000);
    logNMEA("Removing PMS \r\n");
    m_serialport->write(QByteArray::fromHex("B562068608000000000000000000945A"));  // PMS Config
    m_serialport->waitForBytesWritten(4000);
    logNMEA("Removing PM2 \r\n");
    m_serialport->write(QByteArray::fromHex("B562063B2C00010600000E104301E80300001027000000000000000000002C0100004FC1030086020000FE000000644001006310"));  // PM2 Config
    m_serialport->waitForBytesWritten(4000);
    logNMEA("Removing RXM \r\n");
    m_serialport->write(QByteArray::fromHex("B5620611020048006111"));  // RXM Config
    m_serialport->waitForBytesWritten(4000);
    logNMEA("Removing SBAS \r\n");
    m_serialport->write(QByteArray::fromHex("B562061608000103030000E804001779"));  // SBAS Config
    m_serialport->waitForBytesWritten(4000);
    logNMEA("Removing VTG \r\n");
    m_serialport->write(QByteArray::fromHex("B56206010800F0050000000000000446"));  // VTG OFF
    m_serialport->waitForBytesWritten(4000);
    logNMEA("Removing GSA \r\n");
    m_serialport->write(QByteArray::fromHex("B56206010800F0020000000000000131"));  // GSA_Off
    m_serialport->waitForBytesWritten(4000);
    logNMEA("Removing GSV \r\n");
    m_serialport->write(QByteArray::fromHex("B56206010800F0030000000000000238"));  // GSV_Off
    m_serialport->waitForBytesWritten(4000);
    logNMEA("Removing GLL \r\n");
    m_serialport->write(QByteArray::fromHex("B56206010800F001000000000000002A"));  // GLL_Off
    m_serialport->waitForBytesWritten(4000);
    logNMEA("Removing ZDA \r\n");
    m_serialport->write(QByteArray::fromHex("B56206010800F008000000000000075B"));  // ZDA_Off
    m_serialport->waitForBytesWritten(4000);
    m_timeouttimer.start(10000);
    logNMEA("Finished Removing NMEAmsg \r\n");
}
void GPS::setGPSBAUD115()
{
    // qDebug() << "Set GPSBAUD115";
    m_dashboard->setgpsFIXtype("GPS set 115k");
    m_serialport->write(QByteArray::fromHex("B5620600140001000000D008000000C201000700020000000000BF78"));
    m_serialport->waitForBytesWritten(4000);
    initialized = 1;
    handleTimeout();
}
void GPS::setGPS10HZ()
{
    // qDebug() << "Set 10Hz" ;
    // Set Ublox GPS Update Rate to 10Hz
    m_dashboard->setgpsFIXtype("GPS set 10HZ");
    logNMEA("Setting 10Hz \r\n");
    m_serialport->write(QByteArray::fromHex("b562060806006400010001007a12"));
    m_serialport->waitForBytesWritten(4000);
    logNMEA("Removing NMEAmsg \r\n");
    removeNMEAmsg();

}
//void GPS::setGPSOnly()
//{
    // Switch on GPS only
    // qDebug() << "set GPS only" ;
//    m_serialport->write(QByteArray::fromHex("B562063E2C0000201005000810000100010101010300000001010308100000000101050003000000010106080E00000001010CD1"));  // GPS Only
//    m_serialport->waitForBytesWritten(4000);
//}
void GPS::closeConnection()
{
            logNMEA("closeConnection Entered \r\n");
    // qDebug() << "close connection " ;
    disconnect(this->m_serialport, SIGNAL(readyRead()), this, SLOT(readyToRead()));
    disconnect(m_serialport, static_cast<void (QSerialPort::*)(QSerialPort::SerialPortError)>(&QSerialPort::error),
               this, &GPS::handleError);
    disconnect(&m_timeouttimer, &QTimer::timeout, this, &GPS::handleTimeout);
    m_serialport->close();
    m_dashboard->setgpsFIXtype("closeConnection");
}

void GPS::handleError(QSerialPort::SerialPortError serialPortError)
{
    if (m_serialport->errorString() == "No error")
    {
        // qDebug() << "handle error" << m_serialport->errorString() ;
    }
}

void GPS::readyToRead()
{
//			logNMEA("  readyToRead Entered \r\n");
    // qDebug()<< "Process Message";
    QByteArray rawData = m_serialport->readAll();          // read data from serial port
    // qDebug()<< "chunk " << rawData;
    line.append(rawData);
    while (line.contains("\r\n"))
    {
        int end = line.indexOf("\r\n") + 2;
        QByteArray message = line;
//        // qDebug()<< "line raw" << line;
        message.remove(end, line.length());
        line.remove(0, end);
//        // qDebug()<< "line new" << line;
        ProcessMessage(message);
    }
}


void GPS::ProcessMessage(QByteArray messageline)
{
//			logNMEA("  ProcessMessage Entered \r\n");
    // qDebug()<< "Process Message" << messageline;
    m_timeouttimer.stop();
    m_timeouttimer.start(10000);
    // First, we handle any potential binary messages
    if (messageline.contains(ACK10HZ)) {
            logNMEA("ACK10Hz Received \r\n");
        // qDebug() << "Received ACK 10Hz";
        m_dashboard->setgpsFIXtype("10Hz ACK");
        rateset10hz = 1;
        if (setbaud == "9600")
        {
//			logNMEA("Removing NMEAmsg \r\n");
//        removeNMEAmsg();
            logNMEA("Set GPS module Baud to 11200 \r\n");
        setGPSBAUD115();
        }
        return;
    }

    // Then we check if the message looks like a valid NMEA message
    if (!messageline.startsWith("$G")) {
        // qDebug() << "Not a NMEA message" << messageline.toHex();
        return;
    }

    if (m_dashboard->NMEAlog() ==1 )
    {
    logNMEA(messageline);
    }
    // Then we process the message
    if (messageline.mid(3, 3) == "GGA") {
        // Check if we have already set the refresh rate
        if (rateset10hz == 0) {
            // qDebug() << "GoTo setGPS10HZ";
            setGPS10HZ();
        }
        processGPGGA(messageline);
    }
    if (messageline.mid(3, 3) == "RMC") {
        processGPRMC(messageline);
    }
}

void GPS::logNMEA(const QString & line){
    // Check if a log file for today already exists
    QString logfile = QString("%1/%2.nmea").arg("/home/pi").arg(QDate::currentDate().toString("yyyyMMdd"));
    QFile file(logfile);
    if (!file.open(QIODevice::Append)) {
        // qDebug() << "Could not open log file" << logfile;
        return;
    }
    QTextStream out(&file);
    out << line;
    file.close();
}

void GPS::handleTimeout()
{
    // Timeout will occur if no valid GPS message is received for 10 seconds
    // Reset all GPS values to 0 and also reset the 10Hz set marker
    // qDebug() << "Timeout occured" ;
            logNMEA("handleTimeout Entered \r\n");
    m_dashboard->setgpsFIXtype("handle Timeout");
    m_timeouttimer.stop();
    closeConnection();
    rateset10hz = 0;
    m_dashboard->setgpsLatitude(0);
    m_dashboard->setgpsLongitude(0);
    m_dashboard->setgpsAltitude(0);
    m_dashboard->setgpsVisibleSatelites(0);
    m_dashboard->setgpsbearing(0);
    m_dashboard->setgpsSpeed(0);
    m_dashboard->setgpsTime("xx:xx:xx.xx"); // MLA
    m_dashboard->setgpsHDOP(0);
    // wait 2 seconds before reconnecting
    QTimer::singleShot(2000, this, SLOT(handleReconnect()));
}

void GPS::handleReconnect()
{
            logNMEA("handleReconnect Entered \r\n");
   // qDebug() << "Reconnecting " ;
    // Timeout will occur if no valid GPS message is reveived for 10 seconds
    m_dashboard->setgpsFIXtype("handle Reconnect");
    // Check what baudrate was used previously and switch
    if (setbaud != "9600")
    {
            logNMEA("Reconnect at 9600 \r\n");
    openConnection(GPSPort, "9600");
    }
    else
    {
            logNMEA("Reconnect at 115200 \r\n");
    openConnection(GPSPort, "115200");
    }
}

void GPS::processGPRMC(const QString & line) {
    QStringList fields = line.split(',');
    QString time = fields[1];

    time.insert(2, ":");
    time.insert(5, ":");

    QString groundspeedknots = fields[7];
    double speed = groundspeedknots.toDouble() * 1.852; // Convert knots to kph
    m_dashboard->setgpsSpeed(qRound(speed));  //MLA round speed to the nearest integer

    QString bearing = fields[8];
    m_dashboard->setgpsbearing(bearing.toDouble());

    m_dashboard->setgpsTime(time);
    // Get GPS date and turn into an integer to use to compare for DST
    QString strdd = fields[9].mid(0,2);
    QString strmm = fields[9].mid(2,2);
    QString stryy = fields[9].mid(4,2);
    double gpsdate = stryy.toInt()*10000 + strmm.toInt()*100 + strdd.toInt();

    // Check for DST through 2030
    if (((gpsdate >= 250309) && (gpsdate <= 251102)) || ((gpsdate >= 260326) && (gpsdate <= 261126)) || ((gpsdate >= 270314) && (gpsdate <= 271107)) || ((gpsdate >= 280328) && (gpsdate <= 281105)) || ((gpsdate >= 290311) && (gpsdate <= 291104)) || ((gpsdate >= 300310) && (gpsdate <= 301103)))
    {
        dst = 1;
    }
    else
    {
        dst = 0;
    }

    //	break out hours, minutes and seconds into integers
    QString strgpshour = time.mid(0,2);
    QString strgpsminute = time.mid(3,2);
    QString strgpssecond = time.mid(6,2);

    //	Adust hour for central time, DST and to 12 hour, scale 0 to 60 ~~ (hour * 60 + minutes)/12

    int gpshour = (((strgpshour.toInt() + 18 + dst) % 12) * 60 + strgpsminute.toInt()) / 12;
    int gpsminute = strgpsminute.toInt();
    int gpssecond = strgpssecond.toInt();
    //	put variables hours, minutes and seconds into "spare" global variables
    m_dashboard->setsens1(gpshour);
    m_dashboard->setsens2(gpsminute);
    m_dashboard->setsens3(gpssecond);
}


void GPS::processGPGGA(const QString & line) { // Get the values we want from here or that are not available in GPRMC message
    QStringList fields = line.split(',');

    int fixquality = fields[6].toInt();
    switch (fixquality) {
    case 0:
        m_dashboard->setgpsFIXtype("No fix yet");
        break;
    case 1:
        m_dashboard->setgpsFIXtype("GPS fix");
        break;
    case 2:
        m_dashboard->setgpsFIXtype("DGPS fix");
        break;
    default:
        m_dashboard->setgpsFIXtype("No fix yet");
        break;
    }

    hdop = fields[8].toFloat();
    m_dashboard->setgpsHDOP(hdop);

    float decLat = convertToFloat(fields[2], fields[3]);
    float decLon = convertToFloat(fields[4], fields[5]);
    m_dashboard->setgpsLatitude(decLat);
    m_dashboard->setgpsLongitude(decLon);

    QString satelitesinview = fields[7];
    m_dashboard->setgpsVisibleSatelites(satelitesinview.toInt());

    QString altitude = fields[9];
    m_dashboard->setgpsAltitude(altitude.toDouble());

    checknewLap();
}
float GPS::convertToFloat(const QString & coord, const QString & dir)
{
    int decIndex = coord.indexOf('.');
    QString minutes = coord.mid(decIndex- 2);
    QString seconds = coord.mid(decIndex+1, 2);
    float dec = minutes.toDouble() * 60 / 3600;
    float degrees = coord.mid(0, decIndex -2).toDouble();
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
