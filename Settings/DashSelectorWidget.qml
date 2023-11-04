import QtQuick 2.7
import QtQuick.Controls 2.1

Grid {
    anchors.top: parent.top
    anchors.margins: dashselector.width / 60
    rows: 2
    columns: 1

    property alias currentIndex: cbox.currentIndex
    property int index
    property var linkedLoader

    Text {
        text: "Dash " + index
        visible: Dashboard.Visibledashes >= index
        font.pixelSize: dashselector.width / 55
    }

    ComboBox {
        id: cbox
        width: dashselector.width / 5
        height: dashselector.height / 15
        font.pixelSize: dashselector.width / 55
        model: ["Main Dash", "GPS", "Laptimer", "PowerFC Sensors", "User Dash 1", "User Dash 2", "User Dash 3", "G-Force", "Mediaplayer", "Screen Toggle", "Drag Timer","CAN monitor"]
        visible: Dashboard.Visibledashes >= index
        onCurrentIndexChanged: {
            if (visible == true) {
                linkedLoader.source = dashselector.getDashByIndex(currentIndex)
            }
        }
        onVisibleChanged: {
            if (visible == true) {
                linkedLoader.source = dashselector.getDashByIndex(currentIndex)
            }
        }
        delegate: ItemDelegate {
            width: cbox.width
            text: cbox.textRole ? (Array.isArray(
                                       control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
            font.weight: cbox.currentIndex == index ? Font.DemiBold : Font.Normal
            font.family: cbox.font.family
            font.pixelSize: cbox.font.pixelSize
            highlighted: cbox.highlightedIndex == index
            hoverEnabled: cbox.hoverEnabled
        }
    }
}
