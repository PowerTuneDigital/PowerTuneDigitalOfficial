import QtQuick 2.8

// Padlock icon for the drawer's "Lock Dash Edit" toggle - ported from the
// Qt6 app (main.qml's inline LockIcon component there). Kept as its own
// file here rather than Qt6's `component LockIcon: Item {...}` inline
// syntax, since that requires Qt 5.15+ and this project doesn't use it
// anywhere else.
Item {
    id: lockIcon
    property bool locked: true
    property color strokeColor: "white"

    // A tall capsule (rounded top+bottom, straight sides) stroked as a
    // ring, mostly hidden behind the body below - only its rounded cap
    // pokes out above the body, reading as a shackle instead of a full
    // circle (which read as a head-and-shoulders avatar, not a lock).
    Rectangle {
        id: shackle
        width: parent.width * 0.42
        height: parent.width * 0.6
        radius: width / 2
        color: "transparent"
        border.width: Math.max(2, parent.width * 0.14)
        border.color: lockIcon.strokeColor
        anchors.horizontalCenter: parent.horizontalCenter
        y: lockIcon.locked ? parent.height * 0.04 : parent.height * 0.04 - parent.height * 0.16
        Behavior on y { NumberAnimation { duration: 150 } }
    }

    Rectangle {
        width: parent.width * 0.86
        height: parent.height * 0.62
        radius: parent.width * 0.12
        color: lockIcon.strokeColor
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
    }
}
