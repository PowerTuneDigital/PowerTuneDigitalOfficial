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

    //width: 800
    //height: 480
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    minimumWidth: 800
    minimumHeight: 480
    title: qsTr("PowerTune ") + Dashboard.Platform
    color: "black"

    property int brightnessIncrease: 175
    property int ddcUtilBrightnessIncrease: 50

    property int digitalInput1: Dashboard.EXDigitalInput1
    property int digitalInput2: Dashboard.EXDigitalInput2
    property int digitalInput3: Dashboard.EXDigitalInput3
    property int digitalInput4: Dashboard.EXDigitalInput4
    property int digitalInput5: Dashboard.EXDigitalInput5
    property int digitalInput6: Dashboard.EXDigitalInput6
    property int digitalInput7: Dashboard.EXDigitalInput7
    property int digitalInput8: Dashboard.EXDigitalInput8

    //Screen Keyboard do not change !!! Behaviour between QT5.10 and QT5.15 is different


    Settings{
        id: appSettings
        property alias sampleActionEnabled: popUpLoader.enabled

    }

    Component.onCompleted: {
        //console.log("ExBoard digiValue: " + custom.digiValue)
        popUpLoader.source = "qrc:/BrightnessPopUp.qml"
        custom.executeOnBootAction()
        console.log("Max Brightness on Boot Value Check: " + custom.maxBrightnessOnBoot)
        if(Qt.platform.os === "linux" && HAVE_DDCUTIL){
            ddcutilDigitalLoop()
        }else{
            digitalLoop()
        }
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

            btnfinaliseupdate.text = "Please wait for reboot..."
        }
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
            rows: 2
            columns: 1
            topPadding: window.width / 40
            spacing: window.width / 30
            anchors.top: drawerpopup.top
            anchors.left:parent.left
            Button {
                id: btntripreset
                text: "Trip Reset"
                font.family: "Eurostile"
                font.bold: true
                width: window.width / 13
                height: window.width / 13
                font.pixelSize: window.width / 100
                Component.onCompleted: {
                    if(window.width == 800){
                        btntripreset.width = window.width / 10
                        btntripreset.height = window.width / 10
                        btntripreset.font.pixelSize = window.width / 70

                    }
                }
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
                width: window.width / 13
                height: window.width / 13
                font.pixelSize: window.width / 100
                Component.onCompleted: {
                    if(window.width == 800){
                        btnshutdown.width = window.width / 10
                        btnshutdown.height = window.width / 10
                        btnshutdown.font.pixelSize = window.width / 70
                    }
                }

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
             topPadding: 40
             anchors.top: row3.bottom
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
             stepSize: 5
             topPadding: 10
             from: 20
             to: 255
             value: Dashboard.Brightness

             onValueChanged: {
                      console.log("Slider Value Changed: " + brightness.value + " Dashboard Brightness: " + Dashboard.Brightness)
                      Connect.setSreenbrightness(brightness.value);
                      AppSettings.writebrightnessettings(brightness.value);
                      }
             // Conditional assignment of 'from' and 'to' properties
             Component.onCompleted: {
                 if(window.width > 800){
                     row2.visible = false
                     brightness.visible = false
                 }

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

         Grid{
             id :row4
             rows: 2
             columns: 1
             topPadding: window.width / 40
             spacing: window.width / 30
             anchors.top: drawerpopup.top
             anchors.right: parent.right
             Row{
                 Button {
                     id: plusBrightness
                     font.family: "Eurostile"
                     font.bold: true
                     width: window.width / 13
                     height: window.width / 13
                     font.pixelSize: window.width / 30
                     Component.onCompleted: {
                         if(window.width == 800){
                             plusBrightness.width = window.width / 10
                             plusBrightness.height = window.width / 10
                         }
                     }
                     onClicked: {
                         if (Qt.platform.os === "linux" && HAVE_DDCUTIL) {
                             ddcUtilBrightnessIncrease += 25;  // increase by 10% every time button is pressed
                             if(ddcUtilBrightnessIncrease > 75){ //if the variable goes above 100 bring it back down
                                 ddcUtilBrightnessIncrease = 75
                             }

                             Connect.setSreenbrightness(ddcUtilBrightnessIncrease); // set the brightness with the new value
                             AppSettings.writebrightnessettings(ddcUtilBrightnessIncrease);
                         }else{
                             brightnessIncrease += 50
                             if(brightnessIncrease > 250){ //if the variable goes above 250 bring it back down
                                 brightnessIncrease = 250
                             }

                             Connect.setSreenbrightness(brightnessIncrease); // set the brightness with the new value
                             AppSettings.writebrightnessettings(brightnessIncrease);
                         }
                     }
                     background: Rectangle {
                                 //color: "red"
                                 radius: window.width / 10
                                 opacity: enabled ? 1 : 0.3
                                 color: plusBrightness.down ? "darkgrey" : "grey"
                                 border.color: plusBrightness.down ? "grey" : "darkgrey"
                                 border.width: window.width / 200
                             }
                     Image{
                         source: "qrc:/graphics/brightnessIncrease.png"
                         //anchors.fill: plusBrightness
                         width: plusBrightness.width
                         height: plusBrightness.height
                         anchors.centerIn: plusBrightness.horizontalCenter
                         }
                     }
                 }

             Row{
                 Button {
                     id: minusBrightness
                     font.family: "Eurostile"
                     font.bold: true
                     width: window.width / 13
                     height: window.width / 13
                     font.pixelSize: window.width / 30
                     Component.onCompleted: {
                         if(window.width == 800){
                             minusBrightness.width = window.width / 10
                             minusBrightness.height = window.width / 10
                         }
                     }

                     onClicked: {
                         if (Qt.platform.os === "linux" && HAVE_DDCUTIL) {
                             ddcUtilBrightnessIncrease -= 25;  // increase by 10% every time button is pressed
                             if(ddcUtilBrightnessIncrease < 0){ //if the variable goes above 100 bring it back down
                                 ddcUtilBrightnessIncrease = 0
                             }

                             Connect.setSreenbrightness(ddcUtilBrightnessIncrease); // set the brightness with the new value
                             AppSettings.writebrightnessettings(ddcUtilBrightnessIncrease);
                         }else{
                             brightnessIncrease -= 50
                             if(brightnessIncrease < 25){ //if the variable goes above 250 bring it back down
                                 brightnessIncrease = 25
                             }

                             Connect.setSreenbrightness(brightnessIncrease); // set the brightness with the new value
                             AppSettings.writebrightnessettings(brightnessIncrease);
                         }
                     }
                     background: Rectangle {
                         radius: window.width / 10
                         opacity: enabled ? 1 : 0.3
                         color: minusBrightness.down ? "darkgrey" : "grey"
                         border.color: minusBrightness.down ? "grey" : "darkgrey"
                         border.width: window.width / 200
                         }
                     Image{
                         source: "qrc:/graphics/brightnessDecrease.png"
                         //anchors.fill: plusBrightness
                         width: minusBrightness.width
                         height: minusBrightness.height
                         anchors.centerIn: minusBrightness.horizontalCenter
                         }
                     }
                 }
             }

        Grid{
            id:row3
            columns: 1
            spacing: window.width /160
            anchors.top: drawerpopup.top
            //anchors.right: drawerpopup.right
            anchors.topMargin: drawerpopup.height/30
            anchors.horizontalCenter: parent.horizontalCenter

            Row{

                Rectangle {
                    id: switchRectangle
                    width: window.width / 4
                    height: window.width / 10
                    color: "transparent"
                    Text {
                        id: switchText
                        leftPadding: 70
                        text: "Brightness Pop Up at Boot"
                        anchors.centerIn: parent
                        color: "black"
                        font.family: "Eurostile"
                        font.bold: true
                        font.pixelSize: window.width / 70
                        Component.onCompleted: {
                            if(window.width == 800){
                                switchText.font.pixelSize = 15
                                switchRectangle.width = window.width / 2.8
                            }
                        }
                    }
                }

                Switch {
                    id: disablePopUp
                    text:  "On"
                    //leftPadding: 40
                    font.family: "Eurostile"
                    font.bold: true
                    width: window.width / 7
                    height: window.width / 10
                    font.pixelSize: window.width / 70
                    //align.left: switchText.rightMargin
                    Component.onCompleted: {
                        if(window.width == 800){
                            disablePopUp.font.pixelSize = 15
                            //disablePopUp.leftPadding = 70
                        }

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

    //Check if any of the EXDigitalInput values have changed and if so run the function.
    onDigitalInput1Changed: {
        console.log("Digital Input 1 Channel Changed" + digitalInput1)
        if(Qt.platform.os === "linux" && HAVE_DDCUTIL){
            ddcutilDigitalLoop()
        }else{
            digitalLoop()
        }
    }

    onDigitalInput2Changed: {
        console.log("Digital Input 2 Channel Changed" + digitalInput2)
        if(Qt.platform.os === "linux" && HAVE_DDCUTIL){
            ddcutilDigitalLoop()
        }else{
            digitalLoop()
        }
    }

    onDigitalInput3Changed: {
        console.log("Digital Input 3 Channel Changed" + digitalInput3)
        if(Qt.platform.os === "linux" && HAVE_DDCUTIL){
            ddcutilDigitalLoop()
        }else{
            digitalLoop()
        }
    }

    onDigitalInput4Changed: {
        console.log("Digital Input 4 Channel Changed" + digitalInput4)
        if(Qt.platform.os === "linux" && HAVE_DDCUTIL){
            ddcutilDigitalLoop()
        }else{
            digitalLoop()
        }
    }

    onDigitalInput5Changed: {
        console.log("Digital Input 5 Channel Changed" + digitalInput5)
        if(Qt.platform.os === "linux" && HAVE_DDCUTIL){
            ddcutilDigitalLoop()
        }else{
            digitalLoop()
        }
    }

    onDigitalInput6Changed: {
        console.log("Digital Input 6 Channel Changed" + digitalInput6)
        if(Qt.platform.os === "linux" && HAVE_DDCUTIL){
            ddcutilDigitalLoop()
        }else{
            digitalLoop()
        }
    }

    onDigitalInput7Changed: {
        console.log("Digital Input 7 Channel Changed" + digitalInput7)
        if(Qt.platform.os === "linux" && HAVE_DDCUTIL){
            ddcutilDigitalLoop()
        }else{
            digitalLoop()
        }
    }

    onDigitalInput8Changed: {
        console.log("Digital Input 8 Channel Changed" + digitalInput8)
        if(Qt.platform.os === "linux" && HAVE_DDCUTIL){
            ddcutilDigitalLoop()
        }else{
            digitalLoop()
        }
    }

    Timer {
      interval: 1200
      running: true
      onTriggered: {
            if(custom.maxBrightnessOnBoot == 1){
                console.log("Timer for Max Brightness started")
                if (Qt.platform.os === "linux" && HAVE_DDCUTIL) {
                  console.log("Max Brightness on Boot Run" + custom.maxBrightnessOnBoot)
                  Connect.setSreenbrightness(250);
                  AppSettings.writebrightnessettings(250);
                } else {
                  console.log("DDCUTIL Failed max brightness run without ddc " + custom.maxBrightnessOnBoot)
                  Connect.setSreenbrightness(250);
                  AppSettings.writebrightnessettings(250);
                }
            }
        }
    }

    //Function to check if the digital value matches the item in the combobox and then checking if the EXDigitalInput is equal to 1 to see if there is power to the digital inputs
    function digitalLoop(){
            if (0 === custom.digiValue && digitalInput1 == 1 && custom.maxBrightnessOnBoot == 1) {
                Connect.setSreenbrightness(20);
                AppSettings.writebrightnessettings(20);
                console.log("Brightness Set to 20 1")
                console.log(digiValue)
                return;
            }else if(1 === custom.digiValue && digitalInput2 == 1 && custom.maxBrightnessOnBoot == 1){
                Connect.setSreenbrightness(20);
                AppSettings.writebrightnessettings(20);
                console.log("Brightness Set to 20 2")
                console.log(digiValue)
                return;
            }else if(2 === custom.digiValue && digitalInput3 == 1 && custom.maxBrightnessOnBoot == 1){
                Connect.setSreenbrightness(20);
                AppSettings.writebrightnessettings(20);
                console.log("Brightness Set to 20 3")
                console.log(digiValue)
                return;

            }else if(3 === custom.digiValue && digitalInput4 == 1 && custom.maxBrightnessOnBoot == 1){
                Connect.setSreenbrightness(20);
                AppSettings.writebrightnessettings(20);
                console.log("Brightness Set to 20 4")
                console.log(digiValue)
                return;

            }else if(4 === custom.digiValue && digitalInput5 == 1 && custom.maxBrightnessOnBoot == 1){
                Connect.setSreenbrightness(20);
                AppSettings.writebrightnessettings(20);
                console.log("Brightness Changed to 20 5")
                return;

            }else if(5 === custom.digiValue && digitalInput6 == 1 && custom.maxBrightnessOnBoot == 1){
                Connect.setSreenbrightness(20);
                AppSettings.writebrightnessettings(20);
                console.log("Brightness Changed to 20 6")
                return;

            }else if(6 === custom.digiValue && digitalInput7 == 1 && custom.maxBrightnessOnBoot == 1){
                Connect.setSreenbrightness(20);
                AppSettings.writebrightnessettings(20);
                console.log("Brightness Changed to 20 7")
                return;

            }else if(7 === custom.digiValue && digitalInput8 == 1 && custom.maxBrightnessOnBoot == 1){
                Connect.setSreenbrightness(20);
                AppSettings.writebrightnessettings(20);
                console.log("Brightness Changed to 20 8")
                return;
            }else{
                console.log("No if Statements Passed")
            }
        }

    function ddcutilDigitalLoop(){
            if (0 === custom.digiValue && digitalInput1 == 1 && custom.maxBrightnessOnBoot == 1) {
                Connect.setSreenbrightness(0);
                AppSettings.writebrightnessettings(0);
                console.log("Brightness Set to 0 1")
                console.log(digiValue)
                return;
            }else if(1 === custom.digiValue && digitalInput2 == 1 && custom.maxBrightnessOnBoot == 1){
                Connect.setSreenbrightness(0);
                AppSettings.writebrightnessettings(0);
                console.log("Brightness Set to 0 2")
                console.log(digiValue)
                return;
            }else if(2 === custom.digiValue && digitalInput3 == 1 && custom.maxBrightnessOnBoot == 1){
                Connect.setSreenbrightness(0);
                AppSettings.writebrightnessettings(0);
                console.log("Brightness Set to 0 3")
                console.log(digiValue)
                return;

            }else if(3 === custom.digiValue && digitalInput4 == 1 && custom.maxBrightnessOnBoot == 1){
                Connect.setSreenbrightness(0);
                AppSettings.writebrightnessettings(0);
                console.log("Brightness Set to 0 4")
                console.log(digiValue)
                return;

            }else if(4 === custom.digiValue && digitalInput5 == 1 && custom.maxBrightnessOnBoot == 1){
                Connect.setSreenbrightness(0);
                AppSettings.writebrightnessettings(0);
                console.log("Brightness Changed to 0 5")
                return;

            }else if(5 === custom.digiValue && digitalInput6 == 1 && custom.maxBrightnessOnBoot == 1){
                Connect.setSreenbrightness(0);
                AppSettings.writebrightnessettings(0);
                console.log("Brightness Changed to 0 6")
                return;

            }else if(6 === custom.digiValue && digitalInput7 == 1 && custom.maxBrightnessOnBoot == 1){
                Connect.setSreenbrightness(0);
                AppSettings.writebrightnessettings(0);
                console.log("Brightness Changed to 0 7")
                return;

            }else if(7 === custom.digiValue && digitalInput8 == 1 && custom.maxBrightnessOnBoot == 1){
                Connect.setSreenbrightness(0);
                AppSettings.writebrightnessettings(0);
                console.log("Brightness Changed to 0 8")
                return;
            }
        }
    }


