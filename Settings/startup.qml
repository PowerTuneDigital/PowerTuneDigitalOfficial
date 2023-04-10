import QtQuick 2.8
import QtQuick.Controls 2.1
import Qt.labs.settings 1.0

Rectangle {
    id: daemons
    anchors.fill: parent
    color: "grey"

    Item {
        id: startupsettings
        Settings {
            property alias mainspeedsource: mainspeedsource.currentIndex
            property alias daemonselect: daemonselect.currentIndex
            property alias bitrateselect: canbitrateselect.currentIndex
        }
    }

    Grid {
        id: startupgrid
        anchors.top: parent.top
        anchors.topMargin: parent.height / 20
        anchors.right: parent.right
        rows: 10
        columns: 2
        spacing: parent.width / 150
        Text {
            text: "Apply Settings :"
            font.pixelSize: daemons.width / 55
        }
        Button {
            id: apply
            width: daemons.width / 3
            height: daemons.height / 15
            text: "apply"
            onClicked: {
                Connect.daemonstartup(daemonselect.currentIndex)
                Connect.canbitratesetup(canbitrateselect.currentIndex)
            }
        }

        Text {
            text: "Start up Daemon :"
            font.pixelSize: daemons.width / 55
        }
        ComboBox {
            id: daemonselect
            width: daemons.width / 3
            height: daemons.height / 15
            font.pixelSize: daemons.width / 55
            model: ["None", "HaltechV2", "Link Generic Dash", "Microtech", "Consult", "M800 Set1", "OBD2", "Hondata 100Hz", "Adaptronic CAN", "Motec M1", "AEM V2", "AUDI B7", "BRZ FRS 86", "ECU Masters", "Audi B8", "Emtron", "Holley", "MaxxECU", "Ford FG MK1", "Ford FG MK1 + OBD Polling", "Ford BA+BF ", "Ford BA+BF + OBD Polling", "Ford FG2x", "Ford FG2x + OBD Polling", "EVO X", "Blackbox M3", "NISSAN 370Z", "GM: LS2-LS7 CAN", "NISSAN 350Z", "Megasquirt CAN Simplified", "EMTECH EMS CAN", "WRX 2008-2015", "Motec Set3 ADL", "Testdaemon", "Ecoboost", "Emerald ECU", "Wolf", "GM OBD-CAN", "Unused", "Hondata 20Hz", "11-Bit CAN", "Motorsport Electronics", "Fueltech", "Delta", "Bigstuff AFR", "Bigstuff Lamda", "R35", "Prado", "WRX 2016", "LifeRacing beta", "DTAFast", "ProEFI", "TeslaSDU", "NeuroBasic" ,"GR Yaris (Beta)","Syvecs","RSport"]
            delegate: ItemDelegate {
                width: daemonselect.width
                text: daemonselect.textRole ? (Array.isArray(
                                                   control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
                font.weight: daemonselect.currentIndex == index ? Font.DemiBold : Font.Normal
                font.family: daemonselect.font.family
                font.pixelSize: daemonselect.font.pixelSize
                highlighted: daemonselect.highlightedIndex == index
                hoverEnabled: daemonselect.hoverEnabled
            }
            onCurrentIndexChanged: autochangecanspeed.start()
            //Component.onCompleted: tabView.currentIndex = 0;
        }
        Text {
            text: "CAN Bitrate :"
            font.pixelSize: daemons.width / 55
        }
        ComboBox {
            id: canbitrateselect
            width: daemons.width / 3
            height: daemons.height / 15
            font.pixelSize: daemons.width / 55
            model: ["250 kbit/s", "500 kbit/s", "1 Mbit/s"]
            delegate: ItemDelegate {
                width: canbitrateselect.width
                text: canbitrateselect.textRole ? (Array.isArray(
                                                       control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
                font.weight: canbitrateselect.currentIndex == index ? Font.DemiBold : Font.Normal
                font.family: canbitrateselect.font.family
                font.pixelSize: canbitrateselect.font.pixelSize
                highlighted: canbitrateselect.highlightedIndex == index
                hoverEnabled: canbitrateselect.hoverEnabled
            }
            //Component.onCompleted: tabView.currentIndex = 0;
        }
        Item {
            //Function to automatically change can speeds
            id: autochangecanspeed
            function start() {
                //if (daemonselect.textAt(daemonselect.currentIndex) == "OBD2"|| daemonselect.textAt(daemonselect.currentIndex) == "AUDI B7"|| daemonselect.textAt(daemonselect.currentIndex) == "BRZ FRS 86"|| daemonselect.textAt(daemonselect.currentIndex) =="Audi B8"|| daemonselect.textAt(daemonselect.currentIndex) == "Barra FG MK1"|| daemonselect.textAt(daemonselect.currentIndex) =="Barra FG MK1 + OBD Polling"||daemonselect.textAt(daemonselect.currentIndex) =="Barra BX "||daemonselect.textAt(daemonselect.currentIndex) =="Barra BX + OBD Polling"||daemonselect.textAt(daemonselect.currentIndex) =="Barra FG2x" || daemonselect.textAt(daemonselect.currentIndex) =="Barra FG2x + OBD Polling"||daemonselect.textAt(daemonselect.currentIndex)== "EVO X Test"||"NISSAN 370Z Test"||daemonselect.textAt(daemonselect.currentIndex) =="GM: LS2-LS7 CAN"||daemonselect.textAt(daemonselect.currentIndex) == "NISSAN 350Z Test")
                //if (daemonselect.textAt(daemonselect.currentIndex) == "OBD2")
                switch (daemonselect.textAt(daemonselect.currentIndex)) {
                case "OBD2":
                    canbitrateselect.currentIndex = 1 // 500 Kbs
                    break
                case "AUDI B7":
                    canbitrateselect.currentIndex = 1 // 500 Kbs
                    break
                case "BRZ FRS 86":
                    canbitrateselect.currentIndex = 1 // 500 Kbs
                    break
                case "Audi B8":
                    canbitrateselect.currentIndex = 1 // 500 Kbs
                    break
                case "Ford FG MK1":
                    canbitrateselect.currentIndex = 1 // 500 Kbs
                    break
                case "Ford FG MK1 + OBD Polling":
                    canbitrateselect.currentIndex = 1 // 500 Kbs
                    break
                case "Ford BX ":
                    canbitrateselect.currentIndex = 1 // 500 Kbs
                    break
                case "Ford BX + OBD Polling":
                    canbitrateselect.currentIndex = 1 // 500 Kbs
                    break
                case "Ford FG2x":
                    canbitrateselect.currentIndex = 1 // 500 Kbs
                    break
                case "Ford FG2x + OBD Polling":
                    canbitrateselect.currentIndex = 1 // 500 Kbs
                    break
                case "EVO X Test":
                    canbitrateselect.currentIndex = 1 // 500 Kbs
                    break
                case "NISSAN 370Z Test":
                    canbitrateselect.currentIndex = 1 // 500 Kbs
                    break
                case "GM: LS2-LS7 CAN":
                    canbitrateselect.currentIndex = 1 // 500 Kbs
                    break
                case "NISSAN 350Z Test":
                    canbitrateselect.currentIndex = 1 // 500 Kbs
                    break
                case "Subaru Test":
                    canbitrateselect.currentIndex = 1 // 500 Kbs
                    break
                case "11-Bit CAN":
                    canbitrateselect.currentIndex = 1 // 500 Kbs
                    break
                case "Motorsport Electronics":
                    canbitrateselect.currentIndex = 2 // 1Mbit
                    break
                case "Fueltech":
                    canbitrateselect.currentIndex = 2 // 1Mbit
                    break
                default:
                    canbitrateselect.currentIndex = 2 // 1Mbit
                    break
                }
            }
        }
        Text {
            text: "Main Speed Source :"
            font.pixelSize: daemons.width / 55
        }
        ComboBox {
            id: mainspeedsource
            width: daemons.width / 3
            height: daemons.height / 15
            font.pixelSize: daemons.width / 55
            model: ["ECU Speed", "LF Wheelspeed", "RF Wheelspeed", "LR Wheelspeed", "RR Wheelspeed", "GPS"]
            onCurrentIndexChanged: AppSettings.writeStartupSettings(
                                       mainspeedsource.currentIndex) //,console.log("Setting SPeed")
            property bool initialized: false
            //Component.onCompleted: tabView.currentIndex = 0
            delegate: ItemDelegate {
                width: mainspeedsource.width
                text: mainspeedsource.textRole ? (Array.isArray(
                                                      control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
                font.weight: mainspeedsource.currentIndex == index ? Font.DemiBold : Font.Normal
                font.family: mainspeedsource.font.family
                font.pixelSize: mainspeedsource.font.pixelSize
                highlighted: mainspeedsource.highlightedIndex == index
                hoverEnabled: mainspeedsource.hoverEnabled
            }
        }
    }
    Text {
        id: warningtext
        text: "DO NOT SELECT ANY START UP DAEMON THAT INCLUDES OBD/OBD2 WHILST TUNING YOUR VEHICLE or working with the ECU/PCM. PowerTune Digital users MUST disable OBD polling when tuning or performing any task related to the ECU/PCM by changing the start up daemon above to a NON OBD/OBD2 option and pressing apply, or disconnecting the dash entirely whilst tuning or working with any vehicle electronics. PowerTune Digital assumes no liability for damage to your vehicle/ECU/PCM if polling OBD data at the same time as another device causes an interruption, or for any other reason. Refer to our warranty at https://www.powertunedigital.com/pages/manual "
        font.pixelSize: daemons.width / 55
        font.bold: true
        width: parent.width / 1.5
        horizontalAlignment: Text.AlignHCenter
        anchors.top: startupgrid.bottom
        anchors.horizontalCenter: daemons.horizontalCenter
        color: "red"
        wrapMode: Text.WordWrap
        //visible: { (daemonselect.currentIndex == 19 || daemonselect.currentIndex == 21 || daemonselect.currentIndex == 23 ) ? true:false; }
    }
}
