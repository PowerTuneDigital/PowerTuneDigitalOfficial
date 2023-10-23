pragma Singleton
import QtQuick 2.0

QtObject {
    property color active: "grey"
    property color inactive: "lightgrey"
    property color border: "steelblue"

    property color label_text_color: "white" // main text color
    property color content_text_color: "black" // secondary text color

    property int fontSize: 16
}
