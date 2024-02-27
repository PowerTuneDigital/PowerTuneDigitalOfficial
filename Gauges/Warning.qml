import QtQuick 2.8

Item {
    id: genwarning
   anchors.fill: parent
    property string warningtext : ""
    Rectangle {
        id: genwarningsquare
        anchors.centerIn: parent
        width: parent.width / 1.5
        height:parent.height / 1.5
        color:"red"
        SequentialAnimation on color {
            loops: Animation.Infinite
            ColorAnimation { from: "red"; to: "orange"; duration: 300 }
            ColorAnimation { from: "orange"; to: "red"; duration: 300 }
        }

        Text {
            id: warntxt
            text: "Warning!!!"
            font.pixelSize: parent.width / 13 //60
            anchors.top : parent.top
            anchors.topMargin: parent.height / 5
            anchors.horizontalCenter: genwarningsquare.horizontalCenter
            font.bold: true
            font.family: "Eurostile"
            color: "black"
        }

        Text {
            id : warningtxt
            text: warningtext
            font.pixelSize: parent.width / 20// 40
            anchors.top : warntxt.bottom
            anchors.topMargin: parent.height / 5
            anchors.horizontalCenter: genwarningsquare.horizontalCenter
            font.bold: true
            font.family: "Eurostile"
            color: "black"
        }
    }
}
