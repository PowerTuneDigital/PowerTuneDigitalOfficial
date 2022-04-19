import QtQuick 2.8
import QtQuick.Controls 2.1
import Qt.labs.settings 1.0

Rectangle {

    id: dashselector
    anchors.fill: parent
    color: "grey"

    Item {
        id: dashSettings
        Settings {

            property alias dashselect1: dash1.currentIndex
            property alias dashselect2: dash2.currentIndex
            property alias dashselect3: dash3.currentIndex
            property alias dashselect4: dash4.currentIndex
            property alias numberofdash: numberofdashes.currentIndex
        }
    }


    /*
        Rectangle{
            id: firstgrid
            width: 800
            height: 100
            color:"grey"



        }*/
    Grid {
        id: dashselectorgrid
        rows: 2
        columns: 1
        anchors.centerIn: parent

        // x: 100
        // y: 100
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
                addremovedashpage.adremove()
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

    Grid {
        id: dash1grid
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: dashselector.width / 60
        rows: 2
        columns: 1

        Text {
            text: "Dash1"
            font.pixelSize: dashselector.width / 55
        }

        ComboBox {
            id: dash1
            width: dashselector.width / 5
            height: dashselector.height / 15
            font.pixelSize: dashselector.width / 55
            model: ["Main Dash", "GPS", "Laptimer", "PowerFC Sensors", "User Dash 1", "User Dash 2", "User Dash 3", "G-Force", "Mediaplayer", "Screen Toggle", "Drag Timer"]
            //currentIndex: 1
            onCurrentIndexChanged: {
                select1.selDash1()
            }
            //Component.onCompleted: {select1.selDash1() }
            delegate: ItemDelegate {
                width: dash1.width
                text: dash1.textRole ? (Array.isArray(
                                            control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
                font.weight: dash1.currentIndex == index ? Font.DemiBold : Font.Normal
                font.family: dash1.font.family
                font.pixelSize: dash1.font.pixelSize
                highlighted: dash1.highlightedIndex == index
                hoverEnabled: dash1.hoverEnabled
            }
        }
    }
    Grid {
        id: dash2grid
        anchors.top: parent.top
        anchors.left: dash1grid.right
        anchors.margins: dashselector.width / 60
        rows: 2
        columns: 1
        Text {
            text: "Dash2"
            visible: Dashboard.Visibledashes > 1
            font.pixelSize: dashselector.width / 55
        }

        ComboBox {
            id: dash2
            width: dashselector.width / 5
            height: dashselector.height / 15
            font.pixelSize: dashselector.width / 55
            model: ["Main Dash", "GPS", "Laptimer", "PowerFC Sensors", "User Dash 1", "User Dash 2", "User Dash 3", "G-Force", "Mediaplayer", "Screen Toggle", "Drag Timer"]
            //currentIndex: 1
            //onCurrentIndexChanged:{select2.selDash2() }
            visible: Dashboard.Visibledashes > 1
            onCurrentIndexChanged: {
                if (dash2.visible == true) {
                    select2.selDash2()
                }
            }
            onVisibleChanged: {
                if (dash2.visible == true) {
                    select2.selDash2()
                }
            }
            delegate: ItemDelegate {
                width: dash2.width
                text: dash2.textRole ? (Array.isArray(
                                            control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
                font.weight: dash2.currentIndex == index ? Font.DemiBold : Font.Normal
                font.family: dash2.font.family
                font.pixelSize: dash2.font.pixelSize
                highlighted: dash2.highlightedIndex == index
                hoverEnabled: dash2.hoverEnabled
            }
        }
    }
    Grid {
        id: dash3grid
        anchors.top: parent.top
        anchors.left: dash2grid.right
        anchors.margins: dashselector.width / 60
        rows: 2
        columns: 1
        Text {
            text: "Dash3"
            visible: Dashboard.Visibledashes > 2
            font.pixelSize: dashselector.width / 55
        }
        ComboBox {
            id: dash3
            width: dashselector.width / 5
            height: dashselector.height / 15
            font.pixelSize: dashselector.width / 55
            model: ["Main Dash", "GPS", "Laptimer", "PowerFC Sensors", "User Dash 1", "User Dash 2", "User Dash 3", "G-Force", "Mediaplayer", "Screen Toggle", "Drag Timer"]
            visible: Dashboard.Visibledashes > 2
            onCurrentIndexChanged: {
                if (dash3.visible == true) {
                    select3.selDash3()
                }
            }
            onVisibleChanged: {
                if (dash3.visible == true) {
                    select3.selDash3()
                }
            }
            delegate: ItemDelegate {
                width: dash3.width
                text: dash3.textRole ? (Array.isArray(
                                            control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
                font.weight: dash3.currentIndex == index ? Font.DemiBold : Font.Normal
                font.family: dash3.font.family
                font.pixelSize: dash3.font.pixelSize
                highlighted: dash3.highlightedIndex == index
                hoverEnabled: dash3.hoverEnabled
            }
        }
    }
    Grid {
        id: dash4grid
        anchors.top: parent.top
        anchors.left: dash3grid.right
        anchors.margins: dashselector.width / 60
        rows: 2
        columns: 1
        Text {
            text: "Dash4"
            visible: Dashboard.Visibledashes > 3
            font.pixelSize: dashselector.width / 55
        }

        ComboBox {
            id: dash4
            width: dashselector.width / 5
            height: dashselector.height / 15
            font.pixelSize: dashselector.width / 55
            model: ["Main Dash", "GPS", "Laptimer", "PowerFC Sensors", "User Dash 1", "User Dash 2", "User Dash 3", "G-Force", "Mediaplayer", "Screen Toggle", "Drag Timer"]
            visible: Dashboard.Visibledashes > 3
            onCurrentIndexChanged: {
                if (dash4.visible == true) {
                    select4.selDash4()
                }
            }
            onVisibleChanged: {
                if (dash4.visible == true) {
                    select4.selDash4()
                }
            }
            delegate: ItemDelegate {
                width: dash4.width
                text: dash4.textRole ? (Array.isArray(
                                            control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
                font.weight: dash4.currentIndex == index ? Font.DemiBold : Font.Normal
                font.family: dash4.font.family
                font.pixelSize: dash4.font.pixelSize
                highlighted: dash4.highlightedIndex == index
                hoverEnabled: dash4.hoverEnabled
            }
        }

        Item {
            id: addremovedashpage
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
        }

        //Function to select Dash1
        Item {
            id: select1
            function selDash1() {
                if (dash1.currentIndex == "0") {
                    firstPageLoader.source = "qrc:/Gauges/Cluster.qml"
                }
                ;
                if (dash1.currentIndex == "1") {
                    firstPageLoader.source = "qrc:/Gauges/GPS.qml"
                }
                ;
                if (dash1.currentIndex == "2") {
                    firstPageLoader.source = "qrc:/GPSTracks/Laptimer.qml"
                }
                ;
                if (dash1.currentIndex == "3") {
                    firstPageLoader.source = "qrc:/Gauges/PFCSensors.qml"
                }
                ;
                if (dash1.currentIndex == "4") {
                    firstPageLoader.source = "qrc:/Gauges/Userdash1.qml"
                }
                ;
                if (dash1.currentIndex == "5") {
                    firstPageLoader.source = "qrc:/Gauges/Userdash2.qml"
                }
                ;
                if (dash1.currentIndex == "6") {
                    firstPageLoader.source = "qrc:/Gauges/Userdash3.qml"
                }
                ;
                if (dash1.currentIndex == "7") {
                    firstPageLoader.source = "qrc:/Gauges/ForceMeter.qml"
                }
                ;
                //if (dash1.currentIndex == "8") {firstPageLoader.source = "qrc:/Gauges/Dyno.qml"};
                if (dash1.currentIndex == "8") {
                    firstPageLoader.source = "qrc:/Gauges/Mediaplayer.qml"
                }
                ;
                if (dash1.currentIndex == "9") {
                    firstPageLoader.source = "qrc:/Gauges/Screentoggle.qml"
                }
                ;
                if (dash1.currentIndex == "10") {
                    firstPageLoader.source = "qrc:/Gauges/SpeedMeasurements.qml"
                }
                ;
            }
        }
        Item {
            id: select2
            function selDash2() {

                if (dash2.currentIndex == "0") {
                    secondPageLoader.source = "qrc:/Gauges/Cluster.qml"
                }
                ;
                if (dash2.currentIndex == "1") {
                    secondPageLoader.source = "qrc:/Gauges/GPS.qml"
                }
                ;
                if (dash2.currentIndex == "2") {
                    secondPageLoader.source = "qrc:/GPSTracks/Laptimer.qml"
                }
                ;
                if (dash2.currentIndex == "3") {
                    secondPageLoader.source = "qrc:/Gauges/PFCSensors.qml"
                }
                ;
                if (dash2.currentIndex == "4") {
                    secondPageLoader.source = "qrc:/Gauges/Userdash1.qml"
                }
                ;
                if (dash2.currentIndex == "5") {
                    secondPageLoader.source = "qrc:/Gauges/Userdash2.qml"
                }
                ;
                if (dash2.currentIndex == "6") {
                    secondPageLoader.source = "qrc:/Gauges/Userdash3.qml"
                }
                ;
                if (dash2.currentIndex == "7") {
                    secondPageLoader.source = "qrc:/Gauges/ForceMeter.qml"
                }
                ;
                //if (dash2.currentIndex == "8") {secondPageLoader.source = "qrc:/Gauges/Dyno.qml"};
                if (dash2.currentIndex == "8") {
                    secondPageLoader.source = "qrc:/Gauges/Mediaplayer.qml"
                }
                ;
                if (dash2.currentIndex == "9") {
                    secondPageLoader.source = "qrc:/Gauges/Screentoggle.qml"
                }
                ;
                if (dash2.currentIndex == "10") {
                    secondPageLoader.source = "qrc:/Gauges/SpeedMeasurements.qml"
                }
                ;
            }
        }
        Item {
            id: select3
            function selDash3() {
                if (dash3.currentIndex == "0") {
                    thirdPageLoader.source = "qrc:/Gauges/Cluster.qml"
                }
                ;
                if (dash3.currentIndex == "1") {
                    thirdPageLoader.source = "qrc:/Gauges/GPS.qml"
                }
                ;
                if (dash3.currentIndex == "2") {
                    thirdPageLoader.source = "qrc:/GPSTracks/Laptimer.qml"
                }
                ;
                if (dash3.currentIndex == "3") {
                    thirdPageLoader.source = "qrc:/Gauges/PFCSensors.qml"
                }
                ;
                if (dash3.currentIndex == "4") {
                    thirdPageLoader.source = "qrc:/Gauges/Userdash1.qml"
                }
                ;
                if (dash3.currentIndex == "5") {
                    thirdPageLoader.source = "qrc:/Gauges/Userdash2.qml"
                }
                ;
                if (dash3.currentIndex == "6") {
                    thirdPageLoader.source = "qrc:/Gauges/Userdash3.qml"
                }
                ;
                if (dash3.currentIndex == "7") {
                    thirdPageLoader.source = "qrc:/Gauges/ForceMeter.qml"
                }
                ;
                //if (dash3.currentIndex == "8") {thirdPageLoader.source = "qrc:/Gauges/Dyno.qml"};
                if (dash3.currentIndex == "8") {
                    thirdPageLoader.source = "qrc:/Gauges/Mediaplayer.qml"
                }
                ;
                if (dash3.currentIndex == "9") {
                    thirdPageLoader.source = "qrc:/Gauges/Screentoggle.qml"
                }
                ;
                if (dash3.currentIndex == "10") {
                    thirdPageLoader.source = "qrc:/Gauges/SpeedMeasurements.qml"
                }
                ;
            }
        }
        Item {
            id: select4
            function selDash4() {
                if (dash4.currentIndex == "0") {
                    fourthPageLoader.source = "qrc:/Gauges/Cluster.qml"
                }
                ;
                if (dash4.currentIndex == "1") {
                    fourthPageLoader.source = "qrc:/Gauges/GPS.qml"
                }
                ;
                if (dash4.currentIndex == "2") {
                    fourthPageLoader.source = "qrc:/GPSTracks/Laptimer.qml"
                }
                ;
                if (dash4.currentIndex == "3") {
                    fourthPageLoader.source = "qrc:/Gauges/PFCSensors.qml"
                }
                ;
                if (dash4.currentIndex == "4") {
                    fourthPageLoader.source = "qrc:/Gauges/Userdash1.qml"
                }
                ;
                if (dash4.currentIndex == "5") {
                    fourthPageLoader.source = "qrc:/Gauges/Userdash2.qml"
                }
                ;
                if (dash4.currentIndex == "6") {
                    fourthPageLoader.source = "qrc:/Gauges/Userdash3.qml"
                }
                ;
                if (dash4.currentIndex == "7") {
                    fourthPageLoader.source = "qrc:/Gauges/ForceMeter.qml"
                }
                ;
                //if (dash4.currentIndex == "8") {fourthPageLoader.source = "qrc:/Gauges/Dyno.qml"};
                if (dash4.currentIndex == "8") {
                    fourthPageLoader.source = "qrc:/Gauges/Mediaplayer.qml"
                }
                ;
                if (dash4.currentIndex == "9") {
                    fourthPageLoader.source = "qrc:/Gauges/Screentoggle.qml"
                }
                ;
                if (dash4.currentIndex == "10") {
                    fourthPageLoader.source = "qrc:/Gauges/SpeedMeasurements.qml"
                }
                ;
                "Main Dash","GPS", "Laptimer", "PowerFC Sensors","User Dash 1","User Dash 2","User Dash 3","G-Force","Mediaplayer","Screen Toggle","Drag Timer"
            }
            Component.onCompleted: tabView.currentIndex = 2 // opens the 3rd tab
        }
    }
}
