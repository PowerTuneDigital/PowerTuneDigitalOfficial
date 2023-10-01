import QtQuick 2.8
import QtQuick.Controls 2.1

Rectangle {
    visible: true
    width: parent.width
    height: parent.height


    ListView {
        id: listView
        width: parent.width /2
        height: parent.height

        model: ListModel {
            ListElement { canId: "0x123"; payload: "00 11 22 33 44 55 66 77" }
            ListElement { canId: "0x456"; payload: "88 99 AA BB CC DD EE FF" }
            ListElement { canId: "0x124"; payload: "00 11 22 33 44 55 66 77" }
            ListElement { canId: "0x455"; payload: "88 99 AA BB CC DD EE FF" }
            // Add more ListElements for each CAN ID you want to display
        }

        delegate: Item {
            width: parent.width
            height: 30

            Text {
                text: "CAN ID: " + model.canId
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                font.bold: true
            }

            Text {
                text: model.payload
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                font.pixelSize: 14
            }
        }
    }

    Connections {
        target: extenderObject
        onNewCanFrameReceived: {
            console.log("new frame received")
            // Handle the new CAN frame received
            for (var i = 0; i < listView.model.count; ++i) {
                if (listView.model.get(i).canId === canId) {
                    listView.model.setProperty(i, "payload", payload)
                    break;
                }
            }
        }
    }
}

