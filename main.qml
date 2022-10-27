import QtQuick 2.8
import QtQuick.Controls 1.4 as Quick1
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.3
import com.powertune 1.0
import QtQuick.VirtualKeyboard 2.1

ApplicationWindow {
    id:window
    visible: true
    width: 800
    height: 480
    minimumWidth: 800
    minimumHeight: 480
    title: qsTr("PowerTune ") + Dashboard.Platform
    color: "black"
    //Screen Keyboard do not change !!! Behaviour between QT5.10 and QT5.15 is different
    Rectangle {
        id: keyboardcontainer
        color: "blue"
        visible: false
        width: 500
        height: 220
        z: 220

        MouseArea {
            id: touchAkeyboardcontainer
            anchors.fill: parent
            drag.target: keyboardcontainer
        }

        InputPanel {
            id: keyboard
            anchors.fill: keyboardcontainer
            x:keyboardcontainer.x
            y:keyboardcontainer.y
            visible: false
            states: State {
                name: "visible"
                when: keyboard.active
                PropertyChanges {
                    target: keyboardcontainer
                    visible: true
                }
                PropertyChanges {
                    target: keyboard
                    visible: true
                }
                PropertyChanges {
                    target: drawerpopup
                    interactive: false
                }
            }
        }

    }

    Connections{
            target: Dashboard
            onBrigtnessChanged: {
            brightness.value = Dashboard.Brightness
            }
    }

    Item {
        id: name
        Component.onCompleted: Connect.checkifraspberrypi()
    }


    SwipeView {
        id: dashView

        currentIndex: 0
        anchors.fill: parent
        //Component.onCompleted: Connect.readavailabledashfiles()

        Loader {
            id: firstPageLoader
            //active: SwipeView.isCurrentItem || SwipeView.isPreviousItem || firstPageLoader.source == "qrc:/GPSTracks/Laptimer.qml"
            source: "qrc:/Intro.qml"
        }

        Loader {
            id: secondPageLoader
            active: Dashboard.Visibledashes > 1
            source: ""
        }
        Loader {
            id: thirdPageLoader
            active: Dashboard.Visibledashes > 2;
            source: ""
        }
        
        Loader {
            id: fourthPageLoader
            active: Dashboard.Visibledashes > 3;
            source: ""
        }

        Item {
            id:lastPage
            SerialSettings{}
        }
    }
    /* For future use
    Button {
        id: btnfinaliseupdate
        
        text: "Click to finalise update"
        width: window.width / 1.5
        height: window.height / 1.5
        font.pixelSize: window.width / 20
        anchors.centerIn: parent
        onClicked: {
            console.log("apply Fixes")
            btnfinaliseupdate.text = "Please wait for reboot..."
        }
    }
    */
    Drawer {
        id: drawerpopup

        width: window.width
        height: 0.5 * window.height
        edge: Qt.TopEdge
        background: Rectangle {
            color: "grey"
            opacity: 0.8
            Rectangle {
                x: parent.width - 3
                width: 1
                height: parent.height
                color: "black"
            }
        }

        Grid {
            id :row1
            rows: 1
            columns: 2
            topPadding: window.width / 40
            spacing: window.width / 3
            anchors.horizontalCenter: parent.horizontalCenter
            //anchors.centerIn: parent
            Button {
                id: btntripreset
                text: "Trip Reset"
                font.family: "Eurostile"
                font.bold: true
                width: window.width / 9
                height: window.width / 9
                font.pixelSize: window.width / 70
                onClicked: {Calculations.resettrip()}
                background: Rectangle {
                    radius: window.width / 10
                    opacity: enabled ? 1 : 0.3
                    color: btntripreset.down ? "darkgrey" : "grey"
                    border.color: btntripreset.down ? "grey" : "darkgrey"
                    border.width: window.width / 200
                        }
            }
            /*
            Button {
                text: "Quit"
                width: window.width / 5
                height: window.height /15
                font.pixelSize: window.width / 55
                onClicked: { Qt.quit();}
            }*/


            /*
            Button {
                text: "Reboot"
                width: window.width / 5
                height: window.height /15
                font.pixelSize: window.width / 55
                onClicked: {Connect.reboot();}
            }*/

            Button {
                id: btnshutdown
                text: "Shutdown"
                font.family: "Eurostile"
                font.bold: true
                width: window.width / 10
                height: window.width / 10
                font.pixelSize: window.width / 70
                onClicked: {Connect.shutdown();}
                background: Rectangle {
                            //color: "red"
                            radius: window.width / 10
                            opacity: enabled ? 1 : 0.3
                            color: btnshutdown.down ? "darkred" : "red"
                            border.color: btnshutdown.down ? "red" : "darkred"
                            border.width: window.width / 200
                        }
            }


        }
        Grid {
            id :row2
            rows: 1
            columns: 2
            spacing: window.width /50
            anchors.top: row1.bottom
            anchors.topMargin: drawerpopup.height/30
            anchors.horizontalCenter: parent.horizontalCenter
            visible: Dashboard.screen
            Image {
                height: window.height /15
                width:height
                id: brightnessimage
                source: "qrc:/graphics/brightness.png"
            }
        Slider {
            id:brightness
            width: window.width / 3
            height: window.height /15
            //anchors.top: brightnestext.bottom
            //anchors.horizontalCenter: parent.horizontalCenter
            stepSize: 5
            from: 20
            to: 255
            value: Dashboard.Brightness
            onValueChanged: {
                     Connect.setSreenbrightness(brightness.value);
                     AppSettings.writebrightnessettings(brightness.value);
                     }
            //Component.onCompleted: Connect.setSreenbrightness(brightness.value);
        }
    }
    }
    PageIndicator {
        id: indicator
        count: dashView.count
        currentIndex: dashView.currentIndex
        anchors.bottom: dashView.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}

