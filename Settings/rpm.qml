import QtQuick 2.8
import QtQuick.Controls 2.1
import Qt.labs.settings 1.0

Rectangle {
    id: rpmSettings
    anchors.fill: parent
    color: "grey"

    Item {
        Settings {
            property alias maxrpm: maxRPM.text
            property alias shift1: stage1.text
            property alias shift2: stage2.text
            property alias shift3: stage3.text
            property alias shift4: stage4.text
        }
    }

    Grid {

        rows: 2
        columns: 5
        spacing: 5
        Text {
            text: "MAX RPM"
            font.pixelSize: rpmSettings.width / 55
            color: "white"
        }
        Text {
            text: "Shift Light 1 (g)"
            font.pixelSize: rpmSettings.width / 55
            color: "white"
        }
        Text {
            text: "Shift Light 2 (g)"
            font.pixelSize: rpmSettings.width / 55
            color: "white"
        }
        Text {
            text: "Shift Light 3 (y)"
            font.pixelSize: rpmSettings.width / 55
            color: "white"
        }
        Text {
            text: "Shift Light 4 (r)"
            font.pixelSize: rpmSettings.width / 55
            color: "white"
        }
        TextField {
            id: maxRPM
            width: rpmSettings.width / 5.5
            height: rpmSettings.height / 15
            font.pixelSize: rpmSettings.width / 55
            text: "10000"
            inputMethodHints: Qt.ImhFormattedNumbersOnly // this ensures valid inputs are number only
            onEditingFinished: applysettings.start() //Dashboard.setmaxRPM(maxRPM.text)

        }
        TextField {
            id: stage1
            width: rpmSettings.width / 5.5
            height: rpmSettings.height / 15
            font.pixelSize: rpmSettings.width / 55
            text: "3000"
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            onEditingFinished: applysettings.start() //Dashboard.setrpmStage1(stage1.text)
            //Component.onCompleted: Dashboard.setrpmStage1(stage1.text)
        }
        TextField {
            id: stage2
            width: rpmSettings.width / 5.5
            height: rpmSettings.height / 15
            font.pixelSize: rpmSettings.width / 55
            text: "5500"
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            onEditingFinished: applysettings.start() //Dashboard.setrpmStage2(stage2.text)
            //Component.onCompleted: Dashboard.setrpmStage2(stage2.text)
        }
        TextField {
            id: stage3
            width: rpmSettings.width / 5.5
            height: rpmSettings.height / 15
            font.pixelSize: rpmSettings.width / 55
            text: "5500"
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            onEditingFinished: applysettings.start() //Dashboard.setrpmStage3(stage3.text)
            //Component.onCompleted: applysettings.start() //Dashboard.setrpmStage3(stage3.text)
        }
        TextField {
            id: stage4
            width: rpmSettings.width / 5.5
            height: rpmSettings.height / 15
            font.pixelSize: rpmSettings.width / 55
            text: "7500"
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            onEditingFinished: applysettings.start() //Dashboard.setrpmStage4(stage4.text)
            //Component.onCompleted: Dashboard.setrpmStage4(stage4.text),tabView.currentIndex++
        }
        Item {
            //Function to automatically change can speeds
            id: applysettings
            function start() {
                AppSettings.writeRPMSettings(maxRPM.text,stage1.text,stage2.text,stage3.text,stage4.text)
            }
        }
    }
}
