import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.0


Rectangle {
    id: measurements
    anchors.fill: parent
    color: "black"
    Component.onCompleted: units.start()
    //////////////////////////////
    Loader {
        id: rpmbarloader
        anchors.fill: measurements
        source: "qrc:/Gauges/RPMBarStyle1.qml"
    }

    //STAGING Lights
    Connections{
        target: Dashboard
        onSpeedChanged :{speedchange.start()}
    }
    Connections{
        target: Dashboard
        onSpeedunitsChanged :{units.start()}
    }

    Connections{
        target: Dashboard
        onReactiontimeChanged :{reactiontimecheck.start()}
    }


    property int measurementstarted : 0;
    property int startmeasurement : 0;
    property var sliptextcolor: "white";
    //Function
    Item {
        id: speedchange
        function start()
        {
        if (Dashboard.speed > 0 && startmeasurement === 1 &&measurementstarted === 0)
       {
        measurementstarted = 1;
        Calculations.stopreactiontimer();
        Calculations.startdragtimer();
        }
        }
    }

    Item {
        id: reactiontimecheck
        function start()
        {
           // console.log("Reactiontime changed")
        if (Dashboard.reactiontime < 0 )
       {
            //reactiotimertimetext.color = "red"
            //reactiotimertext.color = "red"
            redled.source = "qrc:/graphics/ledred.png"
        }
        }
    }

    Item {
        id: units
        function start()
        {
        if (Dashboard.speedunits === "metric")
        {
            hundred.text = "0-100 km/h TIME: "
            twohundred.text = "100-200 km/h TIME: "
            threehundred.text = "200-300 km/h TIME: "
        }
        else
        {
            hundred.text = "0-60 mph TIME: "
            twohundred.text = "60-120 mph TIME: "
            threehundred.text = "120-180 mph TIME: "

        }
        }
    }

Row{
    id: staginglight
    anchors.right: parent.right
    anchors.rightMargin: parent.width /15
    anchors.bottom: staginglights2.top
    anchors.topMargin: parent.height / 10
    spacing: 20
    Image {
        id : stagelight1
        height: 35
        width: 35
        source: "/graphics/ledoff.png"
        Component.onCompleted: {
            if(measurements.width == 1600){
                stagelight1.width = 60
                stagelight1.height = 60
            }
        }
    }
    Image {
        id : stagelight2
        height: 35
        width: 35
        source: "/graphics/ledoff.png"
        Component.onCompleted: {
            if(measurements.width == 1600){
                stagelight2.width = 60
                stagelight2.height = 60
            }
        }
    }
    }
            Column {
                id: staginglights2
                anchors.right: parent.right
                anchors.rightMargin: parent.width /15
                anchors.bottom: rpmbarloader.bottom
                anchors.bottomMargin: parent.width /150
                spacing: parent.width /200
                Image {
                    id : orangeled1
                    height: 35
                    width: 35
                    source: "/graphics/ledoff.png"
                    Component.onCompleted: {
                        if(measurements.width == 1600){
                            orangeled1.width = 60
                            orangeled1.height = 60
                        }
                    }
                }
                Image {
                    id : orangeled2
                    height: 35
                    width: 35
                    source: "/graphics/ledoff.png"
                    Component.onCompleted: {
                        if(measurements.width == 1600){
                            orangeled2.width = 60
                            orangeled2.height = 60
                        }
                    }
                }
                Image {
                    id : orangeled3
                    height: 35
                    width: 35
                    source: "/graphics/ledoff.png"
                    Component.onCompleted: {
                        if(measurements.width == 1600){
                            orangeled3.width = 60
                            orangeled3.height = 60
                        }
                    }
                }
                Image {
                    id : greenled
                    height: 35
                    width: 35
                    source: "/graphics/ledoff.png"
                    Component.onCompleted: {
                        if(measurements.width == 1600){
                            greenled.width = 60
                            greenled.height = 60
                        }
                    }
                }
                Image {
                    id : redled
                    height: 35
                    width: 35
                    source: "/graphics/ledoff.png"
                    Component.onCompleted: {
                        if(measurements.width == 1600){
                            redled.width = 60
                            redled.height = 60
                        }
                    }
                }
            }
    //////////////////////////////


    Grid {
        id:timegrid
        anchors.bottom: measurements.bottom
        anchors.topMargin: parent.height /20
        spacing: parent.width / 200
        rows: 9
        columns: 2

        Text {
            id:reactiotimertext
            text: "R/T : "
            font.pixelSize: measurements.width / 40
            color: sliptextcolor
            Component.onCompleted: {
                if(measurements.width == 1600){
                    reactiotimertext.font.pixelSize = 32
                }
            }
        }

        Text {
            id:reactiotimertimetext
            text: (Dashboard.reactiontime).toFixed(3)
            font.pixelSize: measurements.width / 40
            color: sliptextcolor
            Component.onCompleted: {
                if(measurements.width == 1600){
                    reactiotimertimetext.font.pixelSize = 32
                }
            }
        }
        Text {
            id:sixtyTimeText
            text: "60' TIME: "
            font.pixelSize: measurements.width / 40
            color: sliptextcolor
            Component.onCompleted: {
                if(measurements.width == 1600){
                    sixtyTimeText.font.pixelSize = 32
                }
            }
        }
        Text {
            id: sixtyTime
            text: (Dashboard.sixtyfoottime)
            font.pixelSize: measurements.width / 40
            color: sliptextcolor
            Component.onCompleted: {
                if(measurements.width == 1600){
                    sixtyTime.font.pixelSize = 32
                }
            }
        }
        Text {
            id: threeTimeText
            text: "330' TIME: "
            font.pixelSize: measurements.width / 40
            color: sliptextcolor
            Component.onCompleted: {
                if(measurements.width == 1600){
                    threeTimeText.font.pixelSize = 32
                }
            }
        }
        Text {
            id: threeTime
            text:  (Dashboard.threehundredthirtyfoottime)
            font.pixelSize: measurements.width / 40
            color: sliptextcolor
            Component.onCompleted: {
                if(measurements.width == 1600){
                    threeTime.font.pixelSize = 32
                }
            }
        }


        Text {
            id: eigthMileTimeText
            text: "1/8 MILE TIME: "
            font.pixelSize: measurements.width / 40
            color: sliptextcolor
            Component.onCompleted: {
                if(measurements.width == 1600){
                    eigthMileTimeText.font.pixelSize = 32
                }
            }
        }
        Text {
            id: eigthMileTime
            text: (Dashboard.eightmiletime)
            font.pixelSize: measurements.width / 40
            color: sliptextcolor
            Component.onCompleted: {
                if(measurements.width == 1600){
                    eigthMileTime.font.pixelSize = 32
                }
            }
        }
        Text {
            id: thousandTimeText
            text: "1000' TIME: "
            font.pixelSize: measurements.width / 40
            color: sliptextcolor
            Component.onCompleted: {
                if(measurements.width == 1600){
                    thousandTimeText.font.pixelSize = 32
                }
            }
        }

        Text {
            id: thousandTime
            text:  (Dashboard.thousandfoottime)
            font.pixelSize: measurements.width / 40
            color: sliptextcolor
            Component.onCompleted: {
                if(measurements.width == 1600){
                    thousandTime.font.pixelSize = 32
                }
            }
        }
        Text {
            id: quarterTimeText
            text: "1/4 TIME: "
            font.pixelSize: measurements.width / 40
            color: sliptextcolor
            Component.onCompleted: {
                if(measurements.width == 1600){
                    quarterTimeText.font.pixelSize = 32
                }
            }
        }
        Text {
            id: quarterTime
            text:  (Dashboard.quartermiletime)
            font.pixelSize: measurements.width / 40
            color: sliptextcolor
            Component.onCompleted: {
                if(measurements.width == 1600){
                    quarterTime.font.pixelSize = 32
                }
            }
        }
        Text {
            id : hundredTimeText
            text: "0-100 km/h TIME: "
            font.pixelSize: measurements.width / 40
            color: sliptextcolor
            Component.onCompleted: {
                if(measurements.width == 1600){
                    hundredTimeText.font.pixelSize = 32
                }
            }
        }
        Text {
            id: hundredTime
            text:  (Dashboard.zerotohundredt)
            font.pixelSize: measurements.width / 40
            color: sliptextcolor
            Component.onCompleted: {
                if(measurements.width == 1600){
                    hundredTime.font.pixelSize = 32
                }
            }
        }
        Text {
            id : twoHundredTimeText
            text:"100-200 km/h TIME: "
            font.pixelSize: measurements.width / 40
            color: sliptextcolor
            Component.onCompleted: {
                if(measurements.width == 1600){
                    twoHundredTimeText.font.pixelSize = 32
                }
            }
        }
        Text {
            id: twoHundredTime
            text:  (Dashboard.hundredtotwohundredtime)
            font.pixelSize: measurements.width / 40
            color: sliptextcolor
            Component.onCompleted: {
                if(measurements.width == 1600){
                    twoHundredTime.font.pixelSize = 32
                }
            }
        }
        Text {
            id : threeHundredTimeText
            text:"200-300 km/h TIME: "
            font.pixelSize: measurements.width / 40
            color: sliptextcolor
            Component.onCompleted: {
                if(measurements.width == 1600){
                    threeHundredTimeText.font.pixelSize = 32
                }
            }
        }
        Text {
            id: threeHundredTime
            text:  (Dashboard.twohundredtothreehundredtime)
            font.pixelSize: measurements.width / 40
            color: sliptextcolor
            Component.onCompleted: {
                if(measurements.width == 1600){
                    threeHundredTime.font.pixelSize = 32
                }
            }
        }
}

    Grid {
        id: centerGrid
        anchors.bottom: measurements.bottom
        anchors.bottomMargin: parent.height / 7
        anchors.left: timegrid.right
        anchors.leftMargin: parent.width /20
        anchors.topMargin: parent.height /20

        spacing: parent.width /200
        rows: 9
        columns: 2

        Component.onCompleted: {
            if(measurements.width == 1600){
                centerGrid.leftPadding = rpmbarloader.width * 0.1
            }
        }

        Text {
            id: sixtyTopSpeedText
            text: "60' TOP SPEED: "
            font.pixelSize: measurements.width / 40
            color: sliptextcolor
            Component.onCompleted: {
                if(measurements.width == 1600){
                    sixtyTopSpeedText.font.pixelSize = 32
                }
            }
        }
        Text {
            id: sixtyTopSpeed
            text: (Dashboard.sixtyfootspeed)
            font.pixelSize: measurements.width / 40
            color: sliptextcolor
            Component.onCompleted: {
                if(measurements.width == 1600){
                    sixtyTopSpeed.font.pixelSize = 32
                }
            }
        }
        Text {
            id: threeThirtySpeedText
            text: "330' TOP SPEED: "
            font.pixelSize: measurements.width / 40
            color: sliptextcolor
            Component.onCompleted: {
                if(measurements.width == 1600){
                    threeThirtySpeedText.font.pixelSize = 32
                }
            }
        }
        Text {
            id: threeThirtySpeed
            text: (Dashboard.threehundredthirtyfootspeed)
            font.pixelSize: measurements.width / 40
            color: sliptextcolor
            Component.onCompleted: {
                if(measurements.width == 1600){
                    threeThirtySpeed.font.pixelSize = 32
                }
            }
        }
        Text {
            id: eightMileTopText
            text: "1/8 MILE TOP SPEED: "
            font.pixelSize: measurements.width / 40
            color: sliptextcolor
            Component.onCompleted: {
                if(measurements.width == 1600){
                    eightMileTopText.font.pixelSize = 32
                }
            }
        }
        Text {
            id: eightMileTop
            text:  (Dashboard.eightmilespeed)
            font.pixelSize: measurements.width / 40
            color: sliptextcolor
            Component.onCompleted: {
                if(measurements.width == 1600){
                    eightMileTop.font.pixelSize = 32
                }
            }
        }
    Text {
        id: thousandTopSpeedText
        text: "1000' TOP SPEED: "
        font.pixelSize: measurements.width / 40
        color: sliptextcolor
        Component.onCompleted: {
            if(measurements.width == 1600){
                thousandTopSpeedText.font.pixelSize = 32
            }
        }
    }
    Text {
        id: thousandTopSpeed
        text:  (Dashboard.thousandfootspeed)
        font.pixelSize: measurements.width / 40
        color: sliptextcolor
        Component.onCompleted: {
            if(measurements.width == 1600){
                thousandTopSpeed.font.pixelSize = 32
            }
        }
    }
    Text {
        id: quarterTopSpeedText
        text: "1/4 TOP SPEED: "
        font.pixelSize: measurements.width / 40
        color: sliptextcolor
        Component.onCompleted: {
            if(measurements.width == 1600){
                quarterTopSpeedText.font.pixelSize = 32
            }
        }
    }
    Text {
        id: quarterTopSpeed
        text:  (Dashboard.quartermilespeed)
        font.pixelSize: measurements.width / 40
        color: sliptextcolor
        Component.onCompleted: {
            if(measurements.width == 1600){
                quarterTopSpeed.font.pixelSize = 32
            }
        }
    }



}
    Item {
        Timer {
            id: stagelight
            interval: 5000;
            running: false
            onTriggered: {
            startmeasurement = 1;
            stagelight1.source = "qrc:/graphics/ledoff.png"
            stagelight2 .source = "qrc:/graphics/ledoff.png"
            orangeled1.source = "qrc:/graphics/ledyellow.png"
            measurements.color = "#ffb366"
            sliptextcolor = "transparent"
            orange1.running = true
            }
        }
    }
    Item {
        Timer {
            id: orange1
            interval: 500;
            running: false
            onTriggered: {
            measurements.color = "#ffd966"
            sliptextcolor = "transparent"
            orange2.running = true
            orangeled1.source = "qrc:/graphics/ledoff.png"
            orangeled2.source = "qrc:/graphics/ledyellow.png"
            }
        }
    }
    Item {
        Timer {
            id: orange2
            interval: 500;
            running: false
            onTriggered: {
                orange3.running = true

                measurements.color = "yellow"
                sliptextcolor = "transparent"
                orangeled2.source = "qrc:/graphics/ledoff.png"
                orangeled3.source = "qrc:/graphics/ledyellow.png"
            }
        }
    }
    Item {
        Timer {
            id: orange3
            interval: 500;
            running: false
            onTriggered: {
                backroundcolortimer.running = true
                orangeled3.source = "qrc:/graphics/ledoff.png"
                greenled.source = "qrc:/graphics/ledgreen.png"
                measurements.color = "limegreen"
                sliptextcolor = "transparent"
                calculationtimer.running = true
                Calculations.startreactiontimer();
                Calculations.qmlrealtime();
            }
        }
    }
    Item {
        Timer {
            id: backroundcolortimer
            interval: 200;
            running: false
            onTriggered: {
                 measurements.color = "black"
                sliptextcolor = "white"
            }
        }
    }
    Item {
        Timer {
            id: calculationtimer
            interval: 3000;
            running: false
            onTriggered: {
               // Calculations.calculatereactiontime();
            }
        }
    }
    Button {
        id: trafficButton
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Start Staging Tree"
        width: measurements.width / 5
        height: measurements.height /10
        font.pixelSize: measurements.width / 55
        onClicked: {
            Dashboard.reactiontime = 0;
            Dashboard.sixtyfoottime = 0;
            Dashboard.sixtyfootspeed = 0;
            Dashboard.threehundredthirtyfoottime = 0;
            Dashboard.threehundredthirtyfootspeed = 0;
            Dashboard.eightmiletime = 0;
            Dashboard.eightmilespeed = 0;
            Dashboard.quartermiletime = 0;
            Dashboard.quartermilespeed = 0;
            Dashboard.eightmiletime = 0;
            Dashboard.eightmilespeed = 0;
            Dashboard.thousandfoottime = 0;
            Dashboard.thousandfootspeed = 0;
            Dashboard.zerotohundredt = 0;
            Dashboard.hundredtotwohundredtime = 0;
            Dashboard.twohundredtothreehundredtime = 0;
            Dashboard.reactiontime = 0;
        startmeasurement = 0;
        measurementstarted = 0;
        greenled.source = "qrc:/graphics/ledoff.png"
        redled.source = "qrc:/graphics/ledoff.png"
        stagelight1.source = "qrc:/graphics/ledyellow.png"
        stagelight2 .source = "qrc:/graphics/ledyellow.png"
        redled.source = "qrc:/graphics/ledoff.png"
        stagelight.running = true;
        measurements.color = "orange"
        sliptextcolor = "transparent"
        startmeasurement = 1;
        if (Dashboard.speed > 0)
        {
        stagelight.running = false;
        startmeasurement = 0;
        measurements.color = "red"
        sliptextcolor = "transparent"
        }
        }
    }

}
