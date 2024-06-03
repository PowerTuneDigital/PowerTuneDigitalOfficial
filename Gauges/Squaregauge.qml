import QtQuick 2.8
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import "qrc:/Translator.js" as Translator
import Qt.labs.settings 1.0
Rectangle {

    id: gauge
    width: parent.width * 0.3125
    height: parent.height * (200 / parent.height)
    property string information: "Square gauge"
    border.color: "#9f9f9f"
    border.width: 2
    Component.onCompleted: {set();        
    }

    property string mainvaluename
    property string secvaluename
    property alias title: gaugetextfield.text
    property alias mainunit: mainvalueunittextfield.text
    property alias vertgaugevisible: vertgauge.visible
    property alias horigaugevisible: horizgauge.visible
    property alias secvaluevisible: secondaryvaluetextfield.visible
    property alias secvalue  : placeholder2.text
    property alias mainvalue : placeholder.text
    property double maxvalue: vertgauge.maximumValue
    property alias titlecolor: titlebar.color
    property alias titlefontsize :gaugetextfield.font.pixelSize
    property alias mainfontsize :mainvaluetextfield.font.pixelSize
    property string resettitlecolor
    property string resetbackroundcolor
    property string framecolor
    property string titletextcolor
    property string textcolor
    property string barcolor
    property int decimalpoints
    property int decimalpoints2
    property double warnvaluehigh: 20000
    property double warnvaluelow : -20000
    property string textFonttype
    property string valueFonttype :"Verdana"
    property real peakval: 0

    //Variables for Offset and Scales
    property double gaugeScaleOffset
    property double scaleValue: gaugeSettings.scaleValueStored
    property double offsetValueMultiply: gaugeSettings.offsetValueMultiplyStored
    property double offsetValueDivide: gaugeSettings.offsetValueDivideStored

    //Settings to store the scales and offsets and keep them persistent through reboots
    Settings{
        id: gaugeSettings
        property double scaleValueStored
        property double offsetValueMultiplyStored
        property double offsetValueDivideStored
    }

    // Everytime the value changes do the maths with the Scale and Offset then change the text to read the new value
    // onMainvalueChanged: {
    //     console.log("Main Value Field: " + mainvalue)
    //     console.log("Gauge Scale Offset: " + gaugeScaleOffset)
    //     console.log(mainvaluetextfield.text)
    //     console.log("Scale Value: " + scaleValue)
    //     if(scaleValue > 0 && offsetValueMultiply > 0){
    //         gaugeScaleOffset = (mainvalue + scaleValue) * offsetValueMultiply
    //         mainvaluetextfield.text = gaugeScaleOffset.toFixed(decimalpoints)
    //     }else if(scaleValue > 0 && offsetValueDivide > 0){
    //         gaugeScaleOffset = (mainvalue + scaleValue) / offsetValueDivide
    //         mainvaluetextfield.text = gaugeScaleOffset.toFixed(decimalpoints)
    //     }else if(offsetValueMultiply > 0 && scaleValue == 0 && offsetValueDivide == 0){
    //         gaugeScaleOffset = mainvalue * offsetValueMultiply
    //         mainvaluetextfield.text = gaugeScaleOffset.toFixed(decimalpoints)
    //     }else if(offsetValueDivide > 0 && scaleValue == 0 && offsetValueMultiply == 0){
    //         gaugeScaleOffset = mainvalue / offsetValueDivide
    //         mainvaluetextfield.text = gaugeScaleOffset.toFixed(decimalpoints)
    //     }else if(scaleValue > 0 && offsetValueMultiply == 0 && offsetValueDivide == 0){
    //         gaugeScaleOffset = mainvalue + scaleValue
    //         mainvaluetextfield.text = gaugeScaleOffset.toFixed(decimalpoints)
    //     }else{
    //         gaugeScaleOffset = mainvalue
    //         mainvaluetextfield.text = gaugeScaleOffset.toFixed(decimalpoints)
    //     }
    // }

    Drag.active: true
    DatasourcesList{id: powertunedatasource}
/*
    //Intro
    SequentialAnimation {
        id: intro
        running: true
        onRunningChanged:{
        if (intro.running == false )gauge.value  = Qt.binding(function(){return Dashboard[mainvaluename]});
        }
        NumberAnimation {
            id :animation
            target: mainvaluetextfield
            property: "text"
            easing.type: Easing.InOutSine
            from: minvalue
            to: maxvalue
            duration: 500
        }
        NumberAnimation {
            id :animation1
            target: mainvaluetextfield
            property: "text"
            easing.type: Easing.InOutSine
            from: maxvalue
            to: minvalue
            duration: 500
        }
    }
    */
    Connections{
        target: Dashboard
        onDraggableChanged:togglemousearea()
    }

    Text {
        id : placeholder
        //onTextChanged: { toggledecimal();}
        //Component.onCompleted: {toggledecimal();}
        visible: false
    }
    Text {
        id : placeholder2
        //onTextChanged: { toggledecimal();}
        //Component.onCompleted: {toggledecimal();}
        visible: false
    }
    // MouseArea {
    //     id: touchArea
    //     anchors.fill: parent
    //     drag.target: parent
    //     enabled: false
    //     onDoubleClicked: {
    //         popupmenu.popup(touchArea.mouseX, touchArea.mouseY);
    //     }
    //     Component.onCompleted: {toggledecimal();
    //         toggledecimal2();
    //     }
    // }

    MouseArea {
        id: touchArea
        anchors.fill: parent
        drag.target: parent
        enabled: false
        onPressed:
        {
            touchCounter++;
            if (touchCounter == 1) {
                lastTouchTime = Date.now();
                timerDoubleClick.restart();
            } else if (touchCounter == 2) {
                var currentTime = Date.now();
                if (currentTime - lastTouchTime <= 500) { // Double-tap detected within 500 ms
                    console.log("Double-tap detected at", mouse.x, mouse.y);
                }
                touchCounter = 0;
                timerDoubleClick.stop();
                popupmenu.popup(touchArea.mouseX, touchArea.mouseY);
            }
        }
        Component.onCompleted: {toggledecimal();
            toggledecimal2();
        }
    }

    Timer {
        id: timerDoubleClick
        interval: 500
        running: false
        repeat: false
        onTriggered: {
            touchCounter = 0; // Reset counter if time interval exceeds 500 ms
        }
    }

    Rectangle {
        id: titlebar
        width: parent.width - 4
        height: parent.height / 4
        anchors.top : parent.top
        anchors.left: parent.left
        color: titlecolor
        clip: false
        visible: true
        anchors.topMargin: 2
        anchors.leftMargin: 2

    }

    SequentialAnimation {
        id: anim
        loops: Animation.Infinite
        running: false
        PropertyAnimation {
            target: titlebar
            property: "color"
            from: "darkred"
            to: "red"
            duration: 500
        }
        PropertyAnimation {
            target: titlebar
            property: "color"
            from: "red"
            to: "darkred"
            duration: 500
        }
    }
    SequentialAnimation {
        id: anim2
        loops: Animation.Infinite
        running: false
        PropertyAnimation {
            target: gauge
            property: "color"
            from: "darkred"
            to: "red"
            duration: 500
        }
        PropertyAnimation {
            target: gauge
            property: "color"
            from: "red"
            to: "darkred"
            duration: 500
        }
    }
    Text {
        id: gaugetextfield
        anchors.verticalCenter: titlebar.verticalCenter
        anchors.horizontalCenter: titlebar.horizontalCenter
        font.pixelSize: 23
        font.bold: true
        font.family: textFonttype
        color: titletextcolor
    }

    Text {
        id: mainvaluetextfield
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: parent.width * (50 / parent.width)
        font.family: valueFonttype
        color: "white"
        //text: gaugeScaleOffset
        onTextChanged: {
            warningindication.warn();
        }
    }

    Text {
        id: mainvalueunittextfield
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: mainvaluetextfield.font.pixelSize / 1.8 //28
        font.family: textFonttype
        font.bold: true
        color: textcolor
    }


    Text {
        id: secondaryvaluetextfield
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        height: parent.height * 0.2
        font.pixelSize: 28
        font.family: valueFonttype
        color: textcolor
    }

    Gauge {
        id: vertgauge
        height: parent.height - titlebar.height
        width: parent.width * 0.1
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 10
        orientation: Qt.Vertical
        minorTickmarkCount: 0
        tickmarkAlignment: Qt.AlignRight
        value: parent.mainvalue //gaugeScaleOffset
        maximumValue: parent.maxvalue

        style: GaugeStyle {
            tickmarkLabel: Text {
                font.pixelSize: 14
                color: "transparent"
            }
            tickmark: Item {
                implicitWidth: 18
                implicitHeight: 1

                Rectangle {
                    color: "transparent"
                    anchors.fill: parent
                    anchors.leftMargin: 3
                    anchors.rightMargin: 3
                }
            }
            valueBar: Rectangle {
                id: vertbar
                implicitWidth: vertgauge.width
                color: barcolor
            }
        }
    }

    Gauge {
        id: horizgauge
        height: parent.height * 0.2
        width: parent.width * 0.9
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        orientation: Qt.Horizontal
        minorTickmarkCount: 0
        tickmarkAlignment: Qt.AlignRight
        value: parent.mainvalue //gaugeScaleOffset
        maximumValue: parent.maxvalue

        style: GaugeStyle {

            tickmarkLabel: Text {
                font.pixelSize: 14
                color: "transparent"
            }
            tickmark: Item {
                implicitWidth: 18
                implicitHeight: 1

                Rectangle {
                    color: "transparent"
                    anchors.fill: parent
                    anchors.leftMargin: 3
                    anchors.rightMargin: 3
                }
            }
            valueBar: Rectangle {
                implicitWidth: horizgauge.height
                color: barcolor
            }
        }
    }
    Item {
        id: warningindication
        function warn()
        {

            if (mainvaluetextfield.text > warnvaluehigh || mainvaluetextfield.text < warnvaluelow )anim.running = true,anim2.running = true;
            else anim.running = false,anim2.running = false,titlebar.color = resettitlecolor ,gauge.color = resetbackroundcolor;
            if (mainvaluetextfield.text > peakval)peakval = mainvaluetextfield.text;
            //console.log (peakval);

        }
    }

    function set()
    {
        gauge.color = resetbackroundcolor;
        gauge.border.color = framecolor;
        gauge.titlecolor = resettitlecolor;
        gaugetextfield.color =  titletextcolor;
        secondaryvaluetextfield.color =  textcolor;
        mainvaluetextfield.color =  textcolor;
        mainvalueunittextfield.color =  textcolor;
        //vertgauge.valueBar.color = "green"
    }
    function togglemousearea()
    {
        if (Dashboard.draggable === 1)
        {
            touchArea.enabled = true;
            //    console.log ("Enable square touch");
        }
        else
            touchArea.enabled = false;
        //    console.log ("Disable square touch");
    }
    //
    function toggledecimal()
    {
        //console.log("Decimalpints loaded " + decimalpoints);
        if (decimalpoints < 4)
        {
             mainvaluetextfield.text = Qt.binding(function(){return Dashboard[mainvaluename].toFixed(decimalpoints)});
        }
        else
        {
            mainvaluetextfield.text = Qt.binding(function(){return Dashboard[mainvaluename]});
        vertgauge.value = 0;
        horizgauge.value = 0;
        }
    }
    function toggledecimal2()
    {
        //console.log("toggle sec decimal "+decimalpoints2)
        if (decimalpoints2 < 4)
        {
            secondaryvaluetextfield.text =  Qt.binding(function(){return Dashboard[secvaluename].toFixed(decimalpoints2)});
        }
        else
        {
            secondaryvaluetextfield.text = Qt.binding(function(){return Dashboard[secvaluename]});
        vertgauge.value = 0;
        horizgauge.value = 0;
        }

    }
    function hidemenues()
    {
        txtMaxValue.visible = false;
        btnMaxValue.visible = false;
        txtMinValue.visible = false;
        btnMinValue.visible = false;
        txtwidth.visible = false;
        txtheight.visible = false;
        btnSize.visible =false;
        cbx_titlefontsize.visible =false;
        btntitlefontsize.visible =false;
        cbx_gaugefontsize.visible =false;
        btngaugefontsize.visible =false;
        cbx_decimalplaces.visible  = false;
        cbx_decimalplaces2.visible  = false;
        btndecimalplaces.visible = false;
        cbx_titlefontstyle.visible =false;
        btn_titlefontstyle.visible = false;
        btn_valuefontstyle.visible = false;
        cbx_valuefontstyle.visible = false;
        //scaleMenu.visible = false;
        //offsetMenu.visible = false;
    }

    Item {
        id: menustructure

        Menu {
            id: popupmenu
            MenuItem {
                text: Translator.translate("Change gauge size", Dashboard.language)
                font.pixelSize: 15
                onClicked: sizemenu.popup(touchArea.mouseX, touchArea.mouseY)
            }
            MenuItem {
                text: Translator.translate("Text font size", Dashboard.language)
                font.pixelSize: 15
                onClicked:    {
                    cbx_titlefontsize.visible =true;
                    btntitlefontsize.visible =true;
                }
            }
            MenuItem {
                text: Translator.translate("Text font style", Dashboard.language)
                font.pixelSize: 15
                onClicked:    {
                    cbx_titlefontstyle.visible = true;
                    btn_titlefontstyle.visible = true;
                }
            }
            MenuItem {
                text: Translator.translate("Gauge font size", Dashboard.language)
                font.pixelSize: 15
                onClicked:
                {
                    btngaugefontsize.visible =true;
                    cbx_gaugefontsize.visible =true;
                }
            }
            MenuItem {
                text: Translator.translate("Gauge font style", Dashboard.language)
                font.pixelSize: 15
                onClicked:    {
                    btn_valuefontstyle.visible = true;
                    cbx_valuefontstyle.visible = true;
                }
            }
            MenuItem {
                text: Translator.translate("Change main value", Dashboard.language)
                font.pixelSize: 15
                onClicked: {
                    hidemenues();
                    cbxMain.visible = true;
                    btnMainSrc.visible = true;
                }
            }

            MenuItem {
                text: Translator.translate("Change sec value", Dashboard.language)
                font.pixelSize: 15
                onClicked: {
                    hidemenues();
                    cbxSecondary.visible = true;
                    btnSecSrc.visible = true;
                }
            }
            MenuItem {
                text: Translator.translate("Change title", Dashboard.language)
                font.pixelSize: 15
                onClicked: {
                    hidemenues();
                    titlenameValue.visible = true;
                    btntitleValue.visible = true;
                }
            }
            MenuItem {
                text: Translator.translate("Set decimal", Dashboard.language)
                font.pixelSize: 15
                onClicked: {
                    hidemenues();
                    cbx_decimalplaces.visible = true;
                    cbx_decimalplaces2.visible  = true;
                    btndecimalplaces.visible = true;
                }
            }
            MenuItem {
                text: Translator.translate("Set bar gauge max", Dashboard.language)
                font.pixelSize: 15
                onClicked: {
                    hidemenues();
                    bargaugeMax.visible = true;
                    btnmaxValue.visible = true;
                }
            }
            MenuItem {
                text: Translator.translate("Toggle sec value", Dashboard.language)
                font.pixelSize: 15
                onClicked: {
                    if(secondaryvaluetextfield.visible === true){
                        secondaryvaluetextfield.visible = false;
                    }
                    else{
                        secondaryvaluetextfield.visible = true;
                    }
                }
            }
            MenuItem {
                text: Translator.translate("Toggle vertical bar gauge", Dashboard.language)
                font.pixelSize: 15
                onClicked: {
                    if(vertgauge.visible === true){
                        vertgauge.visible = false;
                    }
                    else{
                        vertgauge.visible = true;
                        horizgauge.visible = false;

                    }
                }
            }

            MenuItem {
                text: Translator.translate("Toggle horizontal bar gauge", Dashboard.language)
                font.pixelSize: 15
                onClicked: {
                    if(horizgauge.visible === true){
                        horizgauge.visible = false;
                    }
                    else{
                        horizgauge.visible = true;
                        vertgauge.visible = false;
                    }
                }
            }

            MenuItem {
                text: Translator.translate("Set min warning", Dashboard.language)
                font.pixelSize: 15
                onClicked: {
                    hidemenues();
                    txtMinValue.visible = true;
                    btnMinValue.visible = true;
                }
            }

            MenuItem {
                text: Translator.translate("Set max warning", Dashboard.language)
                font.pixelSize: 15
                onClicked: {
                    hidemenues();
                    txtMaxValue.visible = true;
                    btnMaxValue.visible = true;
                }
            }
            MenuItem {
                text: Translator.translate("Change unit symbol", Dashboard.language)
                font.pixelSize: 15
                onClicked: symbolMenu.popup(touchArea.mouseX, touchArea.mouseY)
            }
            // MenuItem{
            //     text: Translator.translate("Scale", Dashboard.language)
            //     font.pixelSize: 15
            //     onClicked: {
            //         scaleMenu.visible = true;
            //     }
            // }
            // MenuItem{
            //     text: Translator.translate("Offset", Dashboard.language)
            //     font.pixelSize: 15
            //     onClicked: {
            //         offsetMenu.visible = true;
            //     }
            // }
            MenuItem {
                text: Translator.translate("remove gauge", Dashboard.language)
                font.pixelSize: 15
                onClicked: gauge.destroy()
            }
        }

        Menu {
            id: sizemenu
            MenuItem {
                text: Translator.translate("small", Dashboard.language)
                onClicked: {

                    gauge.width = 199;
                    gauge.height = 119;
                }
            }
            MenuItem {
                text: Translator.translate("medium", Dashboard.language)
                onClicked: {

                    gauge.width = 266;
                    gauge.height = 119;
                }
            }
            MenuItem {
                text: Translator.translate("large", Dashboard.language)
                onClicked: {

                    gauge.width = 533;
                    gauge.height = 119;
                }
            }
            MenuItem {
                text: Translator.translate("custom", Dashboard.language)
                onClicked: {
                    txtwidth.visible = true;
                    txtheight.visible = true;
                    btnSize.visible =true;
                }
            }

        }


        Menu {
            id: symbolMenu
            MenuItem {
                text: Translator.translate("None", Dashboard.language)
                onClicked: {
                    mainvalueunittextfield.text = ""
                }
            }
            MenuItem {
                text: "°"
                onClicked: {
                    mainvalueunittextfield.text = "°"
                }
            }
            MenuItem {
                text: "°C"
                onClicked: {
                    mainvalueunittextfield.text = "°C"
                }
            }
            MenuItem {
                text: "%"
                onClicked: {
                    mainvalueunittextfield.text = "%"
                }
            }
            MenuItem {
                text: "°F"
                onClicked: {
                    mainvalueunittextfield.text = "°F"
                }
            }
            MenuItem {
                text: "kPa"
                onClicked: {
                    mainvalueunittextfield.text = "kPa"
                }
            }
            MenuItem {
                text: "PSI"
                onClicked: {
                    mainvalueunittextfield.text = "PSI"
                }
            }
            MenuItem {
                text: "ms"
                onClicked: {
                    mainvalueunittextfield.text = "ms"
                }
            }
            MenuItem {
                text: "V"
                onClicked: {
                    mainvalueunittextfield.text = "V"
                }
            }
            MenuItem {
                text: "mV"
                onClicked: {
                    mainvalueunittextfield.text = "mV"
                }
            }
            MenuItem {
                text: "λ"
                onClicked: {
                    mainvalueunittextfield.text = "λ"
                }
            }
            MenuItem {
                text: "kph"
                onClicked: {
                    mainvalueunittextfield.text = "kph"
                }
            }
            MenuItem {
                text: "mph"
                onClicked: {
                    mainvalueunittextfield.text = "mph"
                }
            }
        }
    }
    Item {
        id: mainSourceSelector
        anchors.fill: parent


        ComboBox {
            id: cbxMain
            visible: false
            textRole: "titlename"
            model: powertunedatasource
            font.pixelSize: 12
            Component.onCompleted: {
                for(var i = 0; i < cbxMain.model.count; ++i)
                    if (powertunedatasource.get(i).sourcename === mainvaluename)
                        cbxMain.currentIndex = i

                if(gauge.width > 250){
                    cbxMain.width = 240
                }
            }
            delegate: ItemDelegate {
                width: cbxMain.width
                text: cbxMain.textRole ? (Array.isArray(cbxMain.model) ? modelData[cbxMain.textRole] : model[cbxMain.textRole]) : modelData
                font.weight: cbxMain.currentIndex === index ? Font.DemiBold : Font.Normal
                font.family: cbxMain.font.family
                font.pixelSize: cbxMain.font.pixelSize
                highlighted: cbxMain.highlightedIndex === index
                hoverEnabled: cbxMain.hoverEnabled
            }
        }
        Button {
            id: btnMainSrc
            x: 150
            visible: false
            text: Translator.translate("Apply", Dashboard.language)
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.left: cbxMain.right
            anchors.leftMargin: 2
            onClicked: {
                cbxMain.visible = false;
                btnMainSrc.visible = false;
                mainvaluename = powertunedatasource.get(cbxMain.currentIndex).sourcename;
                toggledecimal();
                //mainvalue = Qt.binding(function(){return Dashboard[powertunedatasource.get(cbxMain.currentIndex).sourcename]});
            }
        }

    }
    Item {
        id: secSourceSelector
        anchors.fill: parent


        ComboBox {
            id: cbxSecondary
            visible: false
            textRole: "titlename"
            model: powertunedatasource
            font.pixelSize: 12
            Component.onCompleted: {
                for(var i = 0; i < cbxSecondary.model.count; ++i)
                    if (powertunedatasource.get(i).sourcename === secvaluename)cbxSecondary.currentIndex = i

                if(gauge.width > 250){
                    cbxSecondary.width = 240
                }
            }
            delegate: ItemDelegate {
                width: cbxSecondary.width
                text: cbxSecondary.textRole ? (Array.isArray(cbxSecondary.model) ? modelData[cbxSecondary.textRole] : model[cbxSecondary.textRole]) : modelData
                font.weight: cbxSecondary.currentIndex === index ? Font.DemiBold : Font.Normal
                font.family: cbxSecondary.font.family
                font.pixelSize: cbxSecondary.font.pixelSize
                highlighted: cbxSecondary.highlightedIndex === index
                hoverEnabled: cbxSecondary.hoverEnabled
            }
        }
        Button {
            id: btnSecSrc
            x: 150
            visible: false
            text: Translator.translate("Apply", Dashboard.language)
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.left: cbxSecondary.right
            anchors.leftMargin: 2
            onClicked: {
                cbxSecondary.visible = false;
                btnSecSrc.visible = false;
                secvaluename = powertunedatasource.get(cbxSecondary.currentIndex).sourcename;
                toggledecimal2();
                //secvalue = Qt.binding(function(){return Dashboard[powertunedatasource.get(cbxSecondary.currentIndex).sourcename]});
            }
        }
    }
    Item {
        id: minValueSelect
        anchors.fill: parent

        TextField {
            id: txtMinValue
            width: 94
            height: 40
            visible: false
            text: warnvaluelow;
            Component.onCompleted: {
                if(gauge.width > 250){
                    txtMinValue.width = 180
                }
            }
        }
        Button {
            id: btnMinValue
            x: 119
            text: Translator.translate("OK", Dashboard.language)
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.left: txtMinValue.right
            anchors.leftMargin: 2
            visible: false
            onClicked: {
                hidemenues();
                warnvaluelow = txtMinValue.text;
            }
        }
    }
    Item {
        id: gaugeSizeselect
        anchors.fill: parent

        TextField {
            id: txtwidth
            width: 94
            height: 40
            visible: false
            text: gauge.width;
            font.pixelSize: 12
            Component.onCompleted: {
                if(gauge.width > 250){
                    txtwidth.width = 180
                }
            }
        }
        TextField {
            id: txtheight
            anchors.top : txtwidth.bottom
            width: 94
            height: 40
            visible: false
            text: gauge.height;
            font.pixelSize: 12
            Component.onCompleted: {
                if(gauge.width > 250){
                    txtheight.width = 180
                }
            }
        }
        Button {
            id: btnSize
            x: 119
            text: Translator.translate("OK", Dashboard.language)
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.left: txtwidth.right
            anchors.leftMargin: 2
            visible: false
            onClicked: {
                hidemenues();
                gauge.width = txtwidth.text;
                gauge.height = txtheight.text;
            }
        }
    }
    Item {
        id: decimalplacesSelect
        anchors.fill: parent

        ComboBox {
            id: cbx_decimalplaces
            visible: false
            width: 94
            model: ["0","1","2","3","N/A"]
            font.pixelSize: 12
            Component.onCompleted: {
                    for(var i = 0; i < 5; ++i)
                    if (cbx_decimalplaces.textAt(i) === decimalpoints.toString())
                    {
                        cbx_decimalplaces.currentIndex = i;
                    }

                    if(gauge.width > 250){
                        cbx_decimalplaces.width = 150
                    }

            }
        }

        ComboBox {
            id: cbx_decimalplaces2
            visible: false
            width: 94
            anchors.top: cbx_decimalplaces.bottom
            model: ["0","1","2","3","N/A"]
            font.pixelSize: 12
            Component.onCompleted: {
                    for(var i = 0; i < 5; ++i)
                    if (cbx_decimalplaces2.textAt(i) === decimalpoints2.toString())
                    {
                        cbx_decimalplaces2.currentIndex = i;
                    }

                    if(gauge.width > 250){
                        cbx_decimalplaces2.width = 150
                    }
            }
        }
        Button {
            id: btndecimalplaces
            x: 119
            text: Translator.translate("OK", Dashboard.language)
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.left: cbx_decimalplaces.right
            anchors.leftMargin: 2
            visible: false
            onClicked: {
                hidemenues();
                decimalpoints = cbx_decimalplaces.currentIndex;
                decimalpoints2 = cbx_decimalplaces2.currentIndex;
                toggledecimal();
                toggledecimal2();
            }
        }
    }
    Item {
        id: titlefontsizeSelect
        anchors.bottom: parent.top

        ComboBox {
            id: cbx_titlefontsize
            visible: false
            model: [10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,60,70,80,90,100,110,120,130,140,150,160,170,180,190,200,210,220,230,240,250,260]            
        }
        Button {
            id: btntitlefontsize
            x: 119
            text: Translator.translate("OK", Dashboard.language)
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.left: cbx_titlefontsize.right
            anchors.leftMargin: 0
            visible: false
            onClicked: {
                hidemenues();
                gaugetextfield.font.pixelSize = cbx_titlefontsize.textAt(cbx_titlefontsize.currentIndex);
            }
        }
        ComboBox{
            id: cbx_titlefontstyle
            width: btntitlefontsize.width
            model: Qt.fontFamilies()
            visible:false
            font.pixelSize: 15
            currentIndex: 1
            onCurrentIndexChanged: {textFonttype = cbx_titlefontstyle.textAt(cbx_titlefontstyle.currentIndex)
            }
            Component.onCompleted: {
                if(gauge.width > 250){
                    cbx_titlefontstyle.width = 180
                }
            }
            delegate:
                ItemDelegate {
                text: modelData
                width: cbx_titlefontstyle.width
                font.pixelSize: 15
                font.family: modelData
            }
        }
        Button {
            id: btn_titlefontstyle
            x: 119
            text: Translator.translate("OK", Dashboard.language)
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.left: cbx_titlefontstyle.right
            anchors.leftMargin: 0
            visible: false
            onClicked: {
                hidemenues();
                textFonttype = cbx_titlefontstyle.textAt(cbx_titlefontstyle.currentIndex);
            }
        }

        ComboBox{
            id: cbx_valuefontstyle
            width: btntitlefontsize.width
            model: Qt.fontFamilies()
            visible:false
            font.pixelSize: 15
            currentIndex: 1
            onCurrentIndexChanged: {valueFonttype = cbx_valuefontstyle.textAt(cbx_valuefontstyle.currentIndex)
            }
            Component.onCompleted: {
                if(gauge.width > 250){
                    cbx_valuefontstyle.width = 180
                }
            }
            delegate:
                ItemDelegate {
                text: modelData
                width: cbx_valuefontstyle.width
                font.pixelSize: 15
                font.family: modelData
            }
        }
        Button {
            id: btn_valuefontstyle
            x: 119
            text: Translator.translate("OK", Dashboard.language)
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.left: cbx_valuefontstyle.right
            anchors.leftMargin: 0
            visible: false
            onClicked: {
                hidemenues();
                valueFonttype = cbx_valuefontstyle.textAt(cbx_valuefontstyle.currentIndex);
            }
        }
    }

    Item {
        id: gaugefontsizeSelect
        anchors.fill: parent

        ComboBox {
            id: cbx_gaugefontsize
            visible: false
            model: [10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,60,70,80,90,100,110,120,130,140,150,160,170,180,190,200,210,220,230,240,250,260]
            font.pixelSize: 15
        }
        Button {
            id: btngaugefontsize
            x: 119
            text: Translator.translate("OK", Dashboard.language)
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.left: cbx_gaugefontsize.right
            anchors.leftMargin: 2
            visible: false
            onClicked: {
                hidemenues();
                mainvaluetextfield.font.pixelSize = cbx_gaugefontsize.textAt(cbx_gaugefontsize.currentIndex);
            }
        }
    }



    Item {
        id: maxValueSelect
        anchors.fill: parent

        TextField {
            id: txtMaxValue
            width: 94
            height: 40
            //inputMask: "00000"
            visible: false
            text: warnvaluehigh
            font.pixelSize: 15
            //inputMethodHints: Qt.ImhDigitsOnly

            Component.onCompleted: {
                if(gauge.width > 250){
                    txtMaxValue.width = 180
                }
            }
        }

        Button {
            id: btnMaxValue
            x: 119
            text: Translator.translate("OK", Dashboard.language)
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.left: txtMaxValue.right
            anchors.leftMargin: 2
            visible: false
            onClicked: {
                hidemenues();
                warnvaluehigh = txtMaxValue.text;
            }
        }
    }
    Item {
        id: titleRename
        anchors.fill: parent

        TextField {
            id: titlenameValue
            width: 94
            height: 40
            visible: false
            text: title
            font.pixelSize: 15
            Component.onCompleted: {
                if(gauge.width > 200){
                    titlenameValue.width = 240
                }
            }
        }


        Button {
            id: btntitleValue
            x: 119
            text: Translator.translate("OK", Dashboard.language)
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.left: titlenameValue.right
            anchors.leftMargin: 2
            visible: false
            onClicked: {
                hidemenues();
                title = titlenameValue.text;
                titlenameValue.visible = false;
                btntitleValue.visible = false;
            }
        }
    }
    Item {
        id: bargaugeMaxVal
        anchors.fill: parent

        TextField {
            id: bargaugeMax
            width: 94
            height: 40
            visible: false
            text: maxvalue
            font.pixelSize: 15
            Component.onCompleted: {
                if(gauge.width > 250){
                    bargaugeMax.width = 180
                }
            }
        }

        Button {
            id: btnmaxValue
            x: 119
            text: Translator.translate("OK", Dashboard.language)
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.left: bargaugeMax.right
            anchors.leftMargin: 2
            visible: false
            onClicked: {
                hidemenues();
                maxvalue = bargaugeMax.text;
                bargaugeMax.visible = false;
                btnmaxValue.visible = false;
            }
        }
    }
    //Scale and Offset Menus (Removed for now)
    // Item{
    //     id: scaleMenu
    //     anchors.fill: parent
    //     visible:false

    //     TextField{
    //         id: scaleNameChange
    //         font.pixelSize: 12
    //         text: scaleValue
    //         validator: DoubleValidator {bottom: 0; top: 999;}
    //     }
    //     Button{
    //         id: scaleNameChangeApply
    //         text: Translator.translate("Apply", Dashboard.language)
    //         anchors.top: parent.top
    //         anchors.topMargin: 0
    //         anchors.right: parent.right
    //         onClicked: {
    //             hidemenues();
    //             gaugeSettings.scaleValueStored = scaleNameChange.text
    //             scaleValue = scaleNameChange.text
    //             //gauge1.value += scaleValue
    //             console.log("Scale Value: " + scaleValue + " " + gaugeSettings.scaleValueStored)
    //         }
    //     }
    //     Button{
    //         id: resetScale
    //         text: Translator.translate("Reset Scale", Dashboard.language)
    //         anchors.top: scaleNameChangeApply.bottom
    //         anchors.topMargin: 2
    //         anchors.right: parent.right
    //         onClicked: {
    //             hidemenues();
    //             scaleValue = 0
    //             scaleNameChange.text = scaleValue
    //             //gauge1.value = scaleNameChange.text
    //             gaugeSettings.scaleValueStored = scaleNameChange.text
    //             console.log("Reset Scale Value: " + scaleValue)
    //         }
    //     }
    // }

    // Item{
    //     id: offsetMenu
    //     anchors.fill: parent
    //     visible:false

    //     TextField{
    //         id: offsetNameChange
    //         font.pixelSize: 12
    //         validator: DoubleValidator {bottom: 0; top: 999;}
    //     }
    //     Button{
    //         id: offsetNameChangeApplyMultiply
    //         text: Translator.translate("Multiply", Dashboard.language)
    //         anchors.top: parent.top
    //         anchors.topMargin: 0
    //         anchors.right: parent.right
    //         onClicked: {
    //             hidemenues();
    //             gaugeSettings.offsetValueMultiplyStored = offsetNameChange.text
    //             offsetValueMultiply = offsetNameChange.text
    //             console.log("Offset Multiply Value: " + offsetValueMultiply + " " + gaugeSettings.offsetValueDivideStored)
    //         }
    //     }
    //     Button{
    //         id: offsetNameChangeApplyDivide
    //         text: Translator.translate("Divide", Dashboard.language)
    //         anchors.top: offsetNameChangeApplyMultiply.bottom
    //         anchors.topMargin: 2
    //         anchors.right: parent.right
    //         onClicked: {
    //             hidemenues();
    //             gaugeSettings.offsetValueDivideStored = offsetNameChange.text
    //             offsetValueDivide = offsetNameChange.text
    //             console.log("Offset Divide Value: " + offsetValueDivide + " " + gaugeSettings.offsetValueDivideStored)
    //         }
    //     }
    //     Button{
    //         id: resetOffset
    //         text: Translator.translate("Reset Offset", Dashboard.language)
    //         anchors.top: offsetNameChangeApplyDivide.bottom
    //         anchors.topMargin: 2
    //         anchors.right: parent.right
    //         onClicked: {
    //             hidemenues();
    //             offsetNameChange.text = 0
    //             offsetValueMultiply = offsetNameChange.text
    //             offsetValueDivide = offsetNameChange.text
    //             gaugeSettings.offsetValueMultiplyStored = offsetNameChange.text
    //             gaugeSettings.offsetValueDivideStored = offsetNameChange.text
    //             console.log("Reset Offset Value: " + offsetValueMultiply + " " + offsetValueDivide)
    //         }
    //     }
    // }
}
