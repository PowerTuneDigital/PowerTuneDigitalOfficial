import QtQuick 2.8
import QtQuick.Controls 1.4
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.3
import com.powertune 1.0
import QtQuick.VirtualKeyboard 2.1
import "Translator.js" as Translator

Rectangle{
        id: popUp1
        visible: true
        color: "grey"
        opacity: 0.8
        width: 500
        height: 300
        anchors.centerIn: parent
        focus: true
        radius: 10



        Text {
            id: titleText
            font.pixelSize: 36
            anchors.top : parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            text:"Brightness"
            topPadding: 10
            font.bold: true
            font.family: "Eurostile"
            color: "white"

        }


        Grid {
            id :row5
            x: 24
            y: 109
            width: 452
            height: 119
            rows: 1
            columns: 3
            topPadding: window.width / 40
            spacing: window.width / 9
            visible: Dashboard.screen
            verticalItemAlignment: Grid.AlignTop



            Button {
                id: brightnessLow
                y: 0
                text: "Low"
                font.family: "Eurostile"
                font.bold: true
                width: window.width / 9
                height: window.width / 9
                font.pixelSize: window.width / 70
                onClicked: {brightness.value = 25;
                            Connect.setSreenbrightness(25);
                            AppSettings.writebrightnessettings(25);
                            console.log("Low Brightness " + brightness.value)
                }

                background: Rectangle {
                    radius: window.width / 10
                    opacity: enabled ? 1 : 0.3
                    color: brightnessLow.down ? "darkgrey" : "grey"
                    border.color: brightnessLow.down ? "grey" : "darkgrey"
                    border.width: window.width / 200
                        }
            }

            Button {
                id: brightnessMedium
                width: 89
                text: "Medium"
                font.family: "Eurostile"
                font.bold: true
                height: window.width / 9
                font.pixelSize: window.width / 70
                onClicked: {brightness.value = 25;
                            Connect.setSreenbrightness(140);
                            AppSettings.writebrightnessettings(140);
                            console.log("Low Brightness " + brightness.value)
                }

                background: Rectangle {
                    radius: window.width / 10
                    opacity: enabled ? 1 : 0.3
                    color: brightnessMedium.down ? "darkgrey" : "grey"
                    border.color: brightnessMedium.down ? "grey" : "darkgrey"
                    border.width: window.width / 200
                        }
            }

            Button {
                id: brightnessHigh
                text: "High"
                font.family: "Eurostile"
                font.bold: true
                width: window.width / 9
                height: window.width / 9
                font.pixelSize: window.width / 70
                onClicked: {brightness.value = 255;
                    Connect.setSreenbrightness(255);
                            AppSettings.writebrightnessettings(255);
                            console.log("High Brightness " + brightness.value)
                }
                background: Rectangle {
                            radius: window.width / 10
                            opacity: enabled ? 1 : 0.3
                            color: brightnessHigh.down ? "darkgrey" : "grey"
                            border.color: brightnessHigh.down ? "grey" : "darkgrey"
                            border.width: window.width / 200
                        }
            }
        }

           Timer {
             interval: 8000
             running: true
             onTriggered: popUp1.visible = false
       }

}

