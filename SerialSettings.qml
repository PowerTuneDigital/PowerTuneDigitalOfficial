import QtQuick 2.8
import QtQuick.Controls 1.4 as Quick1
import QtQuick.Controls 2.1
import Qt.labs.settings 1.0
import QtSensors 5.0
import QtQuick.Controls.Styles 1.4

import QtMultimedia 5.8
import "qrc:/Gauges/"
import DLM 1.0
import QtQuick.VirtualKeyboard 2.1

Quick1.TabView {
    id: tabView
    anchors.fill: parent

    property int lastdashamount

    DLM {
        id: downloadManager
    }

    Rectangle {
        id: keyboardcontainer
        color: "darkgrey"
        visible: false
        width: 500
        height: 180
        z: 220

        MouseArea {
            id: touchAkeyboardcontainer
            anchors.fill: parent
            drag.target: keyboardcontainer
        }
        InputPanel {
            id: keyboard
            anchors.fill: parent
            visible: false
            states: State {
                name: "visible"
                when: keyboard.active
                PropertyChanges {
                    target: keyboard
                    visible: true
                }
                PropertyChanges {
                    target: keyboardcontainer
                    visible: true
                    x: 300
                    y: 200
                }
            }
        }
    }

    style: TabViewStyle {
        frameOverlap: 1
        tab: Rectangle {
            id: tabrect
            color: styleData.selected ? "grey" : "lightgrey"
            border.color: "steelblue"
            implicitWidth: Math.max(text.width + 4, 80)
            implicitHeight: 50
            radius: 2
            Text {
                id: text
                anchors.centerIn: parent
                font.pixelSize: tabView.width / 55
                text: styleData.title
                color: styleData.selected ? "white" : "black"
            }
        }
        frame: Rectangle {
            color: "steelblue"
        }
    }
    Quick1.Tab {
        title: "Main"
        anchors.fill: parent
        source: "Settings/main.qml"
    }
    Quick1.Tab {
        id: dash
        title: "Dash Sel."
        source: "Settings/dash_sel.qml"
    }

    Quick1.Tab {
        title: "Sensehat" // Tab index 2
        //Sensehat Sensors
        source: "Settings/sensehat.qml"
    }
    Quick1.Tab {
        title: "Warn / Gear" // Tab index 3
        //Warning Settings by Craig Shoesmith
        source: "Settings/warn_gear.qml"
    }
    Quick1.Tab {
        title: "Speed" // Tab index 4
        source: "Settings/speed.qml"
    }

    Quick1.Tab {
        id: regtab
        title: "" // Tab index 5
        visible: false
        source: "Settings/analog.qml"
    }
    Quick1.Tab {
        title: "RPM"
        source: "Settings/rpm.qml"
    }

    Quick1.Tab {
        title: "EX Board" // Tab index 6
        Rectangle {
            id: exboard
            anchors.fill: parent
            color: "grey"
            ExBoardAnalog {}
            Component.onCompleted: {

                tabView.currentIndex++
                // console.log("switch tab index ")
            }
        }
    }

    Quick1.Tab {
        title: "Startup" // Tab index 8
        source: "Settings/startup.qml"
    }
    /////////////////////////////////////////////////////////////////////////////////////////////
    Quick1.Tab {
        title: "Network" // Tab index 9
        source: "Settings/network.qml"
    }
}
