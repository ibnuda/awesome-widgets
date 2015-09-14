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

import QtQuick 2.0
import QtQuick.Controls 1.3 as QtControls
import QtQuick.Dialogs 1.2 as QtDialogs
import org.kde.plasma.core 2.0 as PlasmaCore

import org.kde.plasma.private.awesomewidget 1.0


Item {
    id: widgetPage
    // backend
    AWKeys {
        id: awKeys;
    }
    AWActions {
        id: awActions;
    }

    width: childrenRect.width
    height: childrenRect.height
    implicitWidth: pageColumn.implicitWidth
    implicitHeight: pageColumn.implicitHeight

    property bool debug: awActions.isDebugEnabled()

    property alias cfg_text: textPattern.text

    signal dropSource(string sourceName)
    signal needTextUpdate(string newText)


    Column {
        id: pageColumn
        anchors.fill: parent
        QtControls.Label {
          width: parent.width
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
          wrapMode: Text.WordWrap
          text: i18n("Detailed information may be found on <a href=\"http://arcanis.name/projects/awesome-widgets/\">project homepage</a>")
          onLinkActivated: Qt.openUrlExternally(link);
        }

        Row {
            height: implicitHeight
            width: parent.width
            QtControls.Button {
                width: parent.width * 3 / 12
                text: i18n("Font")
                iconName: "font"

                onClicked: {
                    if (debug) console.debug("Font button")
                    var defaultFont = {
                        "color": plasmoid.configuration.fontColor,
                        "family": plasmoid.configuration.fontFamily,
                        "size": plasmoid.configuration.fontSize
                    }
                    var font = awActions.getFont(defaultFont)
                    var pos = textPattern.cursorPosition
                    var selected = textPattern.selectedText
                    textPattern.remove(textPattern.selectionStart, textPattern.selectionEnd)
                    textPattern.insert(pos, "<span style=\"color:" + font.color +
                                            "; font-family:'" + font.family +
                                            "'; font-size:" + font.size + "pt;\">" +
                                            selected + "</span>")
                }
            }
            QtControls.Button {
                width: parent.width / 12
                iconName: "format-indent-more"

                onClicked: {
                    if (debug) console.debug("Indent button")
                    var pos = textPattern.cursorPosition
                    var selected = textPattern.selectedText
                    textPattern.remove(textPattern.selectionStart, textPattern.selectionEnd)
                    textPattern.insert(pos, selected + "<br>\n")
                }
            }

            QtControls.Button {
                width: parent.width / 12
                iconName: "format-text-bold"

                onClicked: {
                    if (debug) console.debug("Bold button")
                    var pos = textPattern.cursorPosition
                    var selected = textPattern.selectedText
                    textPattern.remove(textPattern.selectionStart, textPattern.selectionEnd)
                    textPattern.insert(pos, "<b>" + selected + "</b>")
                }
            }
            QtControls.Button {
                width: parent.width / 12
                iconName: "format-text-italic"

                onClicked: {
                    if (debug) console.debug("Italic button")
                    var pos = textPattern.cursorPosition
                    var selected = textPattern.selectedText
                    textPattern.remove(textPattern.selectionStart, textPattern.selectionEnd)
                    textPattern.insert(pos, "<i>" + selected + "</i>")
                }
            }
            QtControls.Button {
                width: parent.width / 12
                iconName: "format-text-underline"

                onClicked: {
                    if (debug) console.debug("Underline button")
                    var pos = textPattern.cursorPosition
                    var selected = textPattern.selectedText
                    textPattern.remove(textPattern.selectionStart, textPattern.selectionEnd)
                    textPattern.insert(pos, "<u>" + selected + "</u>")
                }
            }
            QtControls.Button {
                width: parent.width / 12
                iconName: "format-text-strikethrough"

                onClicked: {
                    if (debug) console.debug("Strike button")
                    var pos = textPattern.cursorPosition
                    var selected = textPattern.selectedText
                    textPattern.remove(textPattern.selectionStart, textPattern.selectionEnd)
                    textPattern.insert(pos, "<s>" + selected + "</s>")
                }
            }

            QtControls.Button {
                width: parent.width / 12
                iconName: "format-justify-left"

                onClicked: {
                    if (debug) console.debug("Left button")
                    var pos = textPattern.cursorPosition
                    var selected = textPattern.selectedText
                    textPattern.remove(textPattern.selectionStart, textPattern.selectionEnd)
                    textPattern.insert(pos, "<p align=\"left\">" + selected + "</p>")
                }
            }
            QtControls.Button {
                width: parent.width / 12
                iconName: "format-justify-center"

                onClicked: {
                    if (debug) console.debug("Center button")
                    var pos = textPattern.cursorPosition
                    var selected = textPattern.selectedText
                    textPattern.remove(textPattern.selectionStart, textPattern.selectionEnd)
                    textPattern.insert(pos, "<p align=\"center\">" + selected + "</p>")
                }
            }
            QtControls.Button {
                width: parent.width / 12
                iconName: "format-justify-right"

                onClicked: {
                    if (debug) console.debug("Right button")
                    var pos = textPattern.cursorPosition
                    var selected = textPattern.selectedText
                    textPattern.remove(textPattern.selectionStart, textPattern.selectionEnd)
                    textPattern.insert(pos, "<p align=\"right\">" + selected + "</p>")
                }
            }
            QtControls.Button {
                width: parent.width / 12
                iconName: "format-justify-fill"

                onClicked: {
                    if (debug) console.debug("Justify button")
                    var pos = textPattern.cursorPosition
                    var selected = textPattern.selectedText
                    textPattern.remove(textPattern.selectionStart, textPattern.selectionEnd)
                    textPattern.insert(pos, "<p align=\"justify\">" + selected + "</p>")
                }
            }
        }

        Row {
            height: implicitHeight
            width: parent.width
            QtControls.ComboBox {
                width: parent.width * 1 / 5
                textRole: "label"
                model: [
                    {
                        'label': i18n("AC"),
                        'regexp': "^(ac|bat).*"
                    },
                    {
                        'label': i18n("Bars"),
                        'regexp': "^bar.*"
                    },
                    {
                        'label': i18n("CPU"),
                        'regexp': "^(cpu|gpu|la|ps|temp(?!erature)).*"
                    },
                    {
                        'label': i18n("Desktops"),
                        'regexp': "^(n|t)?desktop(s)?"
                    },
                    {
                        'label': i18n("HDD"),
                        'regexp': "^hdd.*"
                    },
                    {
                        'label': i18n("Memory"),
                        'regexp': "^(mem|swap).*"
                    },
                    {
                        'label': i18n("Network"),
                        'regexp': "^(netdev|(down|up(?!time)).*)"
                    },
                    {
                        'label': i18n("Music player"),
                        'regexp': "(^|d|s)(album|artist|duration|progress|title)"
                    },
                    {
                        'label': i18n("Scripts"),
                        'regexp': "^custom.*"
                    },
                    {
                        'label': i18n("Time"),
                        'regexp': ".*time$"
                    },
                    {
                        'label': i18n("Quotes"),
                        'regexp': "^(perc)?(ask|bid|price)(chg)?.*"
                    },
                    {
                        'label': i18n("Upgrades"),
                        'regexp': "^pkgcount.*"
                    },
                    {
                        'label': i18n("Weathers"),
                        'regexp': "^(weather(Id)?|humidity|pressure|temperature|timestamp)"
                    }
                ]
                onCurrentIndexChanged: {
                    if (debug) console.debug()
                    tags.model = awKeys.dictKeys(true, model[currentIndex]["regexp"])
                    if (debug) console.info("Init model", tags.model, "for", model[currentIndex]["label"])
                    tags.currentIndex = -1
                }
            }
            QtControls.ComboBox {
                id: tags
                width: parent.width * 1 / 5
            }
            QtControls.Button {
                width: parent.width * 1 / 5
                text: i18n("Add")

                onClicked: {
                    if (!tags.currentText) return
                    if (debug) console.debug("Add tag button")
                    var pos = textPattern.cursorPosition
                    var selected = textPattern.selectedText
                    textPattern.remove(textPattern.selectionStart, textPattern.selectionEnd)
                    textPattern.insert(pos, selected + "$" + tags.currentText)
                }
            }
            QtControls.Button {
                width: parent.width * 1 / 5
                text: i18n("Show value")

                onClicked: {
                    if (!tags.currentText) return
                    if (debug) console.debug("Show tag button")
                    var message = i18n("Tag: %1", tags.currentText)
                    message += "<br>"
                    message += i18n("Value: %1", awKeys.valueByKey(tags.currentText))
                    message += "<br>"
                    message += i18n("Info: %1", awKeys.infoByKey(tags.currentText))
                    awActions.sendNotification("tag", message)
                }
            }
            QtControls.Button {
                width: parent.width * 1 / 5
                text: i18n("Add lambda")

                onClicked: {
                    if (debug) console.debug("Lambda button")
                    var pos = textPattern.cursorPosition
                    var selected = textPattern.selectedText
                    textPattern.remove(textPattern.selectionStart, textPattern.selectionEnd)
                    textPattern.insert(pos, selected + "${{\n\n}}")
                }
            }
        }

        Row {
            height: implicitHeight
            width: parent.width
            QtControls.Button {
                width: parent.width * 3 / 5
                text: i18n("Edit bars")
                onClicked: awKeys.editItem("graphicalitem")
            }
            QtControls.Button {
                width: parent.width * 2 / 5
                text: i18n("Preview")
                onClicked: {
                    awKeys.initKeys(textPattern.text)
                    awKeys.needToBeUpdated()
                }
            }
        }

        QtControls.TextArea {
            id: textPattern
            width: parent.width
            height: parent.height * 4 / 5
            textFormat: TextEdit.PlainText
            text: plasmoid.configuration.text
        }
    }

    QtDialogs.MessageDialog {
        id: compiledText
        modality: Qt.NonModal
        title: i18n("Preview")
    }

    // we need to initializate DataEngines here too
    // because we need to get keys and values
    PlasmaCore.DataSource {
        id: systemmonitorDE
        engine: "systemmonitor"
        connectedSources: systemmonitorDE.sources
        interval: 5000

        onNewData: {
            if (debug) console.debug("Update source", sourceName)
            awKeys.dataUpdateReceived(sourceName, data)
        }
    }

    PlasmaCore.DataSource {
        id: extsysmonDE
        engine: "extsysmon"
        connectedSources: extsysmonDE.sources
        interval: 5000

        onNewData: {
            // even after a disconnect it is possible that we'll receive an update
            if (sourceName == "update") return
            if (debug) console.debug("Update source", sourceName)
            awKeys.dataUpdateReceived(sourceName, data)
        }
    }

    PlasmaCore.DataSource {
        id: timeDE
        engine: "time"
        connectedSources: ["Local"]
        interval: 5000

        onNewData: {
            if (debug) console.debug("Update source", sourceName)
            awKeys.dataUpdateReceived(sourceName, data)
        }
    }

    Component.onCompleted: {
        if (debug) console.debug()

        // drop "update" source which does not required by this page
        extsysmonDE.disconnectSource("update")
        awKeys.dropSourceFromDataengine.connect(dropSource)
        awKeys.needTextToBeUpdated.connect(needTextUpdate)
        // init submodule
        awKeys.initKeys(plasmoid.configuration.text)
        awKeys.setAggregatorProperty("acOffline", plasmoid.configuration.acOffline)
        awKeys.setAggregatorProperty("acOnline", plasmoid.configuration.acOnline)
        awKeys.setAggregatorProperty("customTime", plasmoid.configuration.customTime)
        awKeys.setAggregatorProperty("customUptime", plasmoid.configuration.customUptime)
        awKeys.setAggregatorProperty("tempUnits", plasmoid.configuration.tempUnits)
        awKeys.setAggregatorProperty("translate", plasmoid.configuration.translateStrings)
    }

    onDropSource: {
        if (debug) console.debug()
        if (debug) console.debug("Source", sourceName)

        systemmonitorDE.disconnectSource(sourceName)
    }

    onNeedTextUpdate: {
        if (debug) console.debug()

        compiledText.text = newText.replace(/&nbsp;/g, " ")
        compiledText.open()
    }
}