import QtQuick 2.8
import QtQuick.Controls 2.1
import Qt.labs.settings 1.0

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
                text: qsTr("Accelerometer")
                onCheckedChanged: {
                    if (accelsens.checked == true) {
                        Sens.Accel()
                    }
                    ;
                }
            }
            Switch {
                id: gyrosense
                text: qsTr("Gyro Sensor")
                onCheckedChanged: {

                    if (gyrosense.checked == true) {
                        Sens.Gyro()
                    }
                    ;
                }
            }
            Switch {
                id: compass
                text: qsTr("Compass")
                onCheckedChanged: {
                    if (compass.checked == true) {
                        Sens.Comp()
                    }
                    ;
                }
            }
            Switch {
                id: pressuresens
                text: qsTr("Pressure Sensor")
                onCheckedChanged: {

                    if (pressuresens.checked == true) {
                        Sens.Pressure()
                    }
                    ;
                }
            }
            Switch {
                id: tempsense
                text: qsTr("Temperature Sensor")
                onCheckedChanged: {

                    if (tempsense.checked == true) {
                        Sens.Temperature()
                    }
                    ;
                }
            }
        }
    }
}
