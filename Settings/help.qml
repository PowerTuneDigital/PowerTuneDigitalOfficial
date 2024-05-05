import QtQuick 2.8
import QtQuick.Controls 2.1
import Qt.labs.settings 1.0
import "qrc:/Translator.js" as Translator
Rectangle {
    id: helpBackground
    anchors.fill: parent
    color: "grey"

    Column {               
                anchors.centerIn: parent
                Text {
                    id: supportText
                    bottomPadding: helpBackground.height * 0.5
                    text: Translator.translate("Support", Dashboard.language)
                    font.bold: true
                    font.pixelSize: helpBackground.width * 0.02
                    horizontalAlignment: Text.AlignHCenter
                }
    }

        Text {
            id: contactText
            text: "Contact Page"
            font.family: "Eurostile"
            bottomPadding: 10
            font.bold: true
            x: 30
            y: 370
            font.pixelSize: helpBackground.width * 0.018 //36
            Component.onCompleted: {
                if(helpBackground.width == 800){
                    contactText.x = 15
                    contactText.y = 300
                }
            }
        }
        Text {
            id: facebookText
            text: "Facebook"
            font.family: "Eurostile"
            bottomPadding: 10
            font.bold: true
            x: 390
            y: 370
            font.pixelSize: helpBackground.width * 0.018
            Component.onCompleted: {
                if(helpBackground.width == 800){
                    facebookText.x = 195
                    facebookText.y = 300
                }
            }
        }
        Text {
            id: instagramText
            text: "Instagram"
            font.family: "Eurostile"
            bottomPadding: 10
            font.bold: true
            x: 720
            y: 370
            font.pixelSize: helpBackground.width * 0.018
            Component.onCompleted: {
                if(helpBackground.width == 800){
                    instagramText.x = 360
                    instagramText.y = 300
                }
            }
        }
        Text {
            id: manualText
            text: "Manual"
            font.family: "Eurostile"
            bottomPadding: 10
            font.bold: true
            x: 1080
            y: 370
            font.pixelSize: helpBackground.width * 0.018
            Component.onCompleted: {
                if(helpBackground.width == 800){
                    manualText.x = 540
                    manualText.y = 300
                }
            }
        }
        Text {
            id: warrantyText
            text: "Warranty"
            font.family: "Eurostile"
            bottomPadding: 10
            font.bold: true
            x: 1400
            y: 370
            font.pixelSize: helpBackground.width * 0.018
            Component.onCompleted: {
                if(helpBackground.width == 800){
                    warrantyText.x = 700
                    warrantyText.y = 300
                }
            }
        }

    Grid{
        rows:1
        columns: 5
            id: qrImage
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            spacing: parent.width * 0.05
            Image {
                id:contactQR
                source: "qrc:/graphics/contactQR.png" // Replace with your image file path
                width: helpBackground.width * 0.16 //256
                height: helpBackground.width * 0.16 //256 // Adjust as needed
            }
            Image {
                id:facebookQR
                source: "qrc:/graphics/facebookQR.png" // Replace with your image file path
                width: helpBackground.width * 0.16 //256
                height: helpBackground.width * 0.16 //256 // Adjust as needed
            }
            Image {
                id:instagramQR
                source: "qrc:/graphics/instagramQR.png" // Replace with your image file path
                width: helpBackground.width * 0.16 //256
                height: helpBackground.width * 0.16 //256 // Adjust as needed
            }
            Image {
                id:userManualQR
                source: "qrc:/graphics/userManualQR.png" // Replace with your image file path
                width: helpBackground.width * 0.16 //256
                height: helpBackground.width * 0.16 //256 // Adjust as needed
            }
            Image {
                id:reviewQR
                source: "qrc:/graphics/warrantyQR.png" // Replace with your image file path
                width: helpBackground.width * 0.16 //256
                height: helpBackground.width * 0.16 //256 // Adjust as needed
            }
        }
}

