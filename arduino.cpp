#include "arduino.h"
#include "dashboard.h"
#include "connect.h"
#include <QDebug>
#include <QByteArrayMatcher>

Arduino::Arduino(QObject *parent)
    : QObject(parent)
    , m_dashboard(Q_NULLPTR)
{
}

Arduino::Arduino(DashBoard *dashboard, QObject *parent)
    : QObject(parent)
    , m_dashboard(dashboard)
{
}

void Arduino::initSerialPort()
{
    m_serialport = new SerialPort(this);
    connect(this->m_serialport,SIGNAL(readyRead()),this,SLOT(readyToRead()));
    connect(m_serialport, static_cast<void (QSerialPort::*)(QSerialPort::SerialPortError)>(&QSerialPort::error),
            this, &Arduino::handleError);
    m_readData.clear();
   // qDebug("Serial port set for arduino");
}

//function for flushing all serial buffers
void Arduino::clear()
{
    m_serialport->clear();
}


//function to open serial port
void Arduino::openConnection(const QString &portName)
{
   // qDebug()<<"open Arduino  "+portName;

    initSerialPort();
    m_serialport->setPortName(portName);
    m_serialport->setBaudRate(QSerialPort::Baud9600);
    m_serialport->setParity(QSerialPort::NoParity);
    m_serialport->setDataBits(QSerialPort::Data8);
    m_serialport->setStopBits(QSerialPort::OneStop);
    m_serialport->setFlowControl(QSerialPort::NoFlowControl);;

    if(m_serialport->open(QIODevice::ReadWrite) == false)
    {
        Arduino::closeConnection();
     //   qDebug("no arduino");
    }
    else
    {
      //  qDebug("arduino connected");

    }

}
void Arduino::closeConnection()
{
    disconnect(this->m_serialport,SIGNAL(readyRead()),this,SLOT(readyToRead()));
    disconnect(m_serialport, static_cast<void (QSerialPort::*)(QSerialPort::SerialPortError)>(&QSerialPort::error),
               this, &Arduino::handleError);
    m_serialport->close();
    m_dashboard->setSerialSpeed(0);
    m_dashboard->setSerialSpeed(0);
    m_dashboard->setSerialSpeed(0);
    m_dashboard->setSerialSpeed(0);
    m_dashboard->setSerialSpeed(0);
    m_dashboard->setSerialSpeed(0);
    m_dashboard->setSerialSpeed(0);
    m_dashboard->setSerialSpeed(0);
    m_dashboard->setSerialSpeed(0);

}



void Arduino::handleError(QSerialPort::SerialPortError serialPortError)
{
    if (serialPortError == QSerialPort::ReadError) {
        QString fileName = "Errors.txt";
        QFile mFile(fileName);
        if(!mFile.open(QFile::Append | QFile::Text)){
        }
        QTextStream out(&mFile);
        out << "Serial Error " << (m_serialport->errorString()) <<endl;
        mFile.close();
        m_dashboard->setSerialStat(m_serialport->errorString());

    }
}



void Arduino::readyToRead()
{

    QByteArray test;
    test =m_readData = m_serialport->readAll();
    /*
    QString fileName = "AdaptronicOutputTest.txt";
    QFile mFile(fileName);
    if(!mFile.open(QFile::Append | QFile::Text)){
    }
    QTextStream out(&mFile);
    out  << (test.toHex()) <<endl;
    mFile.close();*/
    m_dashboard->setSerialStat(test.toHex());
    //qDebug()<< "Arduino"+m_readData;
    Arduino::assemblemessage(m_readData);
}


void Arduino::assemblemessage(const QByteArray &buffer)
{

    m_buffer.append(buffer);
    QByteArray message = m_buffer;
    if(m_buffer.contains("\r\n"))
    {
        int end = m_buffer.indexOf("\r\n") + 2;
        message.remove(m_buffer.indexOf("\r\n"), end);
        m_buffer.clear();

        bool ok = false;
        float value = message.toFloat(&ok);

        if (!ok)
        {
            qDebug() << "Conversion failed";
        }

        else
        {

            m_dashboard->setSerialSpeed(value);
        }


    }

}
