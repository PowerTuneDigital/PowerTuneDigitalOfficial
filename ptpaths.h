#ifndef PTPATHS_H
#define PTPATHS_H

#include <QString>
#include <QUrl>
#include <QtGlobal>

// Central base directory for all PowerTune data folders (UserDashboards, Logo,
// Gauges, KTracks, maptiles, daemons, etc.).
//
// On the Raspberry Pi (Linux) target this is /home/pi, which matches the paths
// that used to be hardcoded throughout the codebase, so Linux behaviour is
// unchanged. When the project is compiled on Windows (used for testing) it
// points at C:/PowerTune instead, so the same folder layout works there.
//
// To use a different location on Windows just change the string below.
inline QString ptBasePath()
{
#ifdef Q_OS_WIN
    return QStringLiteral("C:/PowerTune");
#else
    return QStringLiteral("/home/pi");
#endif
}

// Same base directory expressed as a file:// URL, handy for QML image sources.
//   Linux:   file:///home/pi
//   Windows: file:///C:/PowerTune
inline QString ptBaseUrl()
{
    return QUrl::fromLocalFile(ptBasePath()).toString();
}

#endif // PTPATHS_H
