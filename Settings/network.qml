import QtQuick 2.8
import QtQuick.Controls 2.1
import Qt.labs.settings 1.0
import QtQuick.Controls 1.4 as Quick1
import QtQuick.Controls.Styles 1.4
import "qrc:/Translator.js" as Translator

Rectangle {
    id: extrarect
    anchors.fill: parent
    color: "grey"
    Connections {
        target: Dashboard
        onSerialStatChanged: {
            consoleText.append(Dashboard.SerialStat)
            //console.log(Dashboard.SerialStat);
            scrollBar.increase()
        }
    }
    WifiCountryList {
        id: wificountrynames
    }

    Settings {
        property alias wificountryindex: wificountrycbx.currentIndex
    }

    Flickable {
        id: flickable
        width: 450
        height: 400

        TextArea.flickable: TextArea {
            id: consoleText
            wrapMode: TextArea.Wrap
            readOnly: true
            color: "green"
            font.pixelSize: 15
            background: Rectangle {
                height: flickable.height
                width: flickable.width
                color: "black"
            }
        }

        ScrollBar.vertical: ScrollBar {
            id: scrollBar
            policy: ScrollBar.AlwaysOn
        }
    }

    Grid {
        id: extragrid
        anchors.top: parent.top
        anchors.topMargin: parent.height / 20
        anchors.right: parent.right
        rows: 12
        columns: 2
        spacing: parent.width / 150

        Text {
            text: " "
            font.pixelSize: extrarect.width / 55
        }
        Button {
            id: btnScanNetwork
            // visible: false
            text: Translator.translate("Scan WIFI", Dashboard.language)
            width: extrarect.width / 5
            height: extrarect.height / 15
            font.pixelSize: extrarect.width / 55
            onClicked: {
                consoleText.clear()
                Wifiscanner.initializeWifiscanner()
                //btnScanNetwork.enabled =false;
            }
        }
        Component.onCompleted: Wifiscanner.initializeWifiscanner() // Workarround to show initial values
        Text {
            text: Translator.translate("WIFI Country", Dashboard.language)
            font.pixelSize: extrarect.width / 55
        }
        ComboBox {
            id: wificountrycbx
            //visible: false
            width: extrarect.width / 5
            height: extrarect.height / 15
            font.pixelSize: extrarect.width / 55
            model: wificountrynames
            textRole: "name"
            property bool initialized: true
        }
        Text {
            text: Translator.translate("WIFI 1", Dashboard.language)
            font.pixelSize: extrarect.width / 55
        }
        ComboBox {
            id: wifilistbox
            //visible: false
            width: extrarect.width / 5
            height: extrarect.height / 15
            font.pixelSize: extrarect.width / 55
            model: Dashboard.wifi
            onCountChanged: btnScanNetwork.enabled = true
            property bool initialized: false
            delegate: ItemDelegate {
                width: wifilistbox.width
                text: wifilistbox.textRole ? (Array.isArray(
                                                  control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
                font.weight: wifilistbox.currentIndex == index ? Font.DemiBold : Font.Normal
                font.family: wifilistbox.font.family
                font.pixelSize: wifilistbox.font.pixelSize
                highlighted: wifilistbox.highlightedIndex == index
                hoverEnabled: wifilistbox.hoverEnabled
            }
        }
        Text {

            text: Translator.translate("Password 1", Dashboard.language)
            font.pixelSize: extrarect.width / 55
        }
        TextField {
            id: pw1
            placeholderText: qsTr("Passphrase")
            width: extrarect.width / 5
            font.pixelSize: extrarect.width / 55
        }


        /*
        Text { text: "Wifi 2 :"
            //visible: false
            font.pixelSize: extrarect.width / 55 }
        ComboBox {
            id: wifilistbox2
            //visible: false
            width: extrarect.width / 5
            height: extrarect.height /15
            font.pixelSize: extrarect.width / 55
            model: Dashboard.wifi
            onCountChanged: btnScanNetwork.enabled =true;
            property bool initialized: false
            delegate: ItemDelegate {
                width: wifilistbox2.width
                text: wifilistbox2.textRole ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
                font.weight: wifilistbox2.currentIndex == index ? Font.DemiBold : Font.Normal
                font.family: wifilistbox2.font.family
                font.pixelSize: wifilistbox2.font.pixelSize
                highlighted: wifilistbox2.highlightedIndex == index
                hoverEnabled: wifilistbox2.hoverEnabled
            }
        }
        Text {
            text: "Password :"
            font.pixelSize: extrarect.width / 55 }
        TextField {
            id: pw2
            placeholderText: qsTr("Passphrase")
            width: extrarect.width / 5
            font.pixelSize: extrarect.width / 55 }*/
        Text {
            text: " "
            font.pixelSize: extrarect.width / 55
        }

        Button {
            id: applyWifiSettings
            text: Translator.translate("Connect WIFI", Dashboard.language)
            width: extrarect.width / 5
            height: extrarect.height / 15
            font.pixelSize: extrarect.width / 55
            Component.onCompleted: {

                //Wifiscanner.findActiveWirelesses();
                // Wifiscanner.initializeWifiscanner()
            }
            onClicked: {
                //Wifiscanner.setwifi(wificountrynames.get(wificountrycbx.currentIndex).countryname,wifilistbox.textAt(wifilistbox.currentIndex),pw1.text,wifilistbox2.textAt(wifilistbox2.currentIndex),pw2.text );
                Wifiscanner.setwifi(
                            wificountrynames.get(
                                wificountrycbx.currentIndex).countryname,
                            wifilistbox.textAt(wifilistbox.currentIndex),
                            pw1.text, "placeholder", "placeholder")
                Connect.reboot()
            }
        }

        Text {
            text: " "
            font.pixelSize: extrarect.width / 55
        }
        Button {
            id: updateBtn
            text: Translator.translate("Update", Dashboard.language)
            width: extrarect.width / 5
            height: extrarect.height / 15
            font.pixelSize: extrarect.width / 55
            onClicked: {
                Connect.update()
                updateBtn.enabled = false
            }
        }

        Text {
            text: " "
            font.pixelSize: extrarect.width / 55
        }

        Button {
            id: develtest
            text: Translator.translate("Restart daemon", Dashboard.language)
            width: extrarect.width / 5
            height: extrarect.height / 15
            font.pixelSize: extrarect.width / 55

            onClicked: {

                //Arduino.openConnection("COM11");
                Connect.restartDaemon()
                //develtest.enabled = false;
            }
        }
        Text {
            text: " "
            font.pixelSize: extrarect.width / 55
        }
        Button {
            id: trackUpdate
            text: Translator.translate("Update Tracks", Dashboard.language)
            width: extrarect.width / 5
            height: extrarect.height / 15
            font.pixelSize: extrarect.width / 55
            onClicked: {
                downloadManager.append("") // needed as a workarround
                downloadManager.append(
                            "https://gitlab.com/PowerTuneDigital/PowertuneTracks/-/raw/main/repo.txt")
                downloadManager.append("") // needed as a workarround
                consoleText.append("Downloading Tracks for Laptimer :")
                trackUpdate.enabled = false
                downloadprogress.indeterminate = true
            }
        }
        Text {
            text: " "
            font.pixelSize: extrarect.width / 55
        }
        Quick1.ProgressBar {
            id: downloadprogress
            width: extrarect.width / 5
            height: extrarect.height / 15
        }
        Text {
            id: ethernetip
            text: Translator.translate("Ethernet IP adress", Dashboard.language)
            font.pixelSize: extrarect.width / 55
            visible: true
        }

        Quick1.Button {
            id: ethernetstatus
            text: Dashboard.EthernetStat
            width: extrarect.width / 5
            height: extrarect.height / 15
            style: ButtonStyle {
                label: Label {
                    text: ethernetstatus.text
                    color: "black"
                    font.pixelSize: extrarect.width / 55
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: {
                        (ethernetstatus.text == "NOT CONNECTED") ? "red" : "green"
                    }
                    border.width: control.activeFocus ? 2 : 1
                    border.color: "#888"
                }
            }
        }

        Text {
            id: wlanip
            text: Translator.translate("WLAN IP adress", Dashboard.language)
            font.pixelSize: extrarect.width / 55
            visible: true
        }
        Quick1.Button {
            id: wifistatus
            text: Dashboard.WifiStat
            width: extrarect.width / 5
            height: extrarect.height / 15
            style: ButtonStyle {
                label: Label {
                    text: wifistatus.text
                    color: "black"
                    font.pixelSize: extrarect.width / 55
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: {
                        (wifistatus.text == "NOT CONNECTED") ? "red" : "green"
                    }
                    border.width: control.activeFocus ? 2 : 1
                    border.color: "#888"
                }
            }
        }
        Text {
            text: " "
            font.pixelSize: extrarect.width / 55
        }
        Text {
            id: downloadspeedtext
            text: downloadManager.downloadStatus
            font.pixelSize: extrarect.width / 55
            onTextChanged: {
                if (downloadspeedtext.text == "Finished") {
                    //trackUpdate.enabled = true;
                    downloadprogress.indeterminate = false
                    downloadspeedtext.text = " "
                    Connect.changefolderpermission()
                }
            }
        }
        Text {
            id: downloadfilenametext
            text: downloadManager.downloadFilename
            font.pixelSize: extrarect.width / 55
            visible: false
            onTextChanged: consoleText.append(downloadManager.downloadFilename)
        }


        /*

        Button {
            id: develtest1
            text: "Development dont click"
            width: extrarect.width / 5
            height: extrarect.height /15
            font.pixelSize: extrarect.width / 55
            onClicked: Connect.canbitratesetup(0)

        }*/
    }
}
