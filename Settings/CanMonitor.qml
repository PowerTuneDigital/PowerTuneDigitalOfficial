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

        }

        delegate: Item {
            width: parent.width
            height: 30

            Text {
                text: "CAN ID: " + model.canId
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                font.bold: true
                font.pixelSize: 14
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
        target: Dashboard
        onCanChanged: {
            var canId = Dashboard.can[0];
            var payload = Dashboard.can[1];
            var itemFound = false;

            // Check if the canId is already in the ListView
            for (var i = 0; i < listView.model.count; ++i) {
                if (listView.model.get(i).canId === canId) {
                    listView.model.setProperty(i, "payload", payload);
                    itemFound = true;
                    break;
                }
            }

            // If the item is not found, add it to the ListView
            if (!itemFound) {
                var newItem = {
                    "canId": canId,
                    "payload": payload
                };
                listView.model.append(newItem);
            }
        }

    }
}

