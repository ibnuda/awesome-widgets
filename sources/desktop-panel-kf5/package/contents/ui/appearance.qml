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
import QtQuick.Layouts 1.0 as QtLayouts
import QtQuick.Controls.Styles 1.3 as QtStyles
import QtQuick.Dialogs 1.1 as QtDialogs

import org.kde.plasma.private.desktoppanel 1.0


Item {
    id: appearancePage
    width: childrenRect.width
    height: childrenRect.height
    implicitWidth: pageColumn.implicitWidth
    implicitHeight: pageColumn.implicitHeight

    property bool debug: DPAdds.isDebugEnabled()
    property variant weight: {
        25: 0,
        50: 1,
        63: 3,
        75: 4,
        87: 5
    }

    property alias cfg_fontFamily: selectFont.text
    property alias cfg_fontSize: fontSize.value
    property string cfg_fontWeight: fontWeight.currentText
    property string cfg_fontStyle: fontStyle.currentText
    property alias cfg_fontColor: selectColor.text
    property alias cfg_currentFontFamily: currentSelectFont.text
    property alias cfg_currentFontSize: currentFontSize.value
    property string cfg_currentFontWeight: currentFontWeight.currentText
    property string cfg_currentFontStyle: currentFontStyle.currentText
    property alias cfg_currentFontColor: currentSelectColor.text


    Column {
        id: pageColumn
        width: units.gridUnit * 25
        QtControls.TabView {
            height: parent.height
            width: parent.width
            QtControls.Tab {
                title: i18n("Active desktop")

                QtLayouts.ColumnLayout {
                    Row {
                        height: implicitHeight
                        width: parent.width
                        QtControls.Label {
                            height: parent.height
                            width: parent.width / 3
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            text: i18n("Font")
                        }
                        QtControls.Button {
                            id: currentSelectFont
                            width: parent.width * 2 / 3
                            text: plasmoid.configuration.currentFontFamily
                            onClicked: currentFontDialog.visible = true
                        }
                    }

                    Row {
                        height: implicitHeight
                        width: parent.width
                        QtControls.Label {
                            height: parent.height
                            width: parent.width / 3
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            text: i18n("Font size")
                        }
                        QtControls.SpinBox {
                            id: currentFontSize
                            width: parent.width * 2 / 3
                            minimumValue: 8
                            maximumValue: 32
                            stepSize: 1
                            value: plasmoid.configuration.currentFontSize
                        }
                    }

                    Row {
                        height: implicitHeight
                        width: parent.width
                        QtControls.Label {
                            height: parent.height
                            width: parent.width / 3
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            text: i18n("Font weight")
                        }
                        QtControls.ComboBox {
                            id: currentFontWeight
                            width: parent.width * 2 / 3
                            textRole: "label"
                            model: [
                                {
                                    'label': i18n("light"),
                                    'name': "light"
                                },
                                {
                                    'label': i18n("normal"),
                                    'name': "normal"
                                },
                                {
                                    'label': i18n("demi bold"),
                                    'name': "demibold"
                                },
                                {
                                    'label': i18n("bold"),
                                    'name': "bold"
                                },
                                {
                                    'label': i18n("black"),
                                    'name': "black"
                                }
                            ]
                            onCurrentIndexChanged: cfg_currentFontWeight = model[currentIndex]["name"]
                            Component.onCompleted: {
                                for (var i = 0; i < model.length; i++) {
                                    if (model[i]["name"] == plasmoid.configuration.currentFontWeight) {
                                        currentFontWeight.currentIndex = i;
                                    }
                                }
                            }
                        }
                    }

                    Row {
                        height: implicitHeight
                        width: parent.width
                        QtControls.Label {
                            height: parent.height
                            width: parent.width / 3
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            text: i18n("Font style")
                        }
                        QtControls.ComboBox {
                            id: currentFontStyle
                            width: parent.width * 2 / 3
                            textRole: "label"
                            model: [
                                {
                                    'label': i18n("normal"),
                                    'name': "normal"
                                },
                                {
                                    'label': i18n("italic"),
                                    'name': "italic"
                                }
                            ]
                            onCurrentIndexChanged: cfg_currentFontStyle = model[currentIndex]["name"]
                            Component.onCompleted: {
                                for (var i = 0; i < model.length; i++) {
                                    if (model[i]["name"] == plasmoid.configuration.currentFontStyle) {
                                        currentFontStyle.currentIndex = i;
                                    }
                                }
                            }
                        }
                    }

                    Row {
                        height: implicitHeight
                        width: parent.width
                        QtControls.Label {
                            height: parent.height
                            width: parent.width / 3
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            text: i18n("Font color")
                        }
                        QtControls.Button {
                            id: currentSelectColor
                            width: parent.width * 2 / 3
                            style: QtStyles.ButtonStyle {
                                background: Rectangle {
                                    color: plasmoid.configuration.currentFontColor
                                }
                            }
                            text: plasmoid.configuration.currentFontColor
                            onClicked: currentColorDialog.visible = true
                        }
                    }
                }

                QtDialogs.ColorDialog {
                    id: currentColorDialog
                    title: i18n("Select a color")
                    color: currentSelectColor.text
                    onAccepted: currentSelectColor.text = currentColorDialog.color
                }

                QtDialogs.FontDialog {
                    id: currentFontDialog
                    title: i18n("Select a font")
                    font: Qt.font({ family: currentSelectFont.text, pointSize: currentFontSize.value, weight: Font.Normal })
                    onAccepted: {
                        currentSelectFont.text = currentFontDialog.font.family
                        currentFontSize.value = currentFontDialog.font.pointSize
                        currentFontStyle.currentIndex = currentFontDialog.font.italic ? 1 : 0
                        currentFontWeight.currentIndex = weight[currentFontDialog.font.weight]
                    }
                }
            }

            QtControls.Tab {
                title: i18n("Inactive desktop")

                QtLayouts.ColumnLayout {
                    Row {
                        height: implicitHeight
                        width: parent.width
                        QtControls.Label {
                            height: parent.height
                            width: parent.width / 3
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            text: i18n("Font")
                        }
                        QtControls.Button {
                            id: selectFont
                            width: parent.width * 2 / 3
                            text: plasmoid.configuration.fontFamily
                            onClicked: fontDialog.visible = true
                        }
                    }

                    Row {
                        height: implicitHeight
                        width: parent.width
                        QtControls.Label {
                            height: parent.height
                            width: parent.width / 3
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            text: i18n("Font size")
                        }
                        QtControls.SpinBox {
                            id: fontSize
                            width: parent.width * 2 / 3
                            minimumValue: 8
                            maximumValue: 32
                            stepSize: 1
                            value: plasmoid.configuration.fontSize
                        }
                    }

                    Row {
                        height: implicitHeight
                        width: parent.width
                        QtControls.Label {
                            height: parent.height
                            width: parent.width / 3
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            text: i18n("Font weight")
                        }
                        QtControls.ComboBox {
                            id: fontWeight
                            width: parent.width * 2 / 3
                            textRole: "label"
                            model: [
                                {
                                    'label': i18n("light"),
                                    'name': "light"
                                },
                                {
                                    'label': i18n("normal"),
                                    'name': "normal"
                                },
                                {
                                    'label': i18n("demi bold"),
                                    'name': "demibold"
                                },
                                {
                                    'label': i18n("bold"),
                                    'name': "bold"
                                },
                                {
                                    'label': i18n("black"),
                                    'name': "black"
                                }
                            ]
                            onCurrentIndexChanged: cfg_fontWeight = model[currentIndex]["name"]
                            Component.onCompleted: {
                                for (var i = 0; i < model.length; i++) {
                                    if (model[i]["name"] == plasmoid.configuration.fontWeight) {
                                        fontWeight.currentIndex = i;
                                    }
                                }
                            }
                        }
                    }

                    Row {
                        height: implicitHeight
                        width: parent.width
                        QtControls.Label {
                            height: parent.height
                            width: parent.width / 3
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            text: i18n("Font style")
                        }
                        QtControls.ComboBox {
                            id: fontStyle
                            width: parent.width * 2 / 3
                            textRole: "label"
                            model: [
                                {
                                    'label': i18n("normal"),
                                    'name': "normal"
                                },
                                {
                                    'label': i18n("italic"),
                                    'name': "italic"
                                }
                            ]
                            onCurrentIndexChanged: cfg_fontStyle = model[currentIndex]["name"]
                            Component.onCompleted: {
                                for (var i = 0; i < model.length; i++) {
                                    if (model[i]["name"] == plasmoid.configuration.fontStyle) {
                                        fontStyle.currentIndex = i;
                                    }
                                }
                            }
                        }
                    }

                    Row {
                        height: implicitHeight
                        width: parent.width
                        QtControls.Label {
                            height: parent.height
                            width: parent.width / 3
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            text: i18n("Font color")
                        }
                        QtControls.Button {
                            id: selectColor
                            width: parent.width * 2 / 3
                            style: QtStyles.ButtonStyle {
                                background: Rectangle {
                                    color: plasmoid.configuration.fontColor
                                }
                            }
                            text: plasmoid.configuration.fontColor
                            onClicked: colorDialog.visible = true
                        }
                    }
                }

                QtDialogs.ColorDialog {
                    id: colorDialog
                    title: i18n("Select a color")
                    color: selectColor.text
                    onAccepted: selectColor.text = colorDialog.color
                }

                QtDialogs.FontDialog {
                    id: fontDialog
                    title: i18n("Select a font")
                    font: Qt.font({ family: selectFont.text, pointSize: fontSize.value, weight: Font.Normal })
                    onAccepted: {
                        selectFont.text = fontDialog.font.family
                        fontSize.value = fontDialog.font.pointSize
                        fontStyle.currentIndex = fontDialog.font.italic ? 1 : 0
                        fontWeight.currentIndex = weight[fontDialog.font.weight]
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        if (debug) console.log("[appearance::onCompleted]")
    }
}
