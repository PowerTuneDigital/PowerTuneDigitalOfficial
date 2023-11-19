import QtQuick 2.8
import QtQuick.Controls 2.1
import Qt.labs.settings 1.0
import "qrc:/Translator.js" as Translator

Rectangle {
    id: calcs
    anchors.fill: parent
    color: "grey"
    Item {
        id: speedSettings
        Settings {
            property alias connectArdAtStartup: connectButtonArd.enabled
        }
    }
    Item {
        //Function to connect and disconnect GPS
        id: autoconnectArd
        function auto() {

            // if (gpsswitch.checked == true)GPS.startGPScom(serialNameGPS.currentText,serialGPSBaud.currentText);
            if (connectButtonArd.enabled == false) {
                Arduino.openConnection(serialNameArd.currentText, "9600")
                disconnectButtonArd.enabled = true
            }
            //if (connectButtonGPS.enabled == true)GPS.openConnection(serialNameGPS.currentText,"9600"),disconnectButtonGPS.enabled=false;
            //if (gpsswitch.checked == false)GPS.closeConnection(),console.log("GPS CLOSED BY QML");
        }
    }
    Item {
        id: speedcorretionsettings
        Settings {
            property alias speedpercentsetting: speedpercent.text
            property alias pulsespermilesetting: pulsespermile.text
        }
    }
    Grid {
        rows: 5
        columns: 2
        id: grid
        spacing: calcs.height / 150
        Text {
            text: Translator.translate("SpeedCorrection", Dashboard.Language)
            font.pixelSize: calcs.width / 55
            color: "white"
        }
        TextField {
            id: speedpercent
            width: calcs.width / 5
            height: calcs.height / 15
            font.pixelSize: calcs.width / 55
            text: "100"
            inputMethodHints: Qt.ImhFormattedNumbersOnly // this ensures valid inputs are number only
            Component.onCompleted: {
                AppSettings.writeSpeedSettings(speedpercent.text / 100, pulsespermile.text)
            }
            onEditingFinished: AppSettings.writeSpeedSettings(
                                   speedpercent.text / 100, pulsespermile.text)
        }
        Text {
            text: "Pulses Per Mile"
            font.pixelSize: calcs.width / 55
            color: "white"
        }
        TextField {
            id: pulsespermile
            width: calcs.width / 5
            height: calcs.height / 15
            font.pixelSize: calcs.width / 55
            text: "100000"
            inputMethodHints: Qt.ImhFormattedNumbersOnly // this ensures valid inputs are number only
            Component.onCompleted: {
                AppSettings.writeSpeedSettings(speedpercent.text / 100, pulsespermile.text)
            }
            onEditingFinished: AppSettings.writeSpeedSettings(
                                   speedpercent.text / 100, pulsespermile.text)
        }
        Text {
            //periferal serial port box
            text: "External Speed Port:"
            color: "white"
            font.pixelSize: calcs.width / 55
        }
        ComboBox {
            id: serialNameArd
            width: calcs.width / 5
            height: calcs.height / 15
            font.pixelSize: calcs.width / 55
            model: Connect.portsNames
            // visible: { (gpsswitch.checked == true ) ? true:false; }
            delegate: ItemDelegate {
                width: serialNameArd.width
                text: serialNameArd.textRole ? (Array.isArray(
                                                    control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
                font.weight: serialNameArd.currentIndex
                             == index ? Font.DemiBold : Font.Normal
                font.family: serialNameArd.font.family
                font.pixelSize: serialNameArd.font.pixelSize
                highlighted: serialNameArd.highlightedIndex == index
                hoverEnabled: serialNameArd.hoverEnabled
            }
        }
        Text {
            text: ""
            font.pixelSize: calcs.width / 55
            color: "white"
        }
        Button {
            id: connectButtonArd
            text: "Speed Connect"
            width: calcs.width / 5
            height: calcs.height / 15
            font.pixelSize: calcs.width / 55
            Component.onCompleted: autoconnectArd.auto()
            onClicked: {
                AppSettings.externalspeedconnectionstatus(1)
                connectButtonArd.enabled = false
                disconnectButtonArd.enabled = true
                autoconnectArd.auto()
            }
        }
        Button {
            id: disconnectButtonArd
            text: "Speed Disconnect"
            width: calcs.width / 5
            height: calcs.height / 15
            font.pixelSize: calcs.width / 55
            enabled: false
            onClicked: {
                AppSettings.externalspeedconnectionstatus(0)
                connectButtonArd.enabled = true
                disconnectButtonArd.enabled = false
                Arduino.closeConnection()
            }
        }
    }
}
