import QtQuick 2.8
import QtQuick.Controls 2.1
import Qt.labs.settings 1.0

Rectangle {
    id: calcs
    anchors.fill: parent
    color: "grey"

    Item {
        id: speedcorretionsettings
        Settings {
            property alias speedpercentsetting: speedpercent.text
        }
    }
    Grid {
        rows: 2
        columns: 1
        id: grid
        spacing: calcs.height / 150
        Text {
            text: "Speed Correction %"
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
    }
}
