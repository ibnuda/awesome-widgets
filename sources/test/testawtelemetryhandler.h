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


#ifndef TESTAWTELEMETRYHANDLER_H
#define TESTAWTELEMETRYHANDLER_H

#include <QObject>


class AWTelemetryHandler;

class TestAWTelemetryHandler : public QObject
{
    Q_OBJECT

private slots:
    // initialization
    void initTestCase();
    void cleanupTestCase();
    // test
    void test_put();
    void test_get();
    void test_getLast();
    void test_uploadTelemetry();

private:
    AWTelemetryHandler *plugin = nullptr;
    QString telemetryData;
    QString telemetryGroup;
    QString telemetryId = QString("autotest");
    QString telemetryValidGroup = QString("awwidgetconfig");
};


#endif /* TESTAWTELEMETRYHANDLER_H */
