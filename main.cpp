#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtQml>
#include <QFileSystemModel>
#include "connect.h"
#include "Extender.h"
#include "iomapdata.h"
#include "downloadmanager.h"
#include <QDebug>
#include <QDateTime>
#include <cstdio>
#include "dynoanalyzer.h"
    ioMapData mpd;

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
    QApplication app(argc, argv);
    app.setOrganizationName("Power-Tune");
    app.setOrganizationDomain("power-tune.org");
    app.setApplicationName("PowerTune");
    QQmlApplicationEngine engine;
    qmlRegisterType<ioMapData>("IMD", 1, 0, "IMD");
    qmlRegisterType<DownloadManager>("DLM", 1, 0, "DLM");
    qmlRegisterType<Connect>("com.powertune", 1, 0, "ConnectObject");

    engine.rootContext()->setContextProperty("DynoAnalyzer", new DynoAnalyzer(&engine));
    engine.rootContext()->setContextProperty("IMD", new ioMapData(&engine));
    engine.rootContext()->setContextProperty("DLM", new DownloadManager(&engine));
    engine.rootContext()->setContextProperty("Connect", new Connect(&engine));
    engine.rootContext()->setContextProperty("Extender2",new Extender(&engine));

#ifdef HAVE_DDCUTIL
    engine.rootContext()->setContextProperty("HAVE_DDCUTIL", true);
#else
    engine.rootContext()->setContextProperty("HAVE_DDCUTIL", false);
#endif
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    return app.exec();

}

