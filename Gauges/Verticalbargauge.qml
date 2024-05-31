import QtQuick 2.8
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import "qrc:/Translator.js" as Translator
import Qt.labs.settings 1.0
Rectangle {
    id: gauge
    width: parent.width * 0.125//100
    height: parent.height * 0.17//80
    color: "transparent"
    antialiasing: false
    Drag.active: true

    property string information: "Bar gauge"
    property string gaugename
    property string mainvaluename
    property alias gaugetext: gaugetextfield.text
    property double gaugevalue: gauge1.value
    property double gaugeScaleOffset
    property double minvalue: gauge1.minimumValue
    property double maxvalue: gauge1.maximumValue
    property int decimalpoints
    property double warnvaluehigh: 20000
    property double warnvaluelow : -20000
    property double scaleValue: gaugeSettings.scaleValueStored
    property double offsetValueMultiply: gaugeSettings.offsetValueMultiplyStored
    property double offsetValueDivide: gaugeSettings.offsetValueDivideStored

    Settings{
        id: gaugeSettings
        property double scaleValueStored
        property double offsetValueMultiplyStored
        property double offsetValueDivideStored
    }

    Connections{
        target: Dashboard
        onDraggableChanged:togglemousearea()
    }

    onGaugevalueChanged: {
        console.log("Data Changed Scale Added: " + gaugeScaleOffset)
        console.log("Data Value Changed Scale Added: " + gaugevalue)
        if(scaleValue > 0 && offsetValueMultiply > 0){
            gaugeScaleOffset = (gaugevalue + scaleValue) * offsetValueMultiply
        }else if(scaleValue > 0 && offsetValueDivide > 0){
            gaugeScaleOffset = (gaugevalue + scaleValue) / offsetValueDivide
        }else if(offsetValueMultiply > 0 && scaleValue == 0){
            gaugeScaleOffset = gaugevalue * offsetValueMultiply
        }else if(offsetValueDivide > 0 && scaleValue == 0){
            gaugeScaleOffset = gaugevalue / offsetValueDivide
        }else if(scaleValue > 0 && offsetValueMultiply == 0){
            gaugeScaleOffset = gaugevalue + scaleValue
        }else{
            gaugeScaleOffset = gaugevalue
        }
    }

    Component.onCompleted: {
        console.log("Scale Value on completed: " + scaleValue + " " + gaugeSettings.scaleValueStored)
    }

    MouseArea {
        id: touchArea
        anchors.fill: parent
        drag.target: parent
        enabled: false
        onDoubleClicked: {
            popupmenu.popup(touchArea.mouseX, touchArea.mouseY);
        }
    }
    Gauge {
        id: gauge1
        height: parent.width * 0.42
        anchors.fill: parent
        anchors.margins: 10
        orientation : Qt.Horizontal
        minorTickmarkCount: 4
        //labelStepSize: 50
        minimumValue: minvalue
        maximumValue: maxvalue
        tickmarkStepSize : maximumValue / 4
        font.pixelSize: 15

        //value: Dashboard.MAP
        Behavior on value {
            NumberAnimation {
                duration: 5
            }
        }
        Text {
            id: gaugetextfield
            font.pixelSize: (parent.height / 3)
            anchors.top : parent.top
            font.bold: true
            font.family: "Eurostile"
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
            text : gaugeScaleOffset.toFixed(decimalpoints) + " " + gaugename
        }
        style: GaugeStyle {
            valueBar: Rectangle {
                implicitWidth:  20
                color: Qt.rgba(gaugeScaleOffset / gauge1.maximumValue, 0, 1 - gaugeScaleOffset / gauge1.maximumValue, 1)
            }
        }
    }

    Item {
        id: menustructure
        Menu {
            id: popupmenu
            MenuItem {
                text: Translator.translate("max value", Dashboard.language)
                font.pixelSize: 15
                onClicked: {
                    bargaugeMax.visible = true;
                    btnmaxValue.visible = true;
                }
            }
            MenuItem {
                text: Translator.translate("min value", Dashboard.language)
                font.pixelSize: 15
                onClicked:    {
                    txtBarMinValue.visible = true;
                    btnBarMinValue.visible = true;
                }
            }
            MenuItem {
                text: Translator.translate("Set decimal", Dashboard.language)
                font.pixelSize: 15
                onClicked:    {
                    cbx_decimalplaces.visible = true;
                    btndecimalplaces.visible = true;
                }
            }
            /*
            MenuItem {
                text: "Change warning max value"
                font.pixelSize: 15
                onClicked:    {
                    txtMaxValue.visible = true;
                    btnMaxValue.visible = true;
                }
            }
            MenuItem {
                text: "Change warning min value"
                font.pixelSize: 15
                onClicked:    {
                    btnminValue.visible = true;
                    bargaugeMin.visible = true;
                }
            }
            */
            MenuItem {
                text: Translator.translate("Change title", Dashboard.language)
                font.pixelSize: 15
                onClicked:    {
                    txtgaugenamechange.visible = true;
                    btngaugenamechange.visible = true;
                }
            }

            MenuItem{
                text: Translator.translate("Scale", Dashboard.language)
                font.pixelSize: 15
                onClicked: {
                    scaleMenu.visible = true;
                }
            }
            MenuItem{
                text: Translator.translate("Offset", Dashboard.language)
                font.pixelSize: 15
                onClicked: {
                    offsetMenu.visible = true;
                }
            }
            MenuItem {
                text: Translator.translate("remove gauge", Dashboard.language)
                font.pixelSize: 15
                onClicked: gauge.destroy()
            }
        }
    }
    // Settings submenues
    Item {
        id: maxValueSelect
        anchors.fill: parent
        TextField {
            id: txtMaxValue
            //width: 94
            //height: 40
            //inputMask: "00000"
            visible: false
            font.pixelSize: 12
            text: warnvaluehigh
            //inputMethodHints: Qt.ImhDigitsOnly
        }

        Button {
            id: btnMaxValue
            x: 119
            text: Translator.translate("OK", Dashboard.language)
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            visible: false
            onClicked: {
                hidemenues();
                warnvaluehigh = txtMaxValue.text;
            }
        }
    }
    Item {
        id: minValueSelect
        anchors.fill: parent

        TextField {
            id: txtBarMinValue
            //width: 94
            //height: 40
            font.pixelSize: 12
            visible: false
            text: minvalue;
        }
        Button {
            id: btnBarMinValue
            x: 119
            text: Translator.translate("OK", Dashboard.language)
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            visible: false
            onClicked: {
                hidemenues();
                minvalue = txtBarMinValue.text;
            }
        }
    }
    Item{
        id: decimalpointsval
        anchors.fill: parent
        ComboBox {
            id: cbx_decimalplaces
            visible: false
            model: ["0","1","2","3"]
        }
        Button {
            id: btndecimalplaces
            x: 119
            text: Translator.translate("OK", Dashboard.language)
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            visible: false
            onClicked: {
                hidemenues();
                decimalpoints = cbx_decimalplaces.currentIndex;
            }
        }
    }
    Item {
        id: bargaugeMinVal
        anchors.fill: parent

        TextField {
            id: bargaugeMin
            //width: 94
            //height: 40
            font.pixelSize: 12
            visible: false
            text: minvalue
        }

        Button {
            id: btnminValue
            x: 119
            text: Translator.translate("OK", Dashboard.language)
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            visible: false
            onClicked: {
                hidemenues();
                minvalue = bargaugeMin.text;
            }
        }
    }
    Item {
        id: bargaugeMaxVal
        anchors.fill: parent

        TextField {
            id: bargaugeMax
            //width: 94
            //height: 40
            visible: false
            font.pixelSize: 12
            text: maxvalue
        }

        Button {
            id: btnmaxValue
            x: 119
            text: Translator.translate("OK", Dashboard.language)
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            visible: false
            onClicked: {
                hidemenues();
                maxvalue = bargaugeMax.text;
            }
        }
    }
    Item {
        id: gaugenamechange
        anchors.fill: parent

        TextField {
            id: txtgaugenamechange
            //width: 94
            //height: 40
            font.pixelSize: 12
            visible: false
            text: gaugename
        }

        Button {
            id: btngaugenamechange
            x: 119
            text: Translator.translate("OK", Dashboard.language)
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            visible: false
            onClicked: {
                hidemenues();
                gaugename = txtgaugenamechange.text;
            }
        }
    }
    Item{
        id: scaleMenu
        anchors.fill: parent
        visible:false

        TextField{
            id: scaleNameChange
            font.pixelSize: 12
            text: scaleValue
            validator: DoubleValidator {bottom: 0; top: 999;}
        }
        Button{
            id: scaleNameChangeApply
            text: Translator.translate("Apply", Dashboard.language)
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.right: parent.right
            onClicked: {
                hidemenues();
                gaugeSettings.scaleValueStored = scaleNameChange.text
                scaleValue = scaleNameChange.text
                //gauge1.value += scaleValue
                console.log("Scale Value: " + scaleValue + " " + gaugeSettings.scaleValueStored)
            }
        }
        Button{
            id: resetScale
            text: Translator.translate("Reset Scale", Dashboard.language)
            anchors.top: scaleNameChangeApply.bottom
            anchors.topMargin: 2
            anchors.right: parent.right
            onClicked: {
                hidemenues();
                scaleValue = 0
                scaleNameChange.text = scaleValue
                //gauge1.value = scaleNameChange.text
                gaugeSettings.scaleValueStored = scaleNameChange.text
                console.log("Reset Scale Value: " + scaleValue)
            }
        }
    }

    Item{
        id: offsetMenu
        anchors.fill: parent
        visible:false

        TextField{
            id: offsetNameChange
            font.pixelSize: 12
            validator: DoubleValidator {bottom: 0; top: 999;}
        }
        Button{
            id: offsetNameChangeApplyMultiply
            text: Translator.translate("Multiply", Dashboard.language)
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.right: parent.right
            onClicked: {
                hidemenues();
                gaugeSettings.offsetValueMultiplyStored = offsetNameChange.text
                offsetValueMultiply = offsetNameChange.text
                console.log("Offset Multiply Value: " + offsetValueMultiply + " " + gaugeSettings.offsetValueDivideStored)
            }
        }
        Button{
            id: offsetNameChangeApplyDivide
            text: Translator.translate("Divide", Dashboard.language)
            anchors.top: offsetNameChangeApplyMultiply.bottom
            anchors.topMargin: 2
            anchors.right: parent.right
            onClicked: {
                hidemenues();
                gaugeSettings.offsetValueDivideStored = offsetNameChange.text
                offsetValueDivide = offsetNameChange.text
                console.log("Offset Divide Value: " + offsetValueDivide + " " + gaugeSettings.offsetValueDivideStored)
            }
        }
        Button{
            id: resetOffset
            text: Translator.translate("Reset Offset", Dashboard.language)
            anchors.top: offsetNameChangeApplyDivide.bottom
            anchors.topMargin: 2
            anchors.right: parent.right
            onClicked: {
                hidemenues();
                offsetNameChange.text = 0
                offsetValueMultiply = offsetNameChange.text
                offsetValueDivide = offsetNameChange.text
                gaugeSettings.offsetValueMultiplyStored = offsetNameChange.text
                gaugeSettings.offsetValueDivideStored = offsetNameChange.text
                console.log("Reset Offset Value: " + offsetValueMultiply + " " + offsetValueDivide)
            }
        }
    }

    //Functions
    function togglemousearea()
    {
        if (Dashboard.draggable === 1)
        {
            touchArea.enabled = true;
        }
        else
            touchArea.enabled = false;
    }
    function hidemenues()
    {
        cbx_decimalplaces.visible = false;
        btndecimalplaces.visible = false;
        bargaugeMax.visible = false;
        btnmaxValue.visible = false;
        btnminValue.visible = false;
        bargaugeMin.visible = false;
        txtMaxValue.visible = false;
        btnMaxValue.visible = false;
        txtBarMinValue.visible = false;
        btnBarMinValue.visible = false;
        txtgaugenamechange.visible = false;
        btngaugenamechange.visible = false;
        scaleMenu.visible = false;
        offsetMenu.visible = false;
    }
}
