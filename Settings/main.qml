import QtQuick 2.8
import QtQuick.Controls 2.1
import QtMultimedia 5.8
import Qt.labs.settings 1.0

Rectangle {
    id: windowbackround
    anchors.fill: parent
    color: "grey"
    property int test1: 0
    property int connected: 0
    property var gpscom
    property int hexstring
    property int hexstring2
    Item {
        id: powerTuneSettings
        Settings {
            //property alias brightnessselect: brightness.value
            // property alias connectAtStartUp: connectAtStart.checked
            property alias connectECUAtStartup: connectButton.enabled
            property alias connectGPSAtStartup: connectButtonGPS.enabled
            //property alias gpsswitch: gpsswitch.checked
            property alias serialPortName: serialName.currentText
            property alias gpsPortName: serialNameGPS.currentText
            property alias gpsPortNameindex: serialNameGPS.currentIndex
            //property alias gpsBaud: serialGPSBaud.currentText
            //property alias gpsBaudindex: serialGPSBaud.currentIndex
            property alias ecuType: ecuSelect.currentText
            property alias auxunit1: unitaux1.text
            property alias aux1: an1V0.text
            property alias aux2: an2V5.text
            property alias auxunit2: unitaux2.text
            property alias aux3: an3V0.text
            property alias aux4: an4V5.text
            property alias goProVariant: goProSelect.currentIndex
            property alias password: goPropass.text
            property alias vehicleweight: weight.text
            property alias unitSelector1: unitSelect1.currentIndex
            property alias unitSelector: unitSelect.currentIndex
            property alias unitSelector2: unitSelect2.currentIndex
            property alias odometervalue: odometer.text
            property alias tripmetervalue: tripmeter.text
            //property alias protocol : protocol.currentIndex
            property alias smoothingrpm: smoothrpm.currentIndex
            property alias smoothingspeed: smoothspeed.currentIndex
            property alias extendercanbase: baseadresstext.text
            property alias shiftlightcanbase: shiftlightbaseadresstext.text
        }
        SoundEffect {
            id: warnsound
            source: "qrc:/Sounds/alarm.wav"
        }

        Connections {
            target: Dashboard
            onWifiStatChanged: {
                wifistatus.text = Dashboard.WifiStat
            }
            onEthernetStatChanged: {
                ethernetstatus.text = Dashboard.EthernetStat
            }

            onOdoChanged: {
                odometer.text = (Dashboard.Odo).toFixed(3)
            }
            onTripChanged: {
                tripmeter.text = (Dashboard.Trip).toFixed(3)
            }
            onWatertempChanged: {
                if (Dashboard.Watertemp > Dashboard.waterwarn) {
                    playwarning.start()
                }
                ;
            }
            onRpmChanged: {
                if (Dashboard.rpm > Dashboard.rpmwarn) {
                    playwarning.start()
                }
                ;
            }
            onKnockChanged: {
                if (Dashboard.Knock > Dashboard.knockwarn) {
                    playwarning.start()
                }
                ;
            }
            onBoostPresChanged: {
                if (Dashboard.BoostPres > Dashboard.boostwarn) {
                    playwarning.start()
                }
                ;
            }
        }

        Row {
            x: windowbackround.width / 150
            y: windowbackround.width / 150
            spacing: windowbackround.width / 150
            Grid {
                anchors.top: parent.top
                anchors.topMargin: parent.height / 20
                rows: 13
                columns: 2
                spacing: windowbackround.width / 150
                // [0]
                Text {
                    text: "ECU Serial Port: "
                    font.pixelSize: windowbackround.width / 55
                    color: "white"
                    visible: {
                        (ecuSelect.currentIndex != "1") ? false : true
                    }
                }
                ComboBox {
                    id: serialName
                    width: windowbackround.width / 5
                    height: windowbackround.height / 15
                    font.pixelSize: windowbackround.width / 55
                    model: Connect.portsNames
                    visible: {
                        (ecuSelect.currentIndex != "1") ? false : true
                    }
                    property bool initialized: false
                    onCurrentIndexChanged: if (initialized)
                                               AppSettings.setBaudRate(
                                                           currentIndex)
                    Component.onCompleted: {
                        currentIndex = AppSettings.getBaudRate()
                        initialized = true
                        autoconnect.auto()
                    }
                    delegate: ItemDelegate {
                        width: serialName.width
                        text: serialName.textRole ? (Array.isArray(
                                                         control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
                        font.weight: serialName.currentIndex == index ? Font.DemiBold : Font.Normal
                        font.family: serialName.font.family
                        font.pixelSize: serialName.font.pixelSize
                        highlighted: serialName.highlightedIndex == index
                        hoverEnabled: serialName.hoverEnabled
                    }
                }
                Text {
                    text: "GPS Port: "
                    font.pixelSize: windowbackround.width / 55
                    color: "white"
                    //visible: { (gpsswitch.checked == true ) ? true:false; }
                }
                ComboBox {
                    id: serialNameGPS
                    width: windowbackround.width / 5
                    height: windowbackround.height / 15
                    font.pixelSize: windowbackround.width / 55
                    model: Connect.portsNames
                    // visible: { (gpsswitch.checked == true ) ? true:false; }
                    delegate: ItemDelegate {
                        width: serialNameGPS.width
                        text: serialNameGPS.textRole ? (Array.isArray(
                                                            control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
                        font.weight: serialNameGPS.currentIndex
                                     == index ? Font.DemiBold : Font.Normal
                        font.family: serialNameGPS.font.family
                        font.pixelSize: serialNameGPS.font.pixelSize
                        highlighted: serialNameGPS.highlightedIndex == index
                        hoverEnabled: serialNameGPS.hoverEnabled
                    }
                }
                Text {
                    text: "Speed units:"
                    font.pixelSize: windowbackround.width / 55
                    color: "white"
                }
                ComboBox {
                    id: unitSelect1
                    width: windowbackround.width / 5
                    height: windowbackround.height / 15
                    font.pixelSize: windowbackround.width / 55
                    model: ["Metric", "Imperial"]
                    property bool initialized: false
                    Component.onCompleted: {
                        Connect.setSpeedUnits(currentIndex)
                        changeweighttext.changetext()
                    }
                    onCurrentIndexChanged: {
                        Connect.setSpeedUnits(currentIndex)
                        changeweighttext.changetext()
                    }
                    delegate: ItemDelegate {
                        width: unitSelect1.width
                        text: unitSelect1.textRole ? (Array.isArray(
                                                          control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
                        font.weight: unitSelect1.currentIndex == index ? Font.DemiBold : Font.Normal
                        font.family: unitSelect1.font.family
                        font.pixelSize: unitSelect1.font.pixelSize
                        highlighted: unitSelect1.highlightedIndex == index
                        hoverEnabled: unitSelect1.hoverEnabled
                    }
                }
                Text {
                    text: "Temp units:"
                    font.pixelSize: windowbackround.width / 55
                    color: "white"
                }
                ComboBox {
                    id: unitSelect
                    width: windowbackround.width / 5
                    height: windowbackround.height / 15
                    font.pixelSize: windowbackround.width / 55
                    model: ["Metric", "Imperial"]
                    property bool initialized: false
                    Component.onCompleted: {
                        Connect.setUnits(currentIndex)
                        changeweighttext.changetext()
                    }
                    onCurrentIndexChanged: {
                        Connect.setUnits(currentIndex)
                        changeweighttext.changetext()
                    }
                    delegate: ItemDelegate {
                        width: unitSelect.width
                        text: unitSelect.textRole ? (Array.isArray(
                                                         control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
                        font.weight: unitSelect.currentIndex == index ? Font.DemiBold : Font.Normal
                        font.family: unitSelect.font.family
                        font.pixelSize: unitSelect.font.pixelSize
                        highlighted: unitSelect.highlightedIndex == index
                        hoverEnabled: unitSelect.hoverEnabled
                    }
                }
                Text {
                    text: "Pressure units:"
                    font.pixelSize: windowbackround.width / 55
                    color: "white"
                }
                ComboBox {
                    id: unitSelect2
                    width: windowbackround.width / 5
                    height: windowbackround.height / 15
                    font.pixelSize: windowbackround.width / 55
                    model: ["kPa", "PSI"]
                    property bool initialized: false
                    Component.onCompleted: {
                        Connect.setPressUnits(currentIndex)
                    }
                    onCurrentIndexChanged: {
                        Connect.setPressUnits(currentIndex)
                    }
                    delegate: ItemDelegate {
                        width: unitSelect.width
                        text: unitSelect.textRole ? (Array.isArray(
                                                         control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
                        font.weight: unitSelect.currentIndex == index ? Font.DemiBold : Font.Normal
                        font.family: unitSelect.font.family
                        font.pixelSize: unitSelect.font.pixelSize
                        highlighted: unitSelect.highlightedIndex == index
                        hoverEnabled: unitSelect.hoverEnabled
                    }
                }
                Text {
                    text: "ECU Selection:"
                    font.pixelSize: windowbackround.width / 55
                    color: "white"
                }
                ComboBox {
                    id: ecuSelect
                    width: windowbackround.width / 5
                    height: windowbackround.height / 15
                    font.pixelSize: windowbackround.width / 55
                    //model: [ "PowerFC","UDP","None","CAN Adaptronic Modular","Consult","HaltechV1","HaltechV2","OBD2"]
                    model: ["CAN", "PowerFC", "Consult", "OBD2"]
                    property bool initialized: false
                    onCurrentIndexChanged: {
                        if (initialized)
                            AppSettings.setECU(currentIndex), Dashboard.setecu(ecuSelect.currentIndex)
                    }
                    Component.onCompleted: {
                        currentIndex = AppSettings.getECU(), Dashboard.setecu(ecuSelect.currentIndex), initialized = true
                    }
                    delegate: ItemDelegate {
                        width: ecuSelect.width
                        text: ecuSelect.textRole ? (Array.isArray(
                                                        control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
                        font.weight: ecuSelect.currentIndex == index ? Font.DemiBold : Font.Normal
                        font.family: ecuSelect.font.family
                        font.pixelSize: ecuSelect.font.pixelSize
                        highlighted: ecuSelect.highlightedIndex == index
                        hoverEnabled: ecuSelect.hoverEnabled
                    }
                }
                Text {
                    text: "GoPro Variant :"
                    font.pixelSize: windowbackround.width / 55
                    color: "white"
                }
                ComboBox {
                    id: goProSelect
                    width: windowbackround.width / 5
                    height: windowbackround.height / 15
                    font.pixelSize: windowbackround.width / 55
                    model: ["Hero", "Hero2", "Hero3"]
                    delegate: ItemDelegate {
                        width: goProSelect.width
                        text: goProSelect.textRole ? (Array.isArray(
                                                          control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
                        font.weight: goProSelect.currentIndex == index ? Font.DemiBold : Font.Normal
                        font.family: goProSelect.font.family
                        font.pixelSize: goProSelect.font.pixelSize
                        highlighted: goProSelect.highlightedIndex == index
                        hoverEnabled: goProSelect.hoverEnabled
                    }
                }
                Text {
                    text: "GoPro Password :"
                    font.pixelSize: windowbackround.width / 55
                    color: "white"
                }
                TextField {
                    id: goPropass
                    width: windowbackround.width / 5
                    height: windowbackround.height / 15
                    font.pixelSize: windowbackround.width / 55
                    placeholderText: qsTr("GoPro Password")
                    //InputMethod:Qt.
                    inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhPreferLowercase
                                      | Qt.ImhSensitiveData | Qt.ImhNoPredictiveText
                    Component.onCompleted: {
                        transferSettings.sendSettings()
                    }
                }
                Text {
                    text: "Logfile name:"
                    font.pixelSize: windowbackround.width / 55
                    color: "white"
                }
                TextField {
                    id: logfilenameSelect
                    text: qsTr("DataLog")
                    width: windowbackround.width / 5
                    height: windowbackround.height / 15
                    font.pixelSize: windowbackround.width / 55
                    inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhPreferLowercase
                                      | Qt.ImhSensitiveData | Qt.ImhNoPredictiveText
                    //enterKeyAction: EnterKeyAction.Next
                }
                Text {
                    text: "Odo:"
                    font.pixelSize: windowbackround.width / 55
                    color: "white"
                }
                TextField {
                    id: odometer
                    width: windowbackround.width / 5
                    height: windowbackround.height / 15
                    font.pixelSize: windowbackround.width / 55
                    text: qsTr("0")
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    //enterKeyAction: EnterKeyAction.Next
                }
                Text {
                    text: "Trip:"
                    font.pixelSize: windowbackround.width / 55
                    color: "white"
                }
                TextField {
                    id: tripmeter
                    width: windowbackround.width / 5
                    height: windowbackround.height / 15
                    font.pixelSize: windowbackround.width / 55
                    readOnly: true
                    text: "0"
                    Component.onCompleted: Dashboard.setTrip(tripmeter.text)
                }

                Text {
                    id: weighttext
                    font.pixelSize: windowbackround.width / 55
                    color: "white"
                    text: "Weight:"
                }
                TextField {
                    id: weight
                    width: windowbackround.width / 5
                    height: windowbackround.height / 15
                    font.pixelSize: windowbackround.width / 55
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                }
                Text {
                    text: "Serial Status:"
                    font.pixelSize: windowbackround.width / 55
                    color: "white"
                }
                TextField {
                    width: windowbackround.width / 5
                    height: windowbackround.height / 15
                    font.pixelSize: windowbackround.width / 55
                    text: qsTr(Dashboard.SerialStat)
                }
            }

            Grid {
                rows: 13
                columns: 2
                spacing: windowbackround.width / 150
                anchors.top: parent.top
                anchors.topMargin: parent.height / 20
                id: middlegrid
                Button {
                    id: connectButton
                    text: "Connect"
                    width: windowbackround.width / 5
                    height: windowbackround.height / 15
                    font.pixelSize: windowbackround.width / 55
                    onClicked: {
                        functconnect.connectfunc()
                        connectButton.enabled = false
                        ecuSelect.enabled = false
                        disconnectButton.enabled = true
                        //consultset.enabled = false;
                    }
                }
                Button {
                    id: disconnectButton
                    text: "Disconnect"
                    width: windowbackround.width / 5
                    height: windowbackround.height / 15
                    font.pixelSize: windowbackround.width / 55
                    enabled: false
                    onClicked: {
                        connectButton.enabled = true
                        disconnectButton.enabled = false
                        ecuSelect.enabled = true
                        // consultset.enabled = true;
                        functdisconnect.disconnectfunc()
                    }
                }
                Button {
                    id: connectButtonGPS
                    text: "GPS Connect"
                    width: windowbackround.width / 5
                    height: windowbackround.height / 15
                    font.pixelSize: windowbackround.width / 55
                    Component.onCompleted: autoconnectGPS.auto()
                    onClicked: {

                        //console.log("clicked GPS")
                        connectButtonGPS.enabled = false
                        disconnectButtonGPS.enabled = true
                        autoconnectGPS.auto()
                        //console.log("gps disconnect enabled")
                    }
                }
                Button {
                    id: disconnectButtonGPS
                    text: "GPS Disconnect"
                    width: windowbackround.width / 5
                    height: windowbackround.height / 15
                    font.pixelSize: windowbackround.width / 55
                    enabled: false
                    onClicked: {
                        connectButtonGPS.enabled = true
                        disconnectButtonGPS.enabled = false
                        Gps.closeConnection()
                    }
                }

                Button {
                    id: resettrip
                    text: "Trip Reset"
                    width: windowbackround.width / 5
                    height: windowbackround.height / 15
                    font.pixelSize: windowbackround.width / 55
                    onClicked: {
                        Calculations.resettrip()
                    }
                }

                //for official raspberry Pi image only !!!!


                /*
        Button {
            id: updateButton
            text: "Pi Update "
            onClicked: { updateButton.enabled =false,Connect.update();
            }
        }
*/
                Button {
                    text: "Quit"
                    width: windowbackround.width / 5
                    height: windowbackround.height / 15
                    font.pixelSize: windowbackround.width / 55
                    onClicked: {
                        Qt.quit()
                    }
                }
                Button {
                    text: "Shutdown"
                    width: windowbackround.width / 5
                    height: windowbackround.height / 15
                    font.pixelSize: windowbackround.width / 55
                    onClicked: {
                        Connect.shutdown()
                    }
                }
                Button {
                    text: "Reboot"
                    width: windowbackround.width / 5
                    height: windowbackround.height / 15
                    font.pixelSize: windowbackround.width / 55
                    onClicked: {
                        //GPS.closeConnection();
                        Connect.reboot()
                    }
                }

                Text {
                    text: "RPM Smoothing :"
                    color: "white"
                    font.pixelSize: windowbackround.width / 55
                }
                ComboBox {
                    id: smoothrpm
                    width: windowbackround.width / 5
                    height: windowbackround.height / 15
                    font.pixelSize: windowbackround.width / 55
                    model: ["OFF", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
                    //property bool initialized: true
                    onCurrentIndexChanged: {
                        Dashboard.setsmoothrpm(smoothrpm.currentIndex)
                    }
                    Component.onCompleted: {
                        Dashboard.setsmoothrpm(smoothrpm.currentIndex)
                    }
                    delegate: ItemDelegate {
                        width: smoothrpm.width
                        text: smoothrpm.textRole ? (Array.isArray(
                                                        control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
                        font.weight: smoothrpm.currentIndex == index ? Font.DemiBold : Font.Normal
                        font.family: smoothrpm.font.family
                        font.pixelSize: smoothrpm.font.pixelSize
                        highlighted: smoothrpm.highlightedIndex == index
                        hoverEnabled: smoothrpm.hoverEnabled
                    }
                }

                Text {
                    text: "Speed Smoothing :"
                    color: "white"
                    font.pixelSize: windowbackround.width / 55
                }
                ComboBox {
                    id: smoothspeed
                    width: windowbackround.width / 5
                    height: windowbackround.height / 15
                    font.pixelSize: windowbackround.width / 55
                    model: ["OFF", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
                    property bool initialized: true
                    onCurrentIndexChanged: {
                        Dashboard.setsmoothspeed(smoothspeed.currentIndex)
                    }
                    Component.onCompleted: {
                        Dashboard.setsmoothspeed(smoothspeed.currentIndex)
                    }
                    delegate: ItemDelegate {
                        width: smoothspeed.width
                        text: smoothspeed.textRole ? (Array.isArray(
                                                          control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
                        font.weight: smoothspeed.currentIndex == index ? Font.DemiBold : Font.Normal
                        font.family: smoothspeed.font.family
                        font.pixelSize: smoothspeed.font.pixelSize
                        highlighted: smoothspeed.highlightedIndex == index
                        hoverEnabled: smoothspeed.hoverEnabled
                    }
                }
                Switch {
                    id: loggerswitch
                    width: windowbackround.width / 5
                    height: windowbackround.height / 15
                    font.pixelSize: windowbackround.width / 55
                    text: qsTr("Data Logger")
                    Component.onCompleted: {
                        logger.datalogger()
                    }
                    onCheckedChanged: logger.datalogger()
                }

                Switch {
                    id: record
                    width: windowbackround.width / 5
                    height: windowbackround.height / 15
                    font.pixelSize: windowbackround.width / 55
                    text: qsTr("GoPro rec")
                    onCheckedChanged: {
                        transferSettings.sendSettings(), goproRec.rec()
                    }
                }
                Switch {
                    id: nmeaLog
                    width: windowbackround.width / 5
                    height: windowbackround.height / 15
                    font.pixelSize: windowbackround.width / 55
                    text: qsTr("NMEA Log.")
                    onCheckedChanged: {
                        Dashboard.setNMEAlog(nmeaLog.checked)
                    }
                    Component.onCompleted: tabView.currentIndex = 1 // opens the 2nd tab
                }
                Text {
                    text: " V 1.97t " + Dashboard.Platform
                    color: "white"
                    font.pixelSize: windowbackround.width / 55
                } //spacer
            }
            Grid {
                rows: 10
                columns: 1
                spacing: windowbackround.width / 150
                anchors.top: parent.top
                anchors.topMargin: parent.height / 20

                Text {
                    text: "     CAN Extender"
                    color: "white"
                    font.pixelSize: windowbackround.width / 55
                }
                Text {
                    text: "      base adress "
                    color: "white"
                    font.pixelSize: windowbackround.width / 55
                }
                Text {
                    text: "       (decimal) :"
                    color: "white"
                    font.pixelSize: windowbackround.width / 55
                }
                TextField {
                    id: baseadresstext
                    enabled: connectButton.enabled == false ? false : true
                    width: windowbackround.width / 5
                    height: windowbackround.height / 15
                    font.pixelSize: windowbackround.width / 55
                    validator: IntValidator {
                        bottom: 0
                        top: 4000
                    }
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    placeholderText: qsTr("1024")
                    onTextChanged: hexstring = baseadresstext.text
                }
                Text {
                    text: "      HEX: 0x" + (hexstring + 0x1000).toString(
                              16).substr(-3).toUpperCase()
                    color: "white"
                    font.pixelSize: windowbackround.width / 55
                }
                Text {
                    text: "     Shiftlight CAN"
                    color: "white"
                    font.pixelSize: windowbackround.width / 55
                }
                Text {
                    text: "      base adress "
                    color: "white"
                    font.pixelSize: windowbackround.width / 55
                }
                Text {
                    text: "       (decimal) :"
                    color: "white"
                    font.pixelSize: windowbackround.width / 55
                }
                TextField {
                    id: shiftlightbaseadresstext
                    enabled: connectButton.enabled == false ? false : true
                    width: windowbackround.width / 5
                    height: windowbackround.height / 15
                    font.pixelSize: windowbackround.width / 55
                    validator: IntValidator {
                        bottom: 0
                        top: 4000
                    }
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    placeholderText: qsTr("1024")
                    onTextChanged: hexstring2 = shiftlightbaseadresstext.text
                }
                Text {
                    text: "      HEX: 0x" + (hexstring2 + 0x1000).toString(
                              16).substr(-3).toUpperCase()
                    color: "white"
                    font.pixelSize: windowbackround.width / 55
                }
            }
        }

        Grid {
            visible: {
                (ecuSelect.currentIndex != "1") ? false : true
            }
            rows: 3
            columns: 4
            spacing: windowbackround.width / 150
            x: 350
            y: 290

            //  anchors.right: windowbackround.right
            //   anchors.bottom: windowbackround.bottom


            /*                  //Just a spacer for now still need to do it properly
            Text  { text: "";font.pixelSize: windowbackround.width / 55}
            Text  { text: "";font.pixelSize: windowbackround.width / 55}
            Text  { text: "";font.pixelSize: windowbackround.width / 55}
            Text  { text: "";font.pixelSize: windowbackround.width / 55}
            Text  { text: "";font.pixelSize: windowbackround.width / 55}
            Text  { text: "";font.pixelSize: windowbackround.width / 55}
            Text  { text: "";font.pixelSize: windowbackround.width / 55}
            Text  { text: "";font.pixelSize: windowbackround.width / 55}
            Text  { text: "";font.pixelSize: windowbackround.width / 55}
            Text  { text: "";font.pixelSize: windowbackround.width / 55}
            Text  { text: "";font.pixelSize: windowbackround.width / 55}
            Text  { text: "";font.pixelSize: windowbackround.width / 55}
            Text  { text: "";font.pixelSize: windowbackround.width / 55}
            Text  { text: "";font.pixelSize: windowbackround.width / 55}
            Text  { text: "";font.pixelSize: windowbackround.width / 55}
            Text  { text: "";font.pixelSize: windowbackround.width / 55}
            //Spacer end
*/
            Text {
                text: ""
                font.pixelSize: windowbackround.width / 55
            }
            Text {
                text: "0V"
                font.pixelSize: windowbackround.width / 55
            }
            Text {
                text: "5V"
                font.pixelSize: windowbackround.width / 55
            }
            Text {
                text: "Name"
                font.pixelSize: windowbackround.width / 55
            }
            Text {
                text: "    "
                font.pixelSize: windowbackround.width / 55
            }
            TextField {
                id: an1V0
                width: windowbackround.width / 10
                height: windowbackround.height / 15
                font.pixelSize: windowbackround.width / 55
                //validator: DoubleValidator {bottom: -1000.0; top: 1000.0;notation : DoubleValidator.StandardNotation ; decimals : 1}
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                placeholderText: qsTr("9")
            }
            TextField {
                id: an2V5
                width: windowbackround.width / 10
                height: windowbackround.height / 15
                font.pixelSize: windowbackround.width / 55
                // validator: DoubleValidator {bottom: -1000.0; top: 1000.0;notation : DoubleValidator.StandardNotation ; decimals : 1}
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                placeholderText: qsTr("16")
            }

            TextField {
                id: unitaux1
                width: windowbackround.width / 10
                height: windowbackround.height / 15
                font.pixelSize: windowbackround.width / 55
                placeholderText: qsTr("AFR")
            }
            Text {
                text: "AN1-2"
                font.pixelSize: windowbackround.width / 55
            }
            TextField {
                id: an3V0
                width: windowbackround.width / 10
                height: windowbackround.height / 15
                font.pixelSize: windowbackround.width / 55
                //validator: DoubleValidator {bottom: -1000.0; top: 1000.0;notation : DoubleValidator.StandardNotation ; decimals : 1}
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                placeholderText: qsTr("0")
            }
            TextField {
                id: an4V5
                width: windowbackround.width / 10
                height: windowbackround.height / 15
                font.pixelSize: windowbackround.width / 55
                //validator: DoubleValidator {bottom: -1000.0; top: 1000.0;notation : DoubleValidator.StandardNotation ; decimals : 1}
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                placeholderText: qsTr("5")
            }
            TextField {
                id: unitaux2
                width: windowbackround.width / 10
                height: windowbackround.height / 15
                font.pixelSize: windowbackround.width / 55
                placeholderText: qsTr("AFR")
            }
            Text {
                text: "AN3-4"
                font.pixelSize: windowbackround.width / 55
            }
        }
    }

    //Functions
    Item {
        //Function to automatically connect at Startup , function is called from COmbobox Serialname component.oncompleted
        id: autoconnect
        function auto() {
            // if (connectAtStart.checked == true) Connect.openConnection(serialName.currentText, ecuSelect.currentIndex, interfaceSelect.currentIndex, loggerSelect.currentIndex);
            if (connectButton.enabled == false)
                functconnect.connectfunc(), ecuSelect.enabled = false, disconnectButton.enabled = true
                //Connect.openConnection(serialName.currentText, ecuSelect.currentIndex, loggerSelect.currentIndex,logger.datalogger()),
        }
    }
    Item {
        //Function to connect and disconnect GPS
        id: autoconnectGPS
        function auto() {

            // if (gpsswitch.checked == true)GPS.startGPScom(serialNameGPS.currentText,serialGPSBaud.currentText);
            if (connectButtonGPS.enabled == false) {
                Gps.openConnection(serialNameGPS.currentText, "9600")
                disconnectButtonGPS.enabled = true
            }
            //if (connectButtonGPS.enabled == true)GPS.openConnection(serialNameGPS.currentText,"9600"),disconnectButtonGPS.enabled=false;
            //if (gpsswitch.checked == false)GPS.closeConnection(),console.log("GPS CLOSED BY QML");
        }
    }
    Item {
        id: changeweighttext
        function changetext() {
            if (unitSelect.currentIndex == 0)
                weighttext.text = "Weight kg"
            if (unitSelect.currentIndex == 1)
                weighttext.text = "Weight lbs"
        }
    }
    Item {

        //Function to transmit GoPro rec status on off
        id: goproRec

        property var recording: 0

        function rec() {
            if (record.checked == true)
                goproRec.recording = 1, GoPro.goprorec(recording.valueOf())
            if (record.checked == false)
                goproRec.recording = 0, GoPro.goprorec(recording.valueOf())
        }
    }
    Item {
        //Logger on off function
        id: logger
        property var loggeron: 0
        function datalogger() {
            if (loggerswitch.checked == true)
                logger.loggeron = 1, Logger.startLog(logfilenameSelect.text)
            if (loggerswitch.checked == false)
                logger.loggeron = 0, Logger.stopLog()
        }
    }
    Item {
        //Function to transmit GoPro variant and GoPro Password
        id: transferSettings
        function sendSettings() {
            GoPro.goProSettings(goProSelect.currentIndex, goPropass.text)
        }
    }
    Item {
        //function to Connect
        id: functconnect
        function connectfunc() {
            Connect.setOdometer(odometer.text)
            Connect.setWeight(weight.text)
            Connect.openConnection(serialName.currentText,
                                   ecuSelect.currentIndex, baseadresstext.text,
                                   shiftlightbaseadresstext.text)
            Apexi.calculatorAux(an1V0.text, an2V5.text, an3V0.text, an4V5.text,
                                unitaux1.text, unitaux2.text)
            connected = 1
        }
    }

    //function to Disconnect
    Item {

        id: functdisconnect
        function disconnectfunc() {
            Connect.closeConnection()
            connected = 0
        }
    }

    Item {
        //Function to play warning sound
        id: playwarning
        function start() {
            if (warnsound.playing == false)
                warnsound.play()
        }
    }
}
