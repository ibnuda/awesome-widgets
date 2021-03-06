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


#ifndef AWCONFIGHELPER_H
#define AWCONFIGHELPER_H

#include <QObject>
#include <QVariant>


class QSettings;

class AWConfigHelper : public QObject
{
    Q_OBJECT

public:
    explicit AWConfigHelper(QObject *_parent = nullptr);
    virtual ~AWConfigHelper();
    Q_INVOKABLE QString configurationDirectory() const;
    Q_INVOKABLE bool dropCache() const;
    Q_INVOKABLE bool exportConfiguration(QObject *_nativeConfig,
                                         const QString &_fileName) const;
    Q_INVOKABLE QVariantMap importConfiguration(const QString &_fileName,
                                                const bool _importPlasmoid,
                                                const bool _importExtensions,
                                                const bool _importAdds) const;
    // dataengine
    Q_INVOKABLE QVariantMap readDataEngineConfiguration() const;
    Q_INVOKABLE bool
    writeDataEngineConfiguration(const QVariantMap &_configuration) const;

private:
    // methods
    void copyConfigs(const QString &_localDir) const;
    void copyExtensions(const QString &_item, const QString &_type,
                        QSettings &_settings, const bool _inverse) const;
    void copySettings(QSettings &_from, QSettings &_to) const;
    void readFile(QSettings &_settings, const QString &_key,
                  const QString &_fileName) const;
    void writeFile(QSettings &_settings, const QString &_key,
                   const QString &_fileName) const;
    // properties
    QString m_baseDir;
    QStringList m_dirs
        = {"desktops", "quotes", "scripts", "upgrade", "weather", "formatters"};
};


#endif /* AWCONFIGHELPER_H */
