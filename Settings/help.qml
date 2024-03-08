import QtQuick 2.8
import QtQuick.Controls 2.1
import Qt.labs.settings 1.0

Rectangle {
    id: helpBackground
    anchors.fill: parent
    color: "grey"

    Column {               
                anchors.centerIn: parent
                Text {
                    id: supportText
                    bottomPadding: helpBackground.height * 0.5
                    text: "Powertune Digital offers unlimited free tech support! <p>If you are having any issues please reach out using any of the platforms below.</p> <br>Australia: 07 2102 4825</br> <br>USA: 1888 421 2360</br> <br>Worldwide: +61 721 024 825</br> <br>Email Inquiries: info@powertunedigital.com</br>"
                    font.bold: true
                    font.pixelSize: helpBackground.width * 0.02
                    horizontalAlignment: Text.AlignHCenter
                }
    }

    // Column {
    //     anchors.fill: parent
    //     anchors.centerIn: parent

    Grid{
        rows:1
        columns: 5
        leftPadding: helpBackground.width * 0.0225

            id: qrText
            anchors {
                left: helpBackground.left
                right: helpBackground.right
                bottom: qrImage.top
            }
            spacing: parent.width * 0.11

        Text {
            text: "Contact Page"
            font.family: "Eurostile"
            bottomPadding: 10
            font.bold: true
            font.pixelSize: helpBackground.width * 0.018 //36
        }
        Text {
            text: "Facebook"
            font.family: "Eurostile"
            bottomPadding: 10
            font.bold: true
            font.pixelSize: helpBackground.width * 0.018
        }
        Text {
            text: "Instagram"
            font.family: "Eurostile"
            bottomPadding: 10
            font.bold: true
            font.pixelSize: helpBackground.width * 0.018
        }
        Text {
            text: "Manual"
            font.family: "Eurostile"
            bottomPadding: 10
            font.bold: true
            font.pixelSize: helpBackground.width * 0.018
        }
        Text {
            text: "      Warranty"
            font.family: "Eurostile"
            bottomPadding: 10
            font.bold: true
            font.pixelSize: helpBackground.width * 0.018
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

