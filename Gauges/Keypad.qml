import QtQuick 2.8
import QtQuick.Controls 2.1
import Qt.labs.settings 1.0
import QtQuick.Controls.Styles 1.4

Item {
    id: keypad
    anchors.fill: parent


    Grid{
        rows:3
        columns: 4
        anchors.centerIn: parent
        Button{
            id: keypadButton1
            width: keypad.width / 7
            height: keypad.width / 7
            text: "BOOST -"
            background: Rectangle {
                radius: keypad.width / 10
                opacity: enabled ? 1 : 0.3
                color: keypadButton1.down ? "grey" : "darkgrey"
                border.color: keypadButton1.down ? "darkgrey" : "grey"
                border.width: keypad.width / 60
                }
        }

        Button{
            id: keypadButton2
            width: keypad.width / 7
            height: keypad.width / 7
            text: "BOOST +"
            background: Rectangle {
                radius: keypad.width / 10
                opacity: enabled ? 1 : 0.3
                color: keypadButton2.down ? "grey" : "darkgrey"
                border.color: keypadButton2.down ? "darkgrey" : "grey"
                border.width: keypad.width / 60
                }
        }

        Button{
            id: keypadButton3
            width: keypad.width / 7
            height: keypad.width / 7
            text: "Fan"
            background: Rectangle {
                radius: keypad.width / 10
                opacity: enabled ? 1 : 0.3
                color: keypadButton3.down ? "grey" : "darkgrey"
                border.color: keypadButton3.down ? "darkgrey" : "grey"
                border.width: keypad.width / 60
                }
            Image{
                source: "qrc:/graphics/fanIcon.jpg"
                //anchors.fill: plusBrightness
                width: keypadButton3.width
                height: keypadButton3.height
                //anchors.centerIn: keypadButton3.horizontalCenter
                }
        }

        Button{
            id: keypadButton4
            width: keypad.width / 7
            height: keypad.width / 7
            text: "Engine"
            background: Rectangle {
                radius: keypad.width / 10
                opacity: enabled ? 1 : 0.3
                color: keypadButton4.down ? "grey" : "darkgrey"
                border.color: keypadButton4.down ? "darkgrey" : "grey"
                border.width: keypad.width / 60
                }
        }

        Button{
            id: keypadButton5
            width: keypad.width / 7
            height: keypad.width / 7
            text: "Window Wiper"
            background: Rectangle {
                radius: keypad.width / 10
                opacity: enabled ? 1 : 0.3
                color: keypadButton5.down ? "grey" : "darkgrey"
                border.color: keypadButton5.down ? "darkgrey" : "grey"
                border.width: keypad.width / 60
                }
        }

        Button{
            id: keypadButton6
            width: keypad.width / 7
            height: keypad.width / 7
            text: "Fuel"
            background: Rectangle {
                radius: keypad.width / 10
                opacity: enabled ? 1 : 0.3
                color: keypadButton6.down ? "grey" : "darkgrey"
                border.color: keypadButton6.down ? "darkgrey" : "grey"
                border.width: keypad.width / 60
                }
        }

        Button{
            id: keypadButton7
            width: keypad.width / 7
            height: keypad.width / 7
            text: "Horn"
            background: Rectangle {
                radius: keypad.width / 10
                opacity: enabled ? 1 : 0.3
                color: keypadButton7.down ? "grey" : "darkgrey"
                border.color: keypadButton7.down ? "darkgrey" : "grey"
                border.width: keypad.width / 60
                }
        }

        Button{
            id: keypadButton8
            width: keypad.width / 7
            height: keypad.width / 7
            text: "Warning"
            background: Rectangle {
                radius: keypad.width / 10
                opacity: enabled ? 1 : 0.3
                color: keypadButton8.down ? "grey" : "darkgrey"
                border.color: keypadButton8.down ? "darkgrey" : "grey"
                border.width: keypad.width / 60
                }
        }
        Button{
            id: keypadButton9
            width: keypad.width / 7
            height: keypad.width / 7
            text: "Headlight"
            background: Rectangle {
                radius: keypad.width / 10
                opacity: enabled ? 1 : 0.3
                color: keypadButton9.down ? "grey" : "darkgrey"
                border.color: keypadButton9.down ? "darkgrey" : "grey"
                border.width: keypad.width / 60
                }
        }
        Button{
                id: keypadButton10
                width: keypad.width / 7
                height: keypad.width / 7
                text: "Something"
                background: Rectangle {
                    radius: keypad.width / 10
                    opacity: enabled ? 1 : 0.3
                    color: keypadButton10.down ? "grey" : "darkgrey"
                    border.color: keypadButton10.down ? "darkgrey" : "grey"
                    border.width: keypad.width / 60
                    }
            }
            Button{
                id: keypadButton11
                width: keypad.width / 7
                height: keypad.width / 7
                text: "Something"
                background: Rectangle {
                    radius: keypad.width / 10
                    opacity: enabled ? 1 : 0.3
                    color: keypadButton11.down ? "grey" : "darkgrey"
                    border.color: keypadButton11.down ? "darkgrey" : "grey"
                    border.width: keypad.width / 60
                    }
            }
            Button{
                id: keypadButton12
                width: keypad.width / 7
                height: keypad.width / 7
                text: "Shutdown"
                background: Rectangle {
                    radius: keypad.width / 10
                    opacity: enabled ? 1 : 0.3
                    color: keypadButton12.down ? "grey" : "darkgrey"
                    border.color: keypadButton12.down ? "darkgrey" : "grey"
                    border.width: keypad.width / 60
                    }
            }
    }
}
