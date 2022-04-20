import QtQuick 2.8
import QtQuick.Controls 2.1
import Qt.labs.settings 1.0

Rectangle {

    id: warningsettings
    anchors.fill: parent
    color: "black"

    Item {
        id: warnettings
        Settings {
            property alias watertempwarning: watertempwarn.text
            property alias boostwarning: boostwarn.text
            property alias rpmwarning: rpmwarn.text
            property alias knockwarning: knockwarn.text
            property alias lambdamultiplier: lambdamultiply.text
            property alias gearcalcselectswitch: gearcalcselect.checked
            property alias gearval1: valgear1.text
            property alias gearval2: valgear2.text
            property alias gearval3: valgear3.text
            property alias gearval4: valgear4.text
            property alias gearval5: valgear5.text
            property alias gearval6: valgear6.text
        }

        Grid {
            id: speedcorrgrid
            rows: 3
            columns: 5
            spacing: warningsettings.height / 150
            Text {
                text: "WaterTemp"
                font.pixelSize: warningsettings.width / 55
                color: "white"
            }
            Text {
                text: "Boost"
                font.pixelSize: warningsettings.width / 55
                color: "white"
            }
            Text {
                text: "Revs"
                font.pixelSize: warningsettings.width / 55
                color: "white"
            }
            Text {
                text: "Knock"
                font.pixelSize: warningsettings.width / 55
                color: "white"
            }
            Text {
                text: "Lamda multiply"
                font.pixelSize: warningsettings.width / 55
                color: "white"
            }
            TextField {
                id: watertempwarn
                width: warningsettings.width / 10
                height: warningsettings.height / 15
                font.pixelSize: warningsettings.width / 55
                text: "110"
                inputMethodHints: Qt.ImhFormattedNumbersOnly // this ensures valid inputs are number only
                onEditingFinished: Dashboard.setwaterwarn(watertempwarn.text)
                Component.onCompleted: Dashboard.setwaterwarn(watertempwarn.text)
            }
            TextField {
                id: boostwarn
                width: warningsettings.width / 10
                height: warningsettings.height / 15
                font.pixelSize: warningsettings.width / 55
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                text: "0.9"
                onEditingFinished: Dashboard.setboostwarn(boostwarn.text)
                Component.onCompleted: Dashboard.setboostwarn(boostwarn.text)
            }
            TextField {
                id: rpmwarn
                width: warningsettings.width / 10
                height: warningsettings.height / 15
                font.pixelSize: warningsettings.width / 55
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                text: "10000"
                onEditingFinished: Dashboard.setrpmwarn(rpmwarn.text)
                Component.onCompleted: Dashboard.setrpmwarn(rpmwarn.text)
            }
            TextField {
                id: knockwarn
                width: warningsettings.width / 10
                height: warningsettings.height / 15
                font.pixelSize: warningsettings.width / 55
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                text: "80"
                onEditingFinished: Dashboard.setknockwarn(knockwarn.text)
            }
            TextField {
                id: lambdamultiply
                width: warningsettings.width / 7
                height: warningsettings.height / 15
                font.pixelSize: warningsettings.width / 55
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                text: "14.7"
                onEditingFinished: Dashboard.setLambdamultiply(lambdamultiply.text)
                Component.onCompleted: {
                    Dashboard.setLambdamultiply(lambdamultiply.text)
                    tabView.currentIndex = 4 // opens the 5th tab
                }
            }
        }
    }
    Rectangle {
        id: gearsettings
        width: parent.width
        height: parent.height / 2
        y: parent.height / 5
        color: "transparent"
        Grid {
            id: geargrid
            rows: 3
            columns: 7
            spacing: warningsettings.height / 150

            Text {
                id: switchtext
                text: "Gear Calc"
                font.pixelSize: warningsettings.width / 55
                color: "white"
            }
            Text {
                text: "Gear1"
                font.pixelSize: warningsettings.width / 55
                color: "white"
            }
            Text {
                text: "Gear2"
                font.pixelSize: warningsettings.width / 55
                color: "white"
            }
            Text {
                text: "Gear3"
                font.pixelSize: warningsettings.width / 55
                color: "white"
            }
            Text {
                text: "Gear4"
                font.pixelSize: warningsettings.width / 55
                color: "white"
            }
            Text {
                text: "Gear5"
                font.pixelSize: warningsettings.width / 55
                color: "white"
            }
            Text {
                text: "Gear6"
                font.pixelSize: warningsettings.width / 55
                color: "white"
            }

            Switch {
                id: gearcalcselect
                width: warningsettings.width / 5
                height: warningsettings.height / 15
                font.pixelSize: warningsettings.width / 55
                Component.onCompleted: if (gearcalcselect.checked == true) {
                                           Dashboard.setgearcalcactivation(1)
                                           switchtext.text = "Gear Calulation ON"
                                       } else {
                                           Dashboard.setgearcalcactivation(0)
                                           switchtext.text = "Gear Calulation OFF"
                                       }
                onCheckedChanged: if (gearcalcselect.checked == true) {
                                      Dashboard.setgearcalcactivation(1)
                                      switchtext.text = "Gear Calulation ON"
                                  } else {
                                      Dashboard.setgearcalcactivation(0)
                                      switchtext.text = "Gear Calulation OFF"
                                  }
            }

            TextField {
                id: valgear1
                width: warningsettings.width / 10
                height: warningsettings.height / 15
                font.pixelSize: warningsettings.width / 55
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                text: "120"
                onEditingFinished: Dashboard.setgearcalc1(valgear1.text)
                Component.onCompleted: Dashboard.setgearcalc1(valgear1.text)
            }
            TextField {
                id: valgear2
                width: warningsettings.width / 10
                height: warningsettings.height / 15
                font.pixelSize: warningsettings.width / 55
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                text: "74"
                onEditingFinished: Dashboard.setgearcalc2(valgear2.text)
                Component.onCompleted: Dashboard.setgearcalc2(valgear2.text)
            }
            TextField {
                id: valgear3
                width: warningsettings.width / 10
                height: warningsettings.height / 15
                font.pixelSize: warningsettings.width / 55
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                text: "54"
                onEditingFinished: Dashboard.setgearcalc3(valgear3.text)
                Component.onCompleted: Dashboard.setgearcalc3(valgear3.text)
            }
            TextField {
                id: valgear4
                width: warningsettings.width / 10
                height: warningsettings.height / 15
                font.pixelSize: warningsettings.width / 55
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                text: "37"
                onEditingFinished: Dashboard.setgearcalc4(valgear4.text)
                Component.onCompleted: Dashboard.setgearcalc4(valgear4.text)
            }
            TextField {
                id: valgear5
                width: warningsettings.width / 10
                height: warningsettings.height / 15
                font.pixelSize: warningsettings.width / 55
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                text: "28"
                onEditingFinished: Dashboard.setgearcalc5(valgear5.text)
                Component.onCompleted: Dashboard.setgearcalc5(valgear5.text)
            }
            TextField {
                id: valgear6
                width: warningsettings.width / 10
                height: warningsettings.height / 15
                font.pixelSize: warningsettings.width / 55
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                text: ""
                onEditingFinished: Dashboard.setgearcalc6(valgear6.text)
                Component.onCompleted: Dashboard.setgearcalc6(valgear6.text)
            }
        }
    }
}
