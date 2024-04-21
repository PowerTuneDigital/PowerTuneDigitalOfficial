// LanguageManager.cpp

#include "LanguageManager.h"
#include <QGuiApplication>
#include <QDebug>

LanguageManager::LanguageManager(QQmlApplicationEngine* engine, QObject *parent) 
    : QObject(parent), m_engine(engine) {}

void LanguageManager::changeLanguage(const QString &languageCode)
{
    qInfo() << "Changing language to" << languageCode;
    qApp->removeTranslator(&m_translator);
    if(m_translator.load(":/i18n/" + languageCode))
    {
        qApp->installTranslator(&m_translator);
        m_engine->clearComponentCache(); // Clear the cache to force reloading QML files
        m_engine->retranslate();
        qInfo() << "Language changed to" << languageCode;
    }
    else
    {
        qWarning() << "Could not load translation file for" << languageCode;
    }
}
