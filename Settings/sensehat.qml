import QtQuick 2.8
import QtQuick.Controls 2.1
import Qt.labs.settings 1.0
import "qrc:/Translator.js" as Translator
Rectangle {

    id: senhatselector
    anchors.fill: parent
    color: "grey"

    Item {
        id: sensehatsettings
        Settings {

            property alias accelswitch: accelsens.checked
            property alias gyrowitch: gyrosense.checked
            property alias compassswitch: compass.checked
            property alias tempswitch: tempsense.checked
            property alias pressureswitch: pressuresens.checked
        }

        Grid {
            rows: 6
            columns: 2
            spacing: senhatselector.width / 150
            anchors.top: parent.top
            anchors.topMargin: parent.height / 20
            Switch {
                id: accelsens
                text: Translator.translate("Accelerometer", Dashboard.language)
                font.pixelSize: senhatselector.width / 45
                onClicked: {
                    if (accelsens.checked == true) {
                        Sens.Accel()
                    }
                    ;
                }
            }
            Switch {
                id: gyrosense
                text: Translator.translate("Gyro Sensor", Dashboard.language)
                font.pixelSize: senhatselector.width / 45
                onClicked: {

                    if (gyrosense.checked == true) {
                        Sens.Gyro()
                    }
                    ;
                }
            }
            Switch {
                id: compass
                text: Translator.translate("Compass", Dashboard.language)
                font.pixelSize: senhatselector.width / 45
                onClicked: {
                    if (compass.checked == true) {
                        Sens.Comp()
                    }
                    ;
                }
            }
            Switch {
                id: pressuresens
                text: Translator.translate("Pressure Sensor", Dashboard.language)
                font.pixelSize: senhatselector.width / 45
                onClicked: {

                    if (pressuresens.checked == true) {
                        Sens.Pressure()
                    }
                    ;
                }
            }
            Switch {
                id: tempsense
                text: Translator.translate("Temperature Sensor", Dashboard.language)
                font.pixelSize: senhatselector.width / 45
                onClicked: {

                    if (tempsense.checked == true) {
                        Sens.Temperature()
                    }
                    ;
                }
            }
        }
    }
}
