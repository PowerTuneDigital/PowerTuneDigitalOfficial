#include "appsettings.h"
#include "dashboard.h"
#include <QSettings>
#include <QDebug>

AppSettings::AppSettings(QObject *parent)
    : QObject(parent)
    , m_dashboard(Q_NULLPTR)


{

}
AppSettings::AppSettings(DashBoard *dashboard, QObject *parent)
    : QObject(parent)
    , m_dashboard(dashboard)

{
}
int AppSettings::getBaudRate()
{
    return getValue("serial/baudrate").toInt();
}

void AppSettings::setBaudRate(const int &arg)
{
    setValue("serial/baudrate", arg);
}

int AppSettings::getParity()
{
    return getValue("serial/parity").toInt();
}

void AppSettings::setParity(const int &arg)
{
    setValue("serial/parity", arg);
}

int AppSettings::getDataBits()
{
    return getValue("serial/databits").toInt();
}

void AppSettings::setDataBits(const int &arg)
{
    setValue("serial/databits", arg);
}

int AppSettings::getStopBits()
{
    return getValue("serial/stopbits").toInt();
}

void AppSettings::setStopBits(const int &arg)
{
    setValue("serial/stopbits", arg);
}

int AppSettings::getFlowControl()
{
    return getValue("serial/flowcontrol").toInt();
}

void AppSettings::setFlowControl(const int &arg)
{
    setValue("serial/flowcontrol", arg);
}

int AppSettings::getECU()
{
    return getValue("serial/ECU").toInt();

}

void AppSettings::setECU(const int &arg)
{
    setValue("serial/ECU", arg);
}

int AppSettings::getInterface()
{
    return getValue("serial/Interface").toInt();

}

void AppSettings::setInterface(const int &arg)
{
    setValue("serial/Interface", arg);
}

int AppSettings::getLogging()
{
    return getValue("serial/Logging").toInt();

}

void AppSettings::setLogging(const int &arg)
{
    setValue("serial/Logging", arg);
}

void AppSettings::setValue(const QString &key, const QVariant &value)
{
    QSettings settings("PowerTuneQML", "PowerTuneQMLGUI", this);
    settings.setValue(key, value);
}

QVariant AppSettings::getValue(const QString &key)
{
    QSettings settings("PowerTuneQML", "PowerTuneQMLGUI", this);
    return settings.value(key);
}
// Saving

void AppSettings::writeMainSettings()
{

    //PowerTuneQML.setValue("serial/stopbits", arg);
    //PowerTunesettings.beginGroup("MainWindow");
    //PowerTunesettings.setValue("size", size());
    //PowerTunesettings.setValue("pos", pos());
    //PowerTunesettings.endGroup();
}

void AppSettings::writeSelectedDashSettings(int numberofdashes)
{
     setValue("Number of Dashes",numberofdashes);
     qDebug()<< "SAVED DASH" << getValue("Number of Dashes");

}

void AppSettings::writeWarnGearSettings()
{


}
void AppSettings::writeSpeedSettings()
{

}
void AppSettings::writeAnalogSettings(const qreal &A00,const qreal &A05,const qreal &A10,const qreal &A15,const qreal &A20,const qreal &A25,const qreal &A30,const qreal &A35,const qreal &A40,const qreal &A45,const qreal &A50,const qreal &A55,const qreal &A60,const qreal &A65,const qreal &A70,const qreal &A75,const qreal &A80,const qreal &A85,const qreal &A90,const qreal &A95,const qreal &A100,const qreal &A105)
{
    setValue("AN00",A00);
    setValue("AN05",A05);
    setValue("AN10",A10);
    setValue("AN15",A15);
    setValue("AN20",A20);
    setValue("AN25",A25);
    setValue("AN30",A30);
    setValue("AN35",A35);
    setValue("AN40",A40);
    setValue("AN45",A45);
    setValue("AN50",A50);
    setValue("AN55",A55);
    setValue("AN60",A60);
    setValue("AN65",A65);
    setValue("AN70",A70);
    setValue("AN75",A75);
    setValue("AN80",A80);
    setValue("AN85",A85);
    setValue("AN90",A90);
    setValue("AN95",A95);
    setValue("AN100",A100);
    setValue("AN105",A105);
    //Apply changed Settings
    m_dashboard->setAnalogVal(getValue("AN00").toReal(),getValue("AN05").toReal(),getValue("AN10").toReal(),getValue("AN15").toReal(),getValue("AN20").toReal(),getValue("AN25").toReal(),getValue("AN30").toReal(),getValue("AN35").toReal(),getValue("AN40").toReal(),getValue("AN45").toReal(),getValue("AN50").toReal(),getValue("AN55").toReal(),getValue("AN60").toReal(),getValue("AN65").toReal(),getValue("AN70").toReal(),getValue("AN75").toReal(),getValue("AN80").toReal(),getValue("AN85").toReal(),getValue("AN90").toReal(),getValue("AN95").toReal(),getValue("AN100").toReal(),getValue("AN105").toReal());


}
void AppSettings::writeRPMSettings()
{


}
void AppSettings::writeEXBoardSettings()
{


}
void AppSettings::writeStartupSettings()
{


}
void AppSettings::readandApplySettings()
{

    //Set Analog Input Settings
    m_dashboard->setAnalogVal(getValue("AN00").toReal(),getValue("AN05").toReal(),getValue("AN10").toReal(),getValue("AN15").toReal(),getValue("AN20").toReal(),getValue("AN25").toReal(),getValue("AN30").toReal(),getValue("AN35").toReal(),getValue("AN40").toReal(),getValue("AN45").toReal(),getValue("AN50").toReal(),getValue("AN55").toReal(),getValue("AN60").toReal(),getValue("AN65").toReal(),getValue("AN70").toReal(),getValue("AN75").toReal(),getValue("AN80").toReal(),getValue("AN85").toReal(),getValue("AN90").toReal(),getValue("AN95").toReal(),getValue("AN100").toReal(),getValue("AN105").toReal());
    //m_dashboard->setVisibledashes(getValue("Number of Dashes").toInt());
}

