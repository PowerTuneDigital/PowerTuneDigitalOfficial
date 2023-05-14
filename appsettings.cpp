#include <QSettings>
#include <QDebug>
#include "appsettings.h"
#include "dashboard.h"

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

AppSettings::~AppSettings()
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
    QSettings settings("PowerTuneQML", "PowerTuneDash", this);
    settings.setValue(key, value);
}

QVariant AppSettings::getValue(const QString &key)
{
    QSettings settings("PowerTuneQML", "PowerTuneDash", this);
    return settings.value(key);
}
void AppSettings::writeMainSettings()
{
    // To be implemented later
}
void AppSettings::writeSelectedDashSettings(int numberofdashes)
{
     setValue("Number of Dashes", numberofdashes);
     // To be implemented later
}

void AppSettings::writeWarnGearSettings(const qreal &waterwarn,const qreal &boostwarn,const qreal &rpmwarn,const qreal &knockwarn,const int &gercalactive,const qreal&lambdamultiply,const qreal &valgear1,const qreal &valgear2,const qreal &valgear3,const qreal &valgear4,const qreal &valgear5,const qreal &valgear6)
{
    setValue("waterwarn", waterwarn);
    setValue("boostwarn", boostwarn);
    setValue("rpmwarn", rpmwarn);
    setValue("knockwarn", knockwarn);
    setValue("gercalactive", gercalactive);
    setValue("lambdamultiply", lambdamultiply);
    setValue("valgear1", valgear1);
    setValue("valgear2", valgear2);
    setValue("valgear3", valgear3);
    setValue("valgear4", valgear4);
    setValue("valgear5", valgear5);
    setValue("valgear6", valgear6);
    m_dashboard->setwaterwarn(waterwarn);
    m_dashboard->setboostwarn(boostwarn);
    m_dashboard->setrpmwarn(rpmwarn);
    m_dashboard->setknockwarn(knockwarn);
    m_dashboard->setgearcalcactivation(gercalactive);
    m_dashboard->setLambdamultiply(lambdamultiply);
    m_dashboard->setgearcalc1(valgear1);
    m_dashboard->setgearcalc2(valgear2);
    m_dashboard->setgearcalc3(valgear3);
    m_dashboard->setgearcalc4(valgear4);
    m_dashboard->setgearcalc5(valgear5);
    m_dashboard->setgearcalc6(valgear6);
}
void AppSettings::writeSpeedSettings(const qreal &Speedcorrection)
{
    setValue("Speedcorrection",Speedcorrection);
    m_dashboard->setspeedpercent(getValue("Speedcorrection").toReal());
}
void AppSettings::writeAnalogSettings(const qreal &A00,const qreal &A05,const qreal &A10,const qreal &A15,const qreal &A20,const qreal &A25,const qreal &A30,const qreal &A35,const qreal &A40,const qreal &A45,const qreal &A50,const qreal &A55,const qreal &A60,const qreal &A65,const qreal &A70,const qreal &A75,const qreal &A80,const qreal &A85,const qreal &A90,const qreal &A95,const qreal &A100,const qreal &A105)
{
    setValue("AN00", A00);
    setValue("AN05", A05);
    setValue("AN10", A10);
    setValue("AN15", A15);
    setValue("AN20", A20);
    setValue("AN25", A25);
    setValue("AN30", A30);
    setValue("AN35", A35);
    setValue("AN40", A40);
    setValue("AN45", A45);
    setValue("AN50", A50);
    setValue("AN55", A55);
    setValue("AN60", A60);
    setValue("AN65", A65);
    setValue("AN70", A70);
    setValue("AN75", A75);
    setValue("AN80", A80);
    setValue("AN85", A85);
    setValue("AN90", A90);
    setValue("AN95", A95);
    setValue("AN100", A100);
    setValue("AN105", A105);
    m_dashboard->setAnalogVal(getValue("AN00").toReal(),getValue("AN05").toReal(),getValue("AN10").toReal(),getValue("AN15").toReal(),getValue("AN20").toReal(),getValue("AN25").toReal(),getValue("AN30").toReal(),getValue("AN35").toReal(),getValue("AN40").toReal(),getValue("AN45").toReal(),getValue("AN50").toReal(),getValue("AN55").toReal(),getValue("AN60").toReal(),getValue("AN65").toReal(),getValue("AN70").toReal(),getValue("AN75").toReal(),getValue("AN80").toReal(),getValue("AN85").toReal(),getValue("AN90").toReal(),getValue("AN95").toReal(),getValue("AN100").toReal(),getValue("AN105").toReal());

}
void AppSettings::writeRPMSettings(const int &mxrpm,const int &shift1,const int &shift2,const int &shift3,const int &shift4)
{
    setValue("Max RPM", mxrpm);
    setValue("Shift Light1", shift1);
    setValue("Shift Light2", shift2);
    setValue("Shift Light3", shift3);
    setValue("Shift Light4", shift4);
    m_dashboard->setmaxRPM(getValue("Max RPM").toInt());
    m_dashboard->setrpmStage1(getValue("Shift Light1").toInt());
    m_dashboard->setrpmStage2(getValue("Shift Light2").toInt());
    m_dashboard->setrpmStage3(getValue("Shift Light3").toInt());
    m_dashboard->setrpmStage4(getValue("Shift Light4").toInt());
}
void AppSettings::writeEXBoardSettings(const qreal &EXA00,const qreal &EXA05,const qreal &EXA10,const qreal &EXA15,const qreal &EXA20,const qreal &EXA25,const qreal &EXA30,const qreal &EXA35,const qreal &EXA40,const qreal &EXA45,const qreal &EXA50,const qreal &EXA55,const qreal &EXA60,const qreal &EXA65,const qreal &EXA70,const qreal &EXA75,const int &steinhartcalc0on, const int &steinhartcalc1on, const int &steinhartcalc2on,const int &steinhartcalc3on, const int &steinhartcalc4on, const int &steinhartcalc5on,const int &AN0R3VAL,const int &AN0R4VAL,const int &AN1R3VAL,const int &AN1R4VAL,const int &AN2R3VAL,const int &AN2R4VAL,const int &AN3R3VAL,const int &AN3R4VAL,const int &AN4R3VAL,const int &AN4R4VAL,const int &AN5R3VAL,const int &AN5R4VAL)
{

    setValue("EXA00", EXA00);
    setValue("EXA05", EXA05);
    setValue("EXA10", EXA10);
    setValue("EXA15", EXA15);
    setValue("EXA20", EXA20);
    setValue("EXA25", EXA25);
    setValue("EXA30", EXA30);
    setValue("EXA35", EXA35);
    setValue("EXA40", EXA40);
    setValue("EXA45", EXA45);
    setValue("EXA50", EXA50);
    setValue("EXA55", EXA55);
    setValue("EXA60", EXA60);
    setValue("EXA65", EXA65);
    setValue("EXA70", EXA70);
    setValue("EXA75", EXA75);
    setValue("steinhartcalc0on", steinhartcalc0on);
    setValue("steinhartcalc1on", steinhartcalc1on);
    setValue("steinhartcalc2on", steinhartcalc2on);
    setValue("steinhartcalc3on", steinhartcalc3on);
    setValue("steinhartcalc4on", steinhartcalc4on);
    setValue("steinhartcalc5on", steinhartcalc5on);
    setValue("AN0R3VAL", AN0R3VAL);
    setValue("AN0R4VAL", AN0R4VAL);
    setValue("AN1R3VAL", AN1R3VAL);
    setValue("AN1R4VAL", AN1R4VAL);
    setValue("AN2R3VAL", AN2R3VAL);
    setValue("AN2R4VAL", AN2R4VAL);
    setValue("AN3R3VAL", AN3R3VAL);
    setValue("AN3R4VAL", AN3R4VAL);
    setValue("AN4R3VAL", AN4R3VAL);
    setValue("AN4R4VAL", AN4R4VAL);
    setValue("AN5R3VAL", AN5R3VAL);
    setValue("AN5R4VAL", AN5R4VAL);

    m_dashboard->setEXAnalogVal(getValue("EXA00").toReal(),getValue("EXA05").toReal(),getValue("EXA10").toReal(),getValue("EXA15").toReal(),getValue("EXA20").toReal(),getValue("EXA25").toReal(),getValue("EXA30").toReal(),getValue("EXA35").toReal(),getValue("EXA40").toReal(),getValue("EXA45").toReal(),getValue("EXA50").toReal(),getValue("EXA55").toReal(),getValue("EXA60").toReal(),getValue("EXA65").toReal(),getValue("EXA70").toReal(),getValue("EXA75").toReal(),getValue("steinhartcalc0on").toInt(),getValue("steinhartcalc1on").toInt(),getValue("steinhartcalc2on").toInt(),getValue("steinhartcalc3on").toInt(),getValue("steinhartcalc4on").toInt(),getValue("steinhartcalc5on").toInt(),getValue("AN0R3VAL").toInt(), getValue("AN0R4VAL").toInt(),getValue("AN1R3VAL").toInt(),getValue("AN1R4VAL").toInt(),getValue("AN2R3VAL").toInt(),getValue("AN2R4VAL").toInt() ,getValue("AN3R3VAL").toInt(), getValue("AN3R4VAL").toInt(),getValue("AN4R3VAL").toInt(),getValue("AN4R4VAL").toInt(),getValue("AN5R3VAL").toInt(),getValue("AN5R4VAL").toInt());
}
void AppSettings::writeEXAN7dampingSettings(const int &AN7damping)
{
    setValue("AN7Damping",AN7damping);
    m_dashboard->setsmootexAnalogInput7(getValue("AN7Damping").toInt());
}
void AppSettings::writeSteinhartSettings(const qreal &T01,const qreal &T02,const qreal &T03,const qreal &R01,const qreal &R02,const qreal &R03,const qreal &T11,const qreal &T12,const qreal &T13,const qreal &R11,const qreal &R12,const qreal &R13,const qreal &T21,const qreal &T22,const qreal &T23,const qreal &R21,const qreal &R22,const qreal &R23, const qreal &T31,const qreal &T32,const qreal &T33,const qreal &R31,const qreal &R32,const qreal &R33, const qreal &T41,const qreal &T42,const qreal &T43,const qreal &R41,const qreal &R42,const qreal &R43, const qreal &T51,const qreal &T52,const qreal &T53,const qreal &R51,const qreal &R52,const qreal &R53)
{

    setValue("T01", T01);
    setValue("T02", T02);
    setValue("T03", T03);
    setValue("R01", R01);
    setValue("R02", R02);
    setValue("R03", R03);
    setValue("T11", T11);
    setValue("T12", T12);
    setValue("T13", T13);
    setValue("R11", R11);
    setValue("R12", R12);
    setValue("R13", R13);
    setValue("T21", T21);
    setValue("T22", T22);
    setValue("T23", T23);
    setValue("R21", R21);
    setValue("R22", R22);
    setValue("R23", R23);    
    setValue("T31", T31);
    setValue("T32", T32);
    setValue("T33", T33);
    setValue("R31", R31);
    setValue("R32", R32);
    setValue("R33", R33);
    setValue("T41", T41);
    setValue("T42", T42);
    setValue("T43", T43);
    setValue("R41", R41);
    setValue("R42", R42);
    setValue("R43", R43);
    setValue("T51", T51);
    setValue("T52", T52);
    setValue("T53", T53);
    setValue("R51", R51);
    setValue("R52", R52);
    setValue("R53", R53);

    m_dashboard->setSteinhartcalc(getValue("T01").toReal(),getValue("T02").toReal(),getValue("T03").toReal(),getValue("R01").toReal(),getValue("R02").toReal(),getValue("R03").toReal(),getValue("T11").toReal(),getValue("T12").toReal(),getValue("T13").toReal(),getValue("R11").toReal(),getValue("R12").toReal(),getValue("R13").toReal(),getValue("T21").toReal(),getValue("T22").toReal(),getValue("T23").toReal(),getValue("R21").toReal(),getValue("R22").toReal(),getValue("R23").toReal(),getValue("T31").toReal(),getValue("T32").toReal(),getValue("T33").toReal(),getValue("R31").toReal(),getValue("R32").toReal(),getValue("R33").toReal(),getValue("T41").toReal(),getValue("T42").toReal(),getValue("T43").toReal(),getValue("R41").toReal(),getValue("R42").toReal(),getValue("R43").toReal(),getValue("T51").toReal(),getValue("T52").toReal(),getValue("T53").toReal(),getValue("R51").toReal(),getValue("R52").toReal(),getValue("R53").toReal());
}
void AppSettings::writeCylinderSettings(const qreal &Cylinders)
{
    setValue("Cylinders", Cylinders);
    m_dashboard->setCylinders(Cylinders);
    qDebug() << "Cylinders" << m_dashboard->Cylinders();
}

void AppSettings::writeCountrySettings(const QString &Country)
{
    setValue("Country", Country);
    m_dashboard->setCBXCountrysave(Country);
    qDebug() << "Country" <<getValue("Country").toString();
}
void AppSettings::writeTrackSettings(const QString &Track)
{
    setValue("Track", Track);
    m_dashboard->setCBXTracksave(Track);

}

void AppSettings::writebrightnessettings(const int &Brightness)
{
    setValue("Brightness", Brightness);
    m_dashboard->setBrightness(Brightness);

}

void AppSettings::writeStartupSettings(const int &ExternalSpeed)
{
    setValue("ExternalSpeed", ExternalSpeed);
    m_dashboard->setExternalSpeed(ExternalSpeed);
}

void AppSettings::writeRPMFrequencySettings(const qreal &Divider,const int &DI1isRPM)
{
    setValue("RPMFrequencyDivider", Divider);
    setValue("DI1RPMEnabled", DI1isRPM);
    m_dashboard->setRPMFrequencyDividerDi1(Divider);
    m_dashboard->setDI1RPMEnabled(DI1isRPM);

}

void AppSettings::readandApplySettings()
{
    //Set Analog Input Settings
    m_dashboard->setAnalogVal(getValue("AN00").toReal(),getValue("AN05").toReal(),getValue("AN10").toReal(),getValue("AN15").toReal(),getValue("AN20").toReal(),getValue("AN25").toReal(),getValue("AN30").toReal(),getValue("AN35").toReal(),getValue("AN40").toReal(),getValue("AN45").toReal(),getValue("AN50").toReal(),getValue("AN55").toReal(),getValue("AN60").toReal(),getValue("AN65").toReal(),getValue("AN70").toReal(),getValue("AN75").toReal(),getValue("AN80").toReal(),getValue("AN85").toReal(),getValue("AN90").toReal(),getValue("AN95").toReal(),getValue("AN100").toReal(),getValue("AN105").toReal());
    m_dashboard->setEXAnalogVal(getValue("EXA00").toReal(),getValue("EXA05").toReal(),getValue("EXA10").toReal(),getValue("EXA15").toReal(),getValue("EXA20").toReal(),getValue("EXA25").toReal(),getValue("EXA30").toReal(),getValue("EXA35").toReal(),getValue("EXA40").toReal(),getValue("EXA45").toReal(),getValue("EXA50").toReal(),getValue("EXA55").toReal(),getValue("EXA60").toReal(),getValue("EXA65").toReal(),getValue("EXA70").toReal(),getValue("EXA75").toReal(),getValue("steinhartcalc0on").toInt(),getValue("steinhartcalc1on").toInt(),getValue("steinhartcalc2on").toInt(),getValue("steinhartcalc3on").toInt(),getValue("steinhartcalc4on").toInt(),getValue("steinhartcalc5on").toInt(),getValue("AN0R3VAL").toInt(), getValue("AN0R4VAL").toInt(),getValue("AN1R3VAL").toInt(),getValue("AN1R4VAL").toInt(),getValue("AN2R3VAL").toInt(),getValue("AN2R4VAL").toInt() ,getValue("AN3R3VAL").toInt(), getValue("AN3R4VAL").toInt(),getValue("AN4R3VAL").toInt(),getValue("AN4R4VAL").toInt(),getValue("AN5R3VAL").toInt(),getValue("AN5R4VAL").toInt());
    m_dashboard->setmaxRPM(getValue("Max RPM").toInt());
    m_dashboard->setrpmStage1(getValue("Shift Light1").toInt());
    m_dashboard->setrpmStage2(getValue("Shift Light2").toInt());
    m_dashboard->setrpmStage3(getValue("Shift Light3").toInt());
    m_dashboard->setrpmStage4(getValue("Shift Light4").toInt()); 
    m_dashboard->setsmootexAnalogInput7(getValue("AN7Damping").toInt());
    m_dashboard->setSteinhartcalc(getValue("T01").toReal(),getValue("T02").toReal(),getValue("T03").toReal(),getValue("R01").toReal(),getValue("R02").toReal(),getValue("R03").toReal(),getValue("T11").toReal(),getValue("T12").toReal(),getValue("T13").toReal(),getValue("R11").toReal(),getValue("R12").toReal(),getValue("R13").toReal(),getValue("T21").toReal(),getValue("T22").toReal(),getValue("T23").toReal(),getValue("R21").toReal(),getValue("R22").toReal(),getValue("R23").toReal(),getValue("T31").toReal(),getValue("T32").toReal(),getValue("T33").toReal(),getValue("R31").toReal(),getValue("R32").toReal(),getValue("R33").toReal(),getValue("T41").toReal(),getValue("T42").toReal(),getValue("T43").toReal(),getValue("R41").toReal(),getValue("R42").toReal(),getValue("R43").toReal(),getValue("T51").toReal(),getValue("T52").toReal(),getValue("T53").toReal(),getValue("R51").toReal(),getValue("R52").toReal(),getValue("R53").toReal());
    m_dashboard->setwaterwarn(getValue("waterwarn").toReal());
    if (getValue("waterwarn").toReal() <= 0)
    {
        m_dashboard->setwaterwarn(400);
    }
    m_dashboard->setboostwarn(getValue("boostwarn").toReal());
    if (getValue("boostwarn").toReal() <= 0)
    {
        m_dashboard->setboostwarn(999);
    }
    m_dashboard->setrpmwarn(getValue("rpmwarn").toReal());
    if (getValue("rpmwarn").toReal() <= 0)
    {
        m_dashboard->setrpmwarn(99999);
    }
    m_dashboard->setknockwarn(getValue("knockwarn").toReal());
    if (getValue("knockwarn").toReal() <= 0)
    {
        m_dashboard->setknockwarn(99999);
    }
    m_dashboard->setgearcalcactivation(getValue("gercalactive").toInt());
    m_dashboard->setLambdamultiply(getValue("lambdamultiply").toReal());
    m_dashboard->setgearcalc1(getValue("valgear1").toReal());
    m_dashboard->setgearcalc2(getValue("valgear2").toReal());
    m_dashboard->setgearcalc3(getValue("valgear3").toReal());
    m_dashboard->setgearcalc4(getValue("valgear4").toReal());
    m_dashboard->setgearcalc5(getValue("valgear5").toReal());
    m_dashboard->setgearcalc6(getValue("valgear6").toReal());
    m_dashboard->setCylinders(getValue("Cylinders").toReal());
    m_dashboard->setExternalSpeed(getValue("ExternalSpeed").toInt());
    m_dashboard->setCBXCountrysave(getValue("Country").toString());
    m_dashboard->setCBXTracksave(getValue("Track").toString());
    m_dashboard->setBrightness(getValue("Brightness").toInt());
    m_dashboard->setRPMFrequencyDividerDi1(getValue("RPMFrequencyDivider").toReal());
    m_dashboard->setDI1RPMEnabled(getValue("DI1RPMEnabled").toInt());
    m_dashboard->setspeedpercent(getValue("Speedcorrection").toReal());
    if (getValue("Speedcorrection").toReal() <= 0)
    {
        m_dashboard->setspeedpercent(1);
    }

}

