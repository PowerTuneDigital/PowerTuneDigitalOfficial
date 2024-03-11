import QtQuick 2.8
//import QtQuick 2.15
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.3
import com.powertune 1.0
import QtQuick.VirtualKeyboard 2.1
import "Translator.js" as Translator
import QtQuick.Window 2.10 //compatibility with QT 5.10
import Qt.labs.settings 1.0

ApplicationWindow {
    id:window
    visible: true
    //width: 1600
    //height: 720
    //width: Screen.desktopAvailableWidth
    //height: Screen.desktopAvailableHeight
    minimumWidth: 800
    minimumHeight: 480
    title: qsTr("PowerTune ") + Dashboard.Platform
    color: "black"

    Settings{
        id: appSettings
        property alias sampleActionEnabled: popUpLoader.enabled
    }

    Component.onCompleted: {
        //if ddcutil is true change all values to something
            popUpLoader.source = "qrc:/BrightnessPopUp.qml"
    }


    //Screen Keyboard do not change !!! Behaviour between QT5.10 and QT5.15 is different

    Rectangle {
        id: keyboardcontainer
        color: "blue"
        visible: false
        width: Screen.desktopAvailableWidth *0.63
        height: Screen.desktopAvailableHeight *0.5
        z: Screen.desktopAvailableHeight *0.5


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
        onCurrentIndexChanged: {
            if (dashView.currentIndex != 0){
                console.log("Object Closed")
            }
        }

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
    // For future use
    ExBoardAnalog{
        id:custom
        visible:false
    }

    Item {
        id: mysettings

        Text
        {
            text: custom.getRpmCheckboxSaveValue()
        }
        visible:false

    }
    Button {
        id: btnfinaliseupdate
        visible: false

       text: custom.getRpmCheckboxSaveValue()
        width: window.width / 1.5
        height: window.height / 1.5
        font.pixelSize: window.width / 20
        anchors.centerIn: parent

        onClicked: {
          //  console.log("apply Fixes")
            btnfinaliseupdate.text = "Please wait for reboot..."
        }
    }

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
            columns: 3
            topPadding: window.width / 40
            spacing: window.width / 4
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



            Switch {
                id: disablePopUp
                text:  "On"
                font.family: "Eurostile"
                font.bold: true
                rightPadding: 23
                width: window.width / 10
                height: window.width / 10
                font.pixelSize: window.width / 70
                Component.onCompleted: {
                    if(popUpLoader.enabled){
                        disablePopUp.text = "On"
                    }else{
                       disablePopUp.text = "Off"
                    }
                }
                onPositionChanged: {
                    popUpLoader.enabled = !popUpLoader.enabled;
                    appSettings.sampleActionEnabled = popUpLoader.enabled //setValue
                    popUpLoader.visible = false
                    if(popUpLoader.enabled){
                        disablePopUp.text = "On"
                        console.log("Pop Up Enabled")
                    }else{
                       disablePopUp.text = "Off"
                        console.log("Pop Up Disabled")
                    }
                }
                contentItem: Text {
                    leftPadding: disablePopUp.indicator.width + disablePopUp.spacing
                    text: disablePopUp.text
                    font: disablePopUp.font
                    opacity: enabled ? 1.0 : 0.3
                    //color: disablePopUp.down ? "#17a81a" : "#21be2b"
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
                Rectangle {
                    width: window.width / 5
                    height: window.width / 10
                    color: "transparent"
                    anchors.right: disablePopUp.left
                    Text {
                        text: "Brightness Pop Up at Boot"
                        anchors.centerIn: parent
                        color: "black"
                        font.family: "Eurostile"
                        font.bold: true
                        font.pixelSize: window.width / 70
                    }
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
            from: 0
            to: 100
            value: Dashboard.Brightness

            onValueChanged: {
                     Connect.setSreenbrightness(brightness.value);
                     AppSettings.writebrightnessettings(brightness.value);
                     }
            // Conditional assignment of 'from' and 'to' properties
            Component.onCompleted: {
                // Check if HAVE_DDCUTIL is defined
                if (Qt.platform.os === "linux" && HAVE_DDCUTIL) {
                    from = 0;  // Adjust based on your requirements
                    to = 100;  // Adjust based on your requirements
                } else {
                    from = 20;  // Default values if HAVE_DDCUTIL is not defined
                    to = 255;  // Default values if HAVE_DDCUTIL is not defined
                }
            }
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
    Loader {
        id: popUpLoader
        visible: false
        enabled: appSettings.sampleActionEnabled
        anchors.right: parent.right
        width: window.width * 0.15
        //anchors.verticalCenter: parent.verticalCenter
        Component.onCompleted: {
            if(popUpLoader.enabled){
                visible = true
            }

            console.log("Brightness Loaded")
        }
    }
}
