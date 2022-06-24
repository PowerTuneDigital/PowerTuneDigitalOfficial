import QtQuick 2.8
import QtQuick.Controls 2.1
import Qt.labs.settings 1.0

Rectangle {
    anchors.fill: parent
    color: "grey"


     Grid {
        anchors.top: parent.top
        anchors.topMargin: parent.height / 20
        rows: 2
        columns: 2
        Text {
            text: " V 1.97 " + Dashboard.Platform
            color: "white"
            font.pixelSize: windowbackround.width / 55
        }

        }
}