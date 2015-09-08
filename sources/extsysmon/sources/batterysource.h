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

#ifndef BATTERYSOURCE_H
#define BATTERYSOURCE_H

#include <QObject>

#include "abstractextsysmonsource.h"


class BatterySource : public AbstractExtSysMonSource
{
public:
    explicit BatterySource(QObject *parent, const QStringList args);
    virtual ~BatterySource();
    QVariant data(QString source);
    QVariantMap initialData(QString source) const;
    void run();
    QStringList sources() const;

private:
    QStringList getSources();
    // configuration and values
    int m_batteriesCount = 0;
    QString m_acpiPath;
    QStringList m_sources;
    QVariantHash values;
};


#endif /* BATTERYSOURCE_H */
