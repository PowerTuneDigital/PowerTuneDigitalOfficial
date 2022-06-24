import QtQuick 2.8
import QtQuick.Controls 2.1
import Qt.labs.settings 1.0

Rectangle {
    anchors.fill: parent
    color: "grey"


Settings {
            // property alias connectAtStartUp: connectAtStart.checked
            // property alias connectGPSAtStartup: connectButtonGPS.enabled
            //property alias gpsswitch: gpsswitch.checked
            property alias gpsPortName: serialNameGPS.currentText
            property alias gpsPortNameindex: serialNameGPS.currentIndex
            //property alias gpsBaud: serialGPSBaud.currentText
            //property alias gpsBaudindex: serialGPSBaud.currentIndex
        }

     Grid {
        anchors.top: parent.top
        anchors.topMargin: parent.height / 20
        rows: 2
        columns: 2
        Text {
            text: "GPS Port: "
        }
        ComboBox {
            id: serialNameGPS
            model: Connect.portsNames
            delegate: ItemDelegate {
                width: serialNameGPS.width
                text: serialNameGPS.textRole ? (Array.isArray(
                                                    control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
                font.weight: serialNameGPS.currentIndex
                                == index ? Font.DemiBold : Font.Normal
                highlighted: serialNameGPS.highlightedIndex == index
                hoverEnabled: serialNameGPS.hoverEnabled
            }
        }

        Button {
            id: connectButtonGPS
            text: "GPS Connect"
            Component.onCompleted: autoconnectGPS.auto()
            onClicked: {

                //console.log("clicked GPS")
                connectButtonGPS.enabled = false
                disconnectButtonGPS.enabled = true
                autoconnectGPS.auto()
                //console.log("gps disconnect enabled")
            }
        }
        Button {
            id: disconnectButtonGPS
            text: "GPS Disconnect"
            enabled: false
            onClicked: {
                connectButtonGPS.enabled = true
                disconnectButtonGPS.enabled = false
                Gps.closeConnection()
            }
        }

        }
}