import QtQuick 2.8
import QtQuick.Controls 2.1
import Qt.labs.settings 1.0

Rectangle {
    id: backround1
    anchors.fill: parent
    Loader {
        anchors.fill: backround1
        id: pageLoader
    }

    function loadersource() {
        //console.log(Dashboard.ecu)
        if (Dashboard.ecu == "0") {
            pageLoader.source = "qrc:/AnalogInputs.qml"
            //pageLoader.source ="qrc:/ExBoardAnalog.qml"
            regtab.title = "Analog"
        }
        if (Dashboard.ecu == "1") {
            pageLoader.source = "qrc:/AnalogInputs.qml"
            //pageLoader.source ="qrc:/ExBoardAnalog.qml"
            regtab.title = "Analog"
        }
        if (Dashboard.ecu == "2") {
            pageLoader.source = "qrc:/ConsultRegs.qml"
            regtab.title = "Consult"
        }
        if (Dashboard.ecu == "3") {
            pageLoader.source = "qrc:/OBDPIDS.qml"
            regtab.title = "OBD"
        }
        else pageLoader.source = "qrc:/AnalogInputs.qml",regtab.title = "Analog";
    }
    Component.onCompleted: {
        loadersource()
        tabView.currentIndex++
    }
    Connections {
        target: Dashboard
        onEcuChanged: {
            loadersource()
        }
    }
}
