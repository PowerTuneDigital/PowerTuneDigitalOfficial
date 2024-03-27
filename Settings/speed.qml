import QtQuick 2.8
import QtQuick.Controls 2.1
import Qt.labs.settings 1.0

Rectangle {
    id: windowbackround
    anchors.fill: parent
    color: "grey"


    Item {
        id: speedcorretionsettings
        Settings {
            property alias speedpercentsetting: speedpercent.text
            property alias pulsespermilesetting: pulsespermile.text
            property alias usbvrsensorcheckstate: usbvrcheckbox.checkState
            property alias connectbuttonenabled: connectButtonArd.enabled
            property alias disconnectbuttonenabled: disconnectButtonArd.enabled
        }
    }
    Grid {
        rows: 5
        columns: 2
        id: grid
        spacing: windowbackround.height / 150
        Text {
            text: qsTr("SpeedCorrection")
            font.pixelSize: windowbackround.width / 55
            color: "white"
        }
        TextField {
            id: speedpercent
            width: windowbackround.width / 5
            height: windowbackround.height / 15
            font.pixelSize: windowbackround.width / 55
            text: "100"
            inputMethodHints: Qt.ImhFormattedNumbersOnly // this ensures valid inputs are number only
            Component.onCompleted: {
                AppSettings.writeSpeedSettings(speedpercent.text / 100, pulsespermile.text)
            }
            onEditingFinished: AppSettings.writeSpeedSettings(
                                   speedpercent.text / 100, pulsespermile.text)
        }
        Text {
            text: qsTr("USB VR Speed Sensor")
            font.pixelSize: windowbackround.width / 55
            color: "white"
        }

        CheckBox {
            id: usbvrcheckbox
            width: windowbackround.width / 14
            height: windowbackround.height /15
            onCheckStateChanged: {

                if (usbvrcheckbox.checkState == false)
                {
                    if (Dashboard.externalspeedconnectionrequest ==1)
                    {
                        Arduino.closeConnection()
                    }
                    AppSettings.externalspeedconnectionstatus(0)
                    connectButtonArd.enabled = true
                    disconnectButtonArd.enabled = false
                }

               }
            }
        Text {
            text: qsTr("Pulses per mile")
            font.pixelSize: windowbackround.width / 55
            color: "white"
            visible: usbvrcheckbox.checked

        }
        TextField {
            id: pulsespermile
            width: windowbackround.width / 5
            height: windowbackround.height / 15
            font.pixelSize: windowbackround.width / 55
            visible: usbvrcheckbox.checked
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
            text: qsTr("External Speed port")
            color: "white"
            font.pixelSize: windowbackround.width / 55
            visible: usbvrcheckbox.checked
                    }
        ComboBox {
            id: serialNameArd
            width: windowbackround.width / 5
            height: windowbackround.height / 15
            font.pixelSize: windowbackround.width / 55
            visible: usbvrcheckbox.checked
            model: Connect.portsNames
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
            font.pixelSize: windowbackround.width / 55
            color: "white"
        }
        Button {
            id: connectButtonArd
            visible: usbvrcheckbox.checked
            text: qsTr("Connect")
            width: windowbackround.width / 5
            height: windowbackround.height / 15
            font.pixelSize: windowbackround.width / 55
            onClicked: {
                AppSettings.externalspeedconnectionstatus(1)
                AppSettings.externalspeedport(serialNameArd.textAt(serialNameArd.currentIndex))
                Arduino.openConnection(Dashboard.externalspeedport, "9600")
                connectButtonArd.enabled = false
                disconnectButtonArd.enabled = true
            }
        }
        Button {
            id: disconnectButtonArd
            visible: usbvrcheckbox.checked
            text: qsTr("Disconnect")
            width: windowbackround.width / 5
            height: windowbackround.height / 15
            font.pixelSize: windowbackround.width / 55
            enabled: false
            onClicked: {
                AppSettings.externalspeedconnectionstatus(0)
                Arduino.closeConnection()
                connectButtonArd.enabled = true
                disconnectButtonArd.enabled = false
            }
        }
    }
}
