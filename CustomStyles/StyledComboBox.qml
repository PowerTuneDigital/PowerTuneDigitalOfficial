import QtQuick 2.15
import QtQuick.Controls 2.15

import "../CustomStyles"

ComboBox {
    id: styledComboBox

    property alias modelData: styledComboBox.model // Expose model property for external binding

    delegate: ItemDelegate {
        width: parent.width
        text: parent.textRole ? (Array.isArray(
                                            control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
        highlighted: parent.highlightedIndex == index
        hoverEnabled: parent.hoverEnabled

        // This is for the text within the combo box
        contentItem: Text {
            text: modelData
            color: Constants.content_text_color
            font.weight: styledComboBox.currentIndex == index ? Font.DemiBold : Font.Normal
            font.family: styledComboBox.font.family
            font.pixelSize: Constants.fontSize
            verticalAlignment: Text.AlignVCenter
        }
    }

    // This is for the text displayed when the Combo is closed
    contentItem: Text {
        leftPadding: 8
        text: parent.displayText
        color: Constants.content_text_color
        font.pixelSize: Constants.fontSize
        verticalAlignment: Text.AlignVCenter
    }
}
