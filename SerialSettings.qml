import QtQuick 2.8
import QtQuick.Controls 1.4 as Quick1
import QtQuick.Controls 2.1
import Qt.labs.settings 1.0
import QtSensors 5.0
import QtQuick.Controls.Styles 1.4
import QtMultimedia 5.8
import "qrc:/Gauges/"
import DLM 1.0
import "qrc:/Translator.js" as Translator

Quick1.TabView {
    id: tabView
    anchors.fill: parent

    property int lastdashamount

    DLM {
        id: downloadManager
    }
    Connections {
        target: Dashboard
        onEcuChanged: {
            setregtabtitle()
        }
        onLanguageChanged: {
            setregtabtitle()
         }
    }

    style: TabViewStyle {
        frameOverlap: 1
        tab: Rectangle {
            id: tabrect
            color: styleData.selected ? "grey" : "lightgrey"
            border.color: "steelblue"
            implicitWidth: 80//Math.max(text.width + 4, 80)
            implicitHeight: 50
            radius: 2
            Text {
                id: text
                width: parent.width - 10 // Adjust the width to provide some padding
                wrapMode: Text.Wrap // Enable text wrapping
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
        id:tab1
        title: qsTr("Main")
        anchors.fill: parent
        source: "Settings/main.qml"

    }
    Quick1.Tab {
        id: dash
        title: qsTr("Dash Sel.")
        source: "Settings/DashSelector.qml"
    }

    Quick1.Tab {
        title: qsTr("Sensehat")// Tab index 2
        source: "Settings/sensehat.qml"
    }
    Quick1.Tab {
        title: qsTr("Warn / Gear")  // Tab index 3
        source: "Settings/warn_gear.qml"
    }
    Quick1.Tab {
        title: qsTr("Speedtab") // Tab index 4
        source: "Settings/speed.qml"
    }

    Quick1.Tab {
        id: regtab
        title: "" // Tab index 5
        source: "Settings/analog.qml"
        Component.onCompleted: setregtabtitle()
    }
    Quick1.Tab {
        title: qsTr("RPM2")
        source: "Settings/rpm.qml"
    }

    Quick1.Tab {
        title: qsTr("EX Board") // Tab index 6
        source: "qrc:/ExBoardAnalog.qml"
    }

    Quick1.Tab {
        title: qsTr("Startup") // Tab index 8
        source: "Settings/startup.qml"
    }

    Quick1.Tab {
        title: qsTr("Network") // Tab index 9
        source: "Settings/network.qml"
    }

    function setregtabtitle() {
        if (Dashboard.ecu == "0") {
            regtab.title = qsTr("Analog")
        }
        if (Dashboard.ecu == "1") {
            regtab.title = qsTr("Analog")
        }
        if (Dashboard.ecu == "2") {
            regtab.title = "Consult"
        }
        if (Dashboard.ecu == "3") {
            regtab.title = "OBD"
        }
        if (Dashboard.ecu == "4") {
            regtab.title = "Generic CAN"
        }
    }
}
