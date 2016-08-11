/***************************************************************************
 *   This file is part of awesome-widgets                                  *
 *                                                                         *
 *   awesome-widgets is free software: you can redistribute it and/or      *
 *   modify it under the terms of the GNU General Public License as        *
 *   published by the Free Software Foundation, either version 3 of the    *
 *   License, or (at your option) any later version.                       *
 *                                                                         *
 *   awesome-widgets is distributed in the hope that it will be useful,    *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with awesome-widgets. If not, see http://www.gnu.org/licenses/  *
 ***************************************************************************/

#include "awconfighelper.h"

#include <KI18n/KLocalizedString>

#include <QDir>
#include <QQmlPropertyMap>
#include <QSettings>
#include <QTextCodec>

#include "awdebug.h"


AWConfigHelper::AWConfigHelper(QObject *parent)
    : QObject(parent)
{
    qCDebug(LOG_AW) << __PRETTY_FUNCTION__;
}


AWConfigHelper::~AWConfigHelper()
{
    qCDebug(LOG_AW) << __PRETTY_FUNCTION__;
}


QString AWConfigHelper::configurationDirectory() const
{
    // get readable directory
    QString localDir = QString("%1/awesomewidgets/configs")
                           .arg(QStandardPaths::writableLocation(
                               QStandardPaths::GenericDataLocation));

    // create directory and copy files from default settings
    QDir localDirectory;
    if ((!localDirectory.exists(localDir))
        && (localDirectory.mkpath(localDir))) {
        qCInfo(LOG_AW) << "Created directory" << localDir;
        copyConfigs(localDir);
    }

    return localDir;
}


bool AWConfigHelper::dropCache() const
{
    QString fileName = QString("%1/awesomewidgets.ndx")
                           .arg(QStandardPaths::writableLocation(
                               QStandardPaths::GenericCacheLocation));

    return QFile(fileName).remove();
}


bool AWConfigHelper::exportConfiguration(const QObject *nativeConfig,
                                         const QString fileName) const
{
    qCDebug(LOG_AW) << "Selected filename" << fileName;

    QSettings settings(fileName, QSettings::IniFormat);

    // plasmoid configuration
    const QQmlPropertyMap *configuration
        = static_cast<const QQmlPropertyMap *>(nativeConfig);
    settings.beginGroup(QString("plasmoid"));
    for (auto key : configuration->keys()) {
        QVariant value = configuration->value(key);
        if (!value.isValid())
            continue;
        settings.setValue(key, value);
    }
    settings.endGroup();

    // extensions
    for (auto item : m_dirs) {
        QStringList items
            = QDir(QString("%1/%2").arg(m_baseDir).arg(item))
                  .entryList(QStringList() << QString("*.desktop"),
                             QDir::Files);
        settings.beginGroup(item);
        for (auto it : items)
            copyExtensions(it, item, settings, false);
        settings.endGroup();
    }

    // additional files
    settings.beginGroup(QString("json"));
    // script filters
    readFile(settings, QString("filters"),
             QString("%1/scripts/awesomewidgets-extscripts-filters.json")
                 .arg(m_baseDir));
    // weather icon settings
    readFile(settings, QString("weathers"),
             QString("%1/weather/awesomewidgets-extweather-ids.json")
                 .arg(m_baseDir));
    // formatter settings
    readFile(settings, QString("formatters"),
             QString("%1/formatters/formatters.ini").arg(m_baseDir));
    settings.endGroup();

    // sync settings
    settings.sync();
    // show additional message
    return settings.status() == QSettings::NoError;
}


QVariantMap AWConfigHelper::importConfiguration(const QString fileName,
                                                const bool importPlasmoid,
                                                const bool importExtensions,
                                                const bool importAdds) const
{
    qCDebug(LOG_AW) << "Selected filename" << fileName;

    QVariantMap configuration;
    QSettings settings(fileName, QSettings::IniFormat);

    // extensions
    if (importExtensions) {
        for (auto item : m_dirs) {
            settings.beginGroup(item);
            for (auto it : settings.childGroups())
                copyExtensions(it, item, settings, true);
            settings.endGroup();
        }
    }

    // additional files
    if (importAdds) {
        settings.beginGroup(QString("json"));
        // script filters
        writeFile(settings, QString("filters"),
                  QString("%1/scripts/awesomewidgets-extscripts-filters.json")
                      .arg(m_baseDir));
        // weather icon settings
        writeFile(settings, QString("weathers"),
                  QString("%1/weather/awesomewidgets-extweather-ids.json")
                      .arg(m_baseDir));
        // formatter settings
        writeFile(settings, QString("formatters"),
                  QString("%1/formatters/formatters.ini").arg(m_baseDir));
        settings.endGroup();
    }

    // plasmoid configuration
    if (importPlasmoid) {
        settings.beginGroup(QString("plasmoid"));
        for (auto key : settings.childKeys())
            configuration[key] = settings.value(key);
        settings.endGroup();
    }

    return configuration;
}


QVariantMap AWConfigHelper::readDataEngineConfiguration() const
{
    QString fileName
        = QStandardPaths::locate(QStandardPaths::ConfigLocation,
                                 QString("plasma-dataengine-extsysmon.conf"));
    qCInfo(LOG_AW) << "Configuration file" << fileName;
    QSettings settings(fileName, QSettings::IniFormat);
    QVariantMap configuration;

    settings.beginGroup(QString("Configuration"));
    configuration[QString("ACPIPATH")] = settings.value(
        QString("ACPIPATH"), QString("/sys/class/power_supply/"));
    configuration[QString("GPUDEV")]
        = settings.value(QString("GPUDEV"), QString("auto"));
    configuration[QString("HDDDEV")]
        = settings.value(QString("HDDDEV"), QString("all"));
    configuration[QString("HDDTEMPCMD")]
        = settings.value(QString("HDDTEMPCMD"), QString("sudo smartctl -a"));
    configuration[QString("MPDADDRESS")]
        = settings.value(QString("MPDADDRESS"), QString("localhost"));
    configuration[QString("MPDPORT")]
        = settings.value(QString("MPDPORT"), QString("6600"));
    configuration[QString("MPRIS")]
        = settings.value(QString("MPRIS"), QString("auto"));
    configuration[QString("PLAYER")]
        = settings.value(QString("PLAYER"), QString("mpris"));
    configuration[QString("PLAYERSYMBOLS")]
        = settings.value(QString("PLAYERSYMBOLS"), QString("10"));
    settings.endGroup();

    qCInfo(LOG_AW) << "Configuration" << configuration;

    return configuration;
}


bool AWConfigHelper::writeDataEngineConfiguration(
    const QVariantMap configuration) const
{
    qCDebug(LOG_AW) << "Configuration" << configuration;

    QString fileName
        = QStandardPaths::writableLocation(QStandardPaths::ConfigLocation)
          + QString("/plasma-dataengine-extsysmon.conf");
    QSettings settings(fileName, QSettings::IniFormat);
    qCInfo(LOG_AW) << "Configuration file" << settings.fileName();

    settings.beginGroup(QString("Configuration"));
    settings.setValue(QString("ACPIPATH"), configuration[QString("ACPIPATH")]);
    settings.setValue(QString("GPUDEV"), configuration[QString("GPUDEV")]);
    settings.setValue(QString("HDDDEV"), configuration[QString("HDDDEV")]);
    settings.setValue(QString("HDDTEMPCMD"),
                      configuration[QString("HDDTEMPCMD")]);
    settings.setValue(QString("MPDADDRESS"),
                      configuration[QString("MPDADDRESS")]);
    settings.setValue(QString("MPDPORT"), configuration[QString("MPDPORT")]);
    settings.setValue(QString("MPRIS"), configuration[QString("MPRIS")]);
    settings.setValue(QString("PLAYER"), configuration[QString("PLAYER")]);
    settings.setValue(QString("PLAYERSYMBOLS"),
                      configuration[QString("PLAYERSYMBOLS")]);
    settings.endGroup();

    settings.sync();

    return (settings.status() == QSettings::NoError);
}


void AWConfigHelper::copyConfigs(const QString localDir) const
{
    qCDebug(LOG_AW) << "Local directory" << localDir;

    QStringList dirs = QStandardPaths::locateAll(
        QStandardPaths::GenericDataLocation, QString("awesomewidgets/configs"),
        QStandardPaths::LocateDirectory);
    for (auto dir : dirs) {
        if (dir == localDir)
            continue;
        QStringList files = QDir(dir).entryList(QDir::Files);
        for (auto source : files) {
            QString destination = QString("%1/%2").arg(localDir).arg(source);
            bool status = QFile::copy(QString("%1/%2").arg(dir).arg(source),
                                      destination);
            qCInfo(LOG_AW) << "File" << source << "has been copied to"
                           << destination << "with status" << status;
        }
    }
}


void AWConfigHelper::copyExtensions(const QString item, const QString type,
                                    QSettings &settings,
                                    const bool inverse) const
{
    qCDebug(LOG_AW) << "Extension" << item << "has type" << type
                    << "inverse copying" << inverse;

    settings.beginGroup(item);
    QSettings itemSettings(
        QString("%1/%2/%3").arg(m_baseDir).arg(type).arg(item),
        QSettings::IniFormat);
    itemSettings.beginGroup(QString("Desktop Entry"));
    if (inverse)
        copySettings(settings, itemSettings);
    else
        copySettings(itemSettings, settings);
    itemSettings.endGroup();
    settings.endGroup();

    if (inverse)
        itemSettings.sync();
}


void AWConfigHelper::copySettings(QSettings &from, QSettings &to) const
{
    for (auto key : from.childKeys())
        to.setValue(key, from.value(key));
}


void AWConfigHelper::readFile(QSettings &settings, const QString key,
                              const QString fileName) const
{
    qCDebug(LOG_AW) << "Key" << key << "from file" << fileName;

    QFile file(fileName);
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QString text = QString::fromUtf8(file.readAll());
        file.close();
        settings.setValue(key, text);
    } else {
        qCWarning(LOG_AW) << "Could not open" << file.fileName();
    }
}


void AWConfigHelper::writeFile(QSettings &settings, const QString key,
                               const QString fileName) const
{
    qCDebug(LOG_AW) << "Key" << key << "to file" << fileName;

    if (!settings.contains(key))
        return;

    QFile file(fileName);
    if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream out(&file);
        out.setCodec("UTF-8");
        out << settings.value(key).toString().toUtf8();
        out.flush();
        file.close();
    } else {
        qCWarning(LOG_AW) << "Could not open" << file.fileName();
    }
}
