import QtQuick 2.8
import QtQuick.Controls 2.1
import Qt.labs.settings 1.0

Rectangle {
    id: backround1
    anchors.fill: parent
    Loader {
        anchors.fill: backround1
        id: pageLoader
        Component.onCompleted: {
            loadersource();
        }
    }

    function loadersource() {
        if (Dashboard.ecu == "0") {
            pageLoader.source = "qrc:/AnalogInputs.qml"
        }
        if (Dashboard.ecu == "1") {
            console.log("Loadersource changing")
            pageLoader.source = "qrc:/AnalogInputs.qml"
        }
        if (Dashboard.ecu == "2") {
            console.log("Loadersource changing")
            pageLoader.source = "qrc:/ConsultRegs.qml"
        }
        if (Dashboard.ecu == "3") {
            console.log("Loadersource changing")
            pageLoader.source = "qrc:/OBDPIDS.qml"
        }
        if (Dashboard.ecu == "4") {
            pageLoader.source = "qrc:/OBDPIDS.qml"
        }
    }

    Connections {
        target: Dashboard
        onEcuChanged: {
            //console.log("Loadersource changing")
            loadersource()

        }
    }
}
