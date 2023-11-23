import QtQuick 2.8
import QtQuick.Controls 2.1
import Qt.labs.settings 1.0
import "qrc:/Translator.js" as Translator

Rectangle {

    id: warningsettings
    anchors.fill: parent
    color: "black"
    property int gercalactive
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
                text: Translator.translate("WaterTemp", Dashboard.language)
                font.pixelSize: warningsettings.width / 55
                color: "white"
            }
            Text {
                text: Translator.translate("Boost", Dashboard.language)
                font.pixelSize: warningsettings.width / 55
                color: "white"
            }
            Text {
                text: Translator.translate("Revs", Dashboard.language)
                font.pixelSize: warningsettings.width / 55
                color: "white"
            }
            Text {
                text: Translator.translate("Knock", Dashboard.language)
                font.pixelSize: warningsettings.width / 55
                color: "white"
            }
            Text {
                text: Translator.translate("Lamdamultiply", Dashboard.language)
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
                onEditingFinished: applysettings.start()
            }
            TextField {
                id: boostwarn
                width: warningsettings.width / 10
                height: warningsettings.height / 15
                font.pixelSize: warningsettings.width / 55
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                text: "0.9"
                onEditingFinished: applysettings.start()
            }
            TextField {
                id: rpmwarn
                width: warningsettings.width / 10
                height: warningsettings.height / 15
                font.pixelSize: warningsettings.width / 55
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                text: "10000"
                onEditingFinished: applysettings.start()
            }
            TextField {
                id: knockwarn
                width: warningsettings.width / 10
                height: warningsettings.height / 15
                font.pixelSize: warningsettings.width / 55
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                text: "80"
                onEditingFinished: applysettings.start()
            }
            TextField {
                id: lambdamultiply
                width: warningsettings.width / 7
                height: warningsettings.height / 15
                font.pixelSize: warningsettings.width / 55
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                text: "14.7"
                onEditingFinished: applysettings.start()

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
                text: Translator.translate("GearCalculation", Dashboard.language)
                font.pixelSize: warningsettings.width / 55
                color: "white"
            }
            Text {
                text: Translator.translate("Gear", Dashboard.language)+" 1"
                font.pixelSize: warningsettings.width / 55
                color: "white"
            }
            Text {
                text: Translator.translate("Gear", Dashboard.language)+" 2"
                font.pixelSize: warningsettings.width / 55
                color: "white"
            }
            Text {
                text: Translator.translate("Gear", Dashboard.language)+" 3"
                font.pixelSize: warningsettings.width / 55
                color: "white"
            }
            Text {
                text: Translator.translate("Gear", Dashboard.language)+" 4"
                font.pixelSize: warningsettings.width / 55
                color: "white"
            }
            Text {
                text: Translator.translate("Gear", Dashboard.language)+" 5"
                font.pixelSize: warningsettings.width / 55
                color: "white"
            }
            Text {
                text: Translator.translate("Gear", Dashboard.language)+" 6"
                font.pixelSize: warningsettings.width / 55
                color: "white"
            }

            Switch {
                id: gearcalcselect
                width: warningsettings.width / 5
                height: warningsettings.height / 15
                font.pixelSize: warningsettings.width / 55
                Component.onCompleted: if (gearcalcselect.checked == true) {
                                           gercalactive = 1
                                           applysettings.start()
                                           switchtext.text = Translator.translate("GearCalculation", Dashboard.language) +" " +Translator.translate("ON", Dashboard.language)
                                       } else {
                                           gercalactive = 0
                                           applysettings.start()
                                           switchtext.text = Translator.translate("GearCalculation", Dashboard.language) + " " +Translator.translate("OFF", Dashboard.language)
                                       }

                onCheckedChanged: if (gearcalcselect.checked == true) {
                                      gercalactive = 1
                                      applysettings.start()
                                      switchtext.text = Translator.translate("GearCalculation", Dashboard.language) +" " +Translator.translate("ON", Dashboard.language)
                                  } else {
                                      gercalactive = 0
                                      applysettings.start()
                                      switchtext.text = Translator.translate("GearCalculation", Dashboard.language) + " " +Translator.translate("OFF", Dashboard.language)
                                  }
            }

            TextField {
                id: valgear1
                width: warningsettings.width / 10
                height: warningsettings.height / 15
                font.pixelSize: warningsettings.width / 55
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                text: "120"
                onEditingFinished: applysettings.start()
            }
            TextField {
                id: valgear2
                width: warningsettings.width / 10
                height: warningsettings.height / 15
                font.pixelSize: warningsettings.width / 55
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                text: "74"
                onEditingFinished: applysettings.start()
            }
            TextField {
                id: valgear3
                width: warningsettings.width / 10
                height: warningsettings.height / 15
                font.pixelSize: warningsettings.width / 55
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                text: "54"
                onEditingFinished: applysettings.start()
            }
            TextField {
                id: valgear4
                width: warningsettings.width / 10
                height: warningsettings.height / 15
                font.pixelSize: warningsettings.width / 55
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                text: "37"
                onEditingFinished: applysettings.start()
            }
            TextField {
                id: valgear5
                width: warningsettings.width / 10
                height: warningsettings.height / 15
                font.pixelSize: warningsettings.width / 55
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                text: "28"
                onEditingFinished: applysettings.start()

            }
            TextField {
                id: valgear6
                width: warningsettings.width / 10
                height: warningsettings.height / 15
                font.pixelSize: warningsettings.width / 55
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                text: ""
                onEditingFinished: applysettings.start()
                Component.onCompleted: applysettings.start()
            }
        }

    }
    Item {
        id: applysettings
        function start() {
            AppSettings.writeWarnGearSettings(watertempwarn.text,boostwarn.text,rpmwarn.text,knockwarn.text,gercalactive,lambdamultiply.text,valgear1.text,valgear2.text,valgear3.text,valgear4.text,valgear5.text,valgear6.text)
        }
    }
}
