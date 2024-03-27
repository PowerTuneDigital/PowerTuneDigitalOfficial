// LanguageManager.h

#ifndef LANGUAGEMANAGER_H
#define LANGUAGEMANAGER_H

#include <QObject>
#include <QTranslator>
#include <QQmlApplicationEngine>

class LanguageManager : public QObject
{
    Q_OBJECT
public:
    explicit LanguageManager(QQmlApplicationEngine* engine, QObject *parent = nullptr);

    Q_INVOKABLE void changeLanguage(const QString &languageCode);

private:
    QTranslator m_translator;
    QQmlApplicationEngine* m_engine;
};

#endif // LANGUAGEMANAGER_H

