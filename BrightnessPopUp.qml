import QtQuick 2.8
import QtQuick.Controls 1.4
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.3
import com.powertune 1.0
import QtQuick.VirtualKeyboard 2.1
import "Translator.js" as Translator
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.10 //compatibility with QT 5.10
import Qt.labs.settings 1.0

Rectangle{
        id: popUp1
        color: "grey"
        width: parent.width
        height: parent.height
        //anchors.right: parent.right


        Grid {
            id :buttonRow
            width: parent.width
            height: parent.height * 0.8
            topPadding: parent.width * 0.6
            rows: 3
            columns: 1
            //anchors.right: parent.right
            layoutDirection: "RightToLeft"
            spacing: popUp1.width / 12
            visible: true //Dashboard.screen

            Button {
                id: brightnessLow                
                text: "🌙 Night"
                font.family: "Eurostile"
                font.bold: true
                width: popUp1.width / 1.2
                height: popUp1.width / 1.2//5.5
                font.pixelSize: popUp1.width / 7.5
                onClicked: {brightness.value = 25;
                            Connect.setSreenbrightness(25);
                            AppSettings.writebrightnessettings(25);
                            console.log("Low Brightness " + brightness.value)
                }
                background: Rectangle {
                    radius: popUp1.width / 1.2
                    opacity: enabled ? 1 : 0.3
                    color: brightnessLow.down ? "darkgrey" : "grey"
                    border.color: brightnessLow.down ? "grey" : "darkgrey"
                    border.width: popUp1.width / 1.5
                        }
            }

            Button {
                id: brightnessHigh
                text: "☀️ Day"
                font.family: "Eurostile"
                font.bold: true
                width: popUp1.width / 1.2
                height: popUp1.width / 1.2
                font.pixelSize: popUp1.width / 7.5
                transformOrigin: Item.Center
                onClicked: {brightness.value = 255;
                    Connect.setSreenbrightness(255);
                            AppSettings.writebrightnessettings(255);
                            console.log("High Brightness " + brightness.value)
                }
                background: Rectangle {
                            radius: popUp1.width / 1.2
                            opacity: enabled ? 1 : 0.3
                            color: brightnessHigh.down ? "darkgrey" : "grey"
                            border.color: brightnessHigh.down ? "grey" : "darkgrey"
                            border.width: popUp1.width / 1.5
                        }
            }
        }

           Timer {
             interval: 8000
             running: true
             onTriggered: popUp1.visible = false
             Component.onCompleted: {
                 console.log("Brightness invisible")
             }
       }

}

