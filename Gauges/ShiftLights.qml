import QtQuick 2.8



Item {
    id: shiftlightssetting
    width:parent.width * 0.75
    height:parent.height * 0.75
    //Setting Position to align with the RPM 1 Bar
    x: parent.width * 0.33
    property  int rpmwarn1: Dashboard.rpmStage1
    property  int rpmwarn2: Dashboard.rpmStage2
    property  int rpmwarn3: Dashboard.rpmStage3
    property  int rpmwarn4: Dashboard.rpmStage4
    Connections{
        target: Dashboard
        onRpmStage1Changed :rpmwarn1 = Dashboard.rpmStage1
        onRpmStage2Changed :rpmwarn2 = Dashboard.rpmStage2
        onRpmStage3Changed :rpmwarn3 = Dashboard.rpmStage3
        onRpmStage4Changed :rpmwarn4 = Dashboard.rpmStage4
        onRpmChanged: {
            if (Dashboard.rpm > rpmwarn1) {led1.source = "qrc:/graphics/ledgreen.png",led8.source = "qrc:/graphics/ledgreen.png"};
            if (Dashboard.rpm > rpmwarn2) {led2.source = "qrc:/graphics/ledgreen.png",led7.source = "qrc:/graphics/ledgreen.png"};
            if (Dashboard.rpm > rpmwarn3) {led3.source = "qrc:/graphics/ledyellow.png",led6.source = "qrc:/graphics/ledyellow.png"};
            if (Dashboard.rpm > rpmwarn4) {led4.source = "qrc:/graphics/ledred.png",led5.source = "qrc:/graphics/ledred.png"};
            if (Dashboard.rpm < rpmwarn1) {led1.source = "qrc:/graphics/ledoff.png",led8.source = "qrc:/graphics/ledoff.png"};
            if (Dashboard.rpm < rpmwarn2) {led2.source = "qrc:/graphics/ledoff.png",led7.source = "qrc:/graphics/ledoff.png"};
            if (Dashboard.rpm < rpmwarn3) {led3.source = "qrc:/graphics/ledoff.png",led6.source = "qrc:/graphics/ledoff.png"};
            if (Dashboard.rpm < rpmwarn4) {led4.source = "qrc:/graphics/ledoff.png",led5.source = "qrc:/graphics/ledoff.png"};
        }

    }

        Row {
            spacing: parent.width / 40
            topPadding: 3
            Image {
                id : led1
                height: shiftlightssetting.width * 0.043 //shiftlightssetting.width/22.85
                width: shiftlightssetting.width * 0.043 //35
                source: "/graphics/ledoff.png"
            }
            Image {
                id : led2
                height: shiftlightssetting.width * 0.043
                width: shiftlightssetting.width * 0.043
                source: "/graphics/ledoff.png"
            }
            Image {
                id : led3
                height: shiftlightssetting.width * 0.043
                width: shiftlightssetting.width * 0.043
                source: "/graphics/ledoff.png"
            }
            Image {
                id : led4
                height: shiftlightssetting.width * 0.043
                width: shiftlightssetting.width * 0.043
                source: "/graphics/ledoff.png"
            }
            Image {
                id : led5
                height: shiftlightssetting.width * 0.043
                width: shiftlightssetting.width * 0.043
                source: "/graphics/ledoff.png"
            }
            Image {
                id : led6
                height: shiftlightssetting.width * 0.043
                width: shiftlightssetting.width * 0.043
                source: "/graphics/ledoff.png"
            }
            Image {
                id : led7
                height: shiftlightssetting.width * 0.043
                width: shiftlightssetting.width * 0.043
                source: "/graphics/ledoff.png"
            }
            Image {
                id : led8
                height: shiftlightssetting.width * 0.043
                width: shiftlightssetting.width * 0.043
                source: "/graphics/ledoff.png"
            }

        }
    }

