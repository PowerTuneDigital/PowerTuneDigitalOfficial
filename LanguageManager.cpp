// LanguageManager.cpp

#include "LanguageManager.h"
#include <QGuiApplication>

LanguageManager::LanguageManager(QQmlApplicationEngine* engine, QObject *parent) 
    : QObject(parent), m_engine(engine) {}

void LanguageManager::changeLanguage(const QString &languageCode)
{
    qApp->removeTranslator(&m_translator);
    if(m_translator.load(":/i18n/t1_" + languageCode))
    {
        qApp->installTranslator(&m_translator);
        m_engine->clearComponentCache(); // Clear the cache to force reloading QML files
        m_engine->load(QUrl(QStringLiteral("qrc:/Settings/main.qml"))); // Reload the main QML file
        qInfo() << "Language changed to" << languageCode;
    }
    else
    {
        qWarning() << "Could not load translation file for" << languageCode;
    }
}
