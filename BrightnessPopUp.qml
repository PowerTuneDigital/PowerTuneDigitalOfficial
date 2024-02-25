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
        color: "grey"
        opacity: 0.9
        width: 500
        height: 300
        anchors.centerIn: parent
        focus: true
        radius: 10

        Text {
            id: titleText
            width: 452
            height: 77
            font.pixelSize: 36
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.top : parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            text:"Brightness"
            topPadding: 10
            font.bold: true
            font.family: "Eurostile"
            color: "white"
        }

        Rectangle{
            id:testBackground
            x: 8
            y: 83
            width: 484
            height: 209
            opacity: 0.9
            color: "black"
            radius: 10

        }

        Grid {
            id :buttonRow
            x: 24
            y: 97
            width: parent.width * 0.9
            height: parent.height * 0.35
            rows: 1
            columns: 3
            topPadding: popUp1.width / 30
            spacing: popUp1.width / 9
            visible: true //Dashboard.screen
            verticalItemAlignment: Grid.AlignTop

            Button {
                id: brightnessLow
                text: "Low"
                anchors.left: parent.left
                anchors.top: parent.top
                font.family: "Eurostile"
                font.bold: true
                width: popUp1.width / 5.5
                height: popUp1.width / 5.5
                font.pixelSize: popUp1.width / 50
                anchors.topMargin: 0
                anchors.leftMargin: 0
                onClicked: {brightness.value = 25;
                            Connect.setSreenbrightness(25);
                            AppSettings.writebrightnessettings(25);
                            console.log("Low Brightness " + brightness.value)
                }background: Rectangle {
                    radius: popUp1.width / 10
                    opacity: enabled ? 1 : 0.3
                    color: brightnessLow.down ? "darkgrey" : "grey"
                    border.color: brightnessLow.down ? "grey" : "darkgrey"
                    border.width: popUp1.width / 200
                        }
            }

            Button {
                id: brightnessMedium
                visible: true
                text: "Medium"
                anchors.top: parent.top
                font.family: "Eurostile"
                font.bold: true
                width: popUp1.width / 5.5
                height: popUp1.width / 5.5
                font.pixelSize: popUp1.width / 50
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 0
                onClicked: {brightness.value = 140;
                    Connect.setSreenbrightness(140);
                            AppSettings.writebrightnessettings(140);
                            console.log("Medium Brightness " + brightness.value)
                }background: Rectangle {
                    radius: popUp1.width / 10
                    opacity: enabled ? 1 : 0.3
                    color: brightnessMedium.down ? "darkgrey" : "grey"
                    border.color: brightnessMedium.down ? "grey" : "darkgrey"
                    border.width: popUp1.width / 200
                        }
            }

            Button {
                id: brightnessHigh
                x: 0
                text: "High"
                anchors.right: parent.right
                anchors.top: parent.top
                //anchors.right: parent.right
                font.family: "Eurostile"
                font.bold: true
                width: popUp1.width / 5.5
                height: popUp1.width / 5.5
                font.pixelSize: popUp1.width / 50
                anchors.rightMargin: 0
                anchors.topMargin: 0
                transformOrigin: Item.Center
                onClicked: {brightness.value = 255;
                    Connect.setSreenbrightness(255);
                            AppSettings.writebrightnessettings(255);
                            console.log("High Brightness " + brightness.value)
                }
                background: Rectangle {
                            radius: popUp1.width / 10
                            opacity: enabled ? 1 : 0.3
                            color: brightnessHigh.down ? "darkgrey" : "grey"
                            border.color: brightnessHigh.down ? "grey" : "darkgrey"
                            border.width: popUp1.width / 200
                        }
            }
        }

        Grid {
            id : sliderRow
            y: 169
            width: parent.width * 0.9
            height: parent.height * 0.35
            rows: 1
            columns: 2
            spacing: parent.width / 20
            topPadding: parent.height / 8
            anchors.top: buttonRow.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            visible: Dashboard.screen

        Image {
                height: popUp1.height / 10
                width:height
                id: brightnessimage
                source: "qrc:/graphics/brightness.png"
            }

        Slider {
            id:brightness
            width: popUp1.width / 1.4
            height: popUp1.height / 12
            stepSize: 5
            from: 20
            to: 255
            value: Dashboard.Brightness
            onValueChanged: {
                     Connect.setSreenbrightness(brightness.value);
                     AppSettings.writebrightnessettings(brightness.value);
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

