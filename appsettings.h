#ifndef APPSETTINGS_H
#define APPSETTINGS_H

#include <QObject>

class AppSettings;
class DashBoard;

class AppSettings : public QObject
{
    Q_OBJECT
public:

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
    Q_INVOKABLE void writeWarnGearSettings();
    Q_INVOKABLE void writeSpeedSettings();
    Q_INVOKABLE void writeAnalogSettings(const qreal &A00,const qreal &A05,const qreal &A10,const qreal &A15,const qreal &A20,const qreal &A25,const qreal &A30,const qreal &A35,const qreal &A40,const qreal &A45,const qreal &A50,const qreal &A55,const qreal &A60,const qreal &A65,const qreal &A70,const qreal &A75,const qreal &A80,const qreal &A85,const qreal &A90,const qreal &A95,const qreal &A100,const qreal &A105);
    Q_INVOKABLE void writeRPMSettings();
    Q_INVOKABLE void writeEXBoardSettings();
    Q_INVOKABLE void writeStartupSettings();
    Q_INVOKABLE void readandApplySettings();

private:
    void setValue(const QString &key, const QVariant &value);
    QVariant getValue(const QString &key);
    DashBoard *m_dashboard;
};

#endif // APPSETTINGS_H
