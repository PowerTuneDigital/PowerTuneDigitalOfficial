import QtQuick 2.8
import QtQuick.Controls 2.1
import Qt.labs.settings 1.0

Rectangle {

    id: dashselector
    anchors.fill: parent
    color: "grey"

    Settings {
        property alias dashselect1: dash1.currentIndex
        property alias dashselect2: dash2.currentIndex
        property alias dashselect3: dash3.currentIndex
        property alias dashselect4: dash4.currentIndex
        property alias numberofdash: numberofdashes.currentIndex
    }

    function getDashByIndex(index) {
        switch (index) {
        case 0:
        {
            return "qrc:/Gauges/Cluster.qml"
        }
        case 1:
        {
            return "qrc:/Gauges/GPS.qml"
        }
        case 2:
        {
            return "qrc:/GPSTracks/Laptimer.qml"
        }
        case 3:
        {
            return "qrc:/Gauges/PFCSensors.qml"
        }
        case 4:
        {
            return "qrc:/Gauges/Userdash1.qml"
        }
        case 5:
        {
            return "qrc:/Gauges/Userdash2.qml"
        }
        case 6:
        {
            return "qrc:/Gauges/Userdash3.qml"
        }
        case 7:
        {
            return "qrc:/Gauges/ForceMeter.qml"
        }
        case 8:
        {
            return "qrc:/Gauges/Mediaplayer.qml"
        }
        case 9:
        {
            return "qrc:/Gauges/Screentoggle.qml"
        }
        case 10:
        {
            return "qrc:/Gauges/SpeedMeasurements.qml"
        }
        }
    }

    function adremove() {
        //Setting amount of Active Dashes loaded
        Dashboard.Visibledashes = numberofdashes.currentIndex + 1

        while (dashView.count > numberofdashes.currentIndex + 2) {
            dashView.takeItem(dashView.count - 2)
            //console.log("removing", dashView.count -2)
        }

        //Adding Dashes back
        while (dashView.count < numberofdashes.currentIndex + 2) {
            // console.log("We have currently ", dashView.count)
            switch (dashView.count) {
            case 2:
            {
                dashView.insertItem(1, secondPageLoader)
                // console.log("add second page")
                break
            }
            case 3:
            {
                dashView.insertItem(2, thirdPageLoader)
                //console.log("add 3rd page", dashView.count)
                break
            }
            case 4:
            {
                dashView.insertItem(3, fourthPageLoader)
                // console.log("add 4th page", dashView.count)
                break
            }
            }
        }
    }

    Grid {
        id: dashselectorgrid
        rows: 2
        columns: 1
        anchors.centerIn: parent
        Text {
            text: "Active Dashboards"

            font.pixelSize: dashselector.width / 55
        }

        ComboBox {
            id: numberofdashes

            width: dashselector.width / 5
            height: dashselector.height / 15
            font.pixelSize: dashselector.width / 55
            model: ["1", "2", "3", "4"]
            currentIndex: -1
            onCurrentIndexChanged: {
                adremove()
                AppSettings.writeSelectedDashSettings(numberofdashes.currentIndex + 1)
            }

            delegate: ItemDelegate {
                width: numberofdashes.width
                text: numberofdashes.textRole ? (Array.isArray(
                                                     control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
                font.weight: numberofdashes.currentIndex == index ? Font.DemiBold : Font.Normal
                font.family: numberofdashes.font.family
                font.pixelSize: numberofdashes.font.pixelSize
                highlighted: numberofdashes.highlightedIndex == index
                hoverEnabled: numberofdashes.hoverEnabled
            }
        }
    }

    DashSelectorWidget {
        id: dash1
        anchors.left: parent.left
        index: 1
        linkedLoader: firstPageLoader
    }
    DashSelectorWidget {
        id: dash2
        anchors.left: dash1.right
        index: 2
        linkedLoader: secondPageLoader
    }
    DashSelectorWidget {
        id: dash3
        anchors.left: dash2.right
        index: 3
        linkedLoader: thirdPageLoader
    }
    DashSelectorWidget {
        id: dash4
        anchors.left: dash3.right
        index: 4
        linkedLoader: fourthPageLoader
        Component.onCompleted: tabView.currentIndex = 0 //switch back to main tab
    }
}
