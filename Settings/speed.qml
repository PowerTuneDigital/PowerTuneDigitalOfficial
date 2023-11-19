import QtQuick 2.8
import QtQuick.Controls 2.1
import Qt.labs.settings 1.0
import "qrc:/Translator.js" as Translator

Rectangle {
    id: calcs
    anchors.fill: parent
    color: "grey"

    Item {
        id: speedcorretionsettings
        Settings {
            property alias speedpercentsetting: speedpercent.text
            property alias pulsespermilesetting: pulsespermile.text
        }
    }
    Grid {
        rows: 4
        columns: 2
        id: grid
        spacing: calcs.height / 150
        Text {
            text: Translator.translate("SpeedCorrection", Dashboard.Language)
            font.pixelSize: calcs.width / 55
            color: "white"
        }
        TextField {
            id: speedpercent
            width: calcs.width / 5
            height: calcs.height / 15
            font.pixelSize: calcs.width / 55
            text: "100"
            inputMethodHints: Qt.ImhFormattedNumbersOnly // this ensures valid inputs are number only
            Component.onCompleted: {
                AppSettings.writeSpeedSettings(speedpercent.text / 100)
            }
            onEditingFinished: AppSettings.writeSpeedSettings(
                                   speedpercent.text / 100)
        }
        Text {
            text: "Pulses Per Mile"
            font.pixelSize: calcs.width / 55
            color: "white"
        }
        TextField {
            id: pulsespermile
            width: calcs.width / 5
            height: calcs.height / 15
            font.pixelSize: calcs.width / 55
            text: "100000"
            inputMethodHints: Qt.ImhFormattedNumbersOnly // this ensures valid inputs are number only
            Component.onCompleted: {
                AppSettings.writeSpeedSettings(speedpercent.text / 100, pulsespermile.text)
            }
            onEditingFinished: AppSettings.writeSpeedSettings(
                                   speedpercent.text / 100, pulsespermile.text)
        }
    }

}
