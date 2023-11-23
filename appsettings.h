#ifndef APPSETTINGS_H
#define APPSETTINGS_H

#include <QObject>

class DashBoard;

class AppSettings : public QObject
{
    Q_OBJECT

public:
 ~AppSettings();
    explicit AppSettings(QObject *parent = 0);
    explicit AppSettings(DashBoard *dashboard, QObject *parent = 0);


    Q_INVOKABLE int getBaudRate();
    Q_INVOKABLE void setBaudRate(const int &arg);
    Q_INVOKABLE int getParity();
    Q_INVOKABLE void setParity(const int &arg);
    Q_INVOKABLE int getDataBits();
    Q_INVOKABLE void setDataBits(const int &arg);
    Q_INVOKABLE int getStopBits();
    Q_INVOKABLE void setStopBits(const int &arg);
    Q_INVOKABLE int getFlowControl();
    Q_INVOKABLE void setFlowControl(const int &arg);
    Q_INVOKABLE int getECU();
    Q_INVOKABLE void setECU(const int &arg);
    Q_INVOKABLE int getInterface();
    Q_INVOKABLE void setInterface(const int &arg);
    Q_INVOKABLE int getLogging();
    Q_INVOKABLE void setLogging(const int &arg);
    Q_INVOKABLE void writeMainSettings();
    Q_INVOKABLE void writeSelectedDashSettings(int numberofdashes);
    Q_INVOKABLE void externalspeedconnectionstatus(int connected);
    Q_INVOKABLE void externalspeedport(const QString &port);
    Q_INVOKABLE void writeWarnGearSettings(const qreal &waterwarn,const qreal &boostwarn,const qreal &rpmwarn,const qreal &knockwarn,const int &gercalactive,const qreal&lambdamultiply,const qreal &valgear1,const qreal &valgear2,const qreal &valgear3,const qreal &valgear4,const qreal &valgear5,const qreal &valgear6);
    Q_INVOKABLE void writeSpeedSettings(const qreal &Speedcorrection,const qreal &Pulsespermile);
    Q_INVOKABLE void writeAnalogSettings(const qreal &A00,const qreal &A05,const qreal &A10,const qreal &A15,const qreal &A20,const qreal &A25,const qreal &A30,const qreal &A35,const qreal &A40,const qreal &A45,const qreal &A50,const qreal &A55,const qreal &A60,const qreal &A65,const qreal &A70,const qreal &A75,const qreal &A80,const qreal &A85,const qreal &A90,const qreal &A95,const qreal &A100,const qreal &A105);
    Q_INVOKABLE void writeRPMSettings(const int &mxrpm,const int &shift1,const int &shift2,const int &shift3,const int &shift4);
    Q_INVOKABLE void writeEXBoardSettings(const qreal &EXA00,const qreal &EXA05,const qreal &EXA10,const qreal &EXA15,const qreal &EXA20,const qreal &EXA25,const qreal &EXA30,const qreal &EXA35,const qreal &EXA40,const qreal &EXA45,const qreal &EXA50,const qreal &EXA55,const qreal &EXA60,const qreal &EXA65,const qreal &EXA70,const qreal &EXA75,const int &steinhartcalc0on, const int &steinhartcalc1on, const int &steinhartcalc2on,const int &steinhartcalc3on, const int &steinhartcalc4on, const int &steinhartcalc5on,const int &AN0R3VAL,const int &AN0R4VAL,const int &AN1R3VAL,const int &AN1R4VAL,const int &AN2R3VAL,const int &AN2R4VAL,const int &AN3R3VAL,const int &AN3R4VAL,const int &AN4R3VAL,const int &AN4R4VAL,const int &AN5R3VAL,const int &AN5R4VAL);
    Q_INVOKABLE void writeEXAN7dampingSettings(const int &AN7damping);
    Q_INVOKABLE void writeSteinhartSettings(const qreal &T01,const qreal &T02,const qreal &T03,const qreal &R01,const qreal &R02,const qreal &R03,const qreal &T11,const qreal &T12,const qreal &T13,const qreal &R11,const qreal &R12,const qreal &R13,const qreal &T21,const qreal &T22,const qreal &T23,const qreal &R21,const qreal &R22,const qreal &R23, const qreal &T31,const qreal &T32,const qreal &T33,const qreal &R31,const qreal &R32,const qreal &R33, const qreal &T41,const qreal &T42,const qreal &T43,const qreal &R41,const qreal &R42,const qreal &R43, const qreal &T51,const qreal &T52,const qreal &T53,const qreal &R51,const qreal &R52,const qreal &R53);
    Q_INVOKABLE void writeCylinderSettings(const qreal &Cylinders);
    Q_INVOKABLE void writeCountrySettings(const QString &Country);
    Q_INVOKABLE void writeTrackSettings(const QString &Track);
    Q_INVOKABLE void writebrightnessettings(const int &Brightness);
    Q_INVOKABLE void writeRPMFrequencySettings(const qreal &Divider,const int &DI1isRPM);
    Q_INVOKABLE void writeExternalrpm(const int checked);
    Q_INVOKABLE void writeLanguage(const int Language);
    Q_INVOKABLE void writeStartupSettings(const int &ExternalSpeed);
    Q_INVOKABLE void readandApplySettings();

private:
    void setValue(const QString &key, const QVariant &value);
    QVariant getValue(const QString &key);
    DashBoard *m_dashboard;
};

#endif // APPSETTINGS_H
