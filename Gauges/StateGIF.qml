import QtQuick 2.5
import QtQuick.Controls 2.1
import "qrc:/Translator.js" as Translator
import QtQuick.Window 2.10 //compatibility with QT 5.10

Item {
    id: statepicture
    height: pictureheight
    width : pictureheight
    property string information: "State GIF"
    property string statepicturesourceoff
    property string statepicturesourceon
    property int pictureheight//: 480 * 0.25
    property int picturewidth//: 800 * 0.2
    property string increasedecreaseident
    property string mainvaluename
    property double triggervalue : 0
    property double triggeroffvalue : 0
    Drag.active: true
    DatasourcesList{id: powertunedatasource}
    Component.onCompleted: {togglemousearea();
                            bind();
                            }

    Connections{
        target: Dashboard
        onDraggableChanged: togglemousearea();
        onBackroundpicturesChanged: updatppiclist();
    }

     AnimatedImage {
        anchors.fill: parent
        id: statepictureoff
        playing : true
        fillMode: Image.PreserveAspectFit
        source:  statepicturesourceoff
        visible: true
    }
     AnimatedImage {
        anchors.fill: parent
        id: statepictureon
        playing : true
        fillMode: Image.PreserveAspectFit
        source:  statepicturesourceon
        visible: false
    }
    Text {
        id: mainvaluetextfield
        visible: false
        onTextChanged: {
            warningindication.warn();
        }
    }
    // MouseArea {
    //     id: touchArea
    //     anchors.fill: parent
    //     drag.target: parent
    //     enabled: false
    //     onDoubleClicked: {
    //         changesize.visible = true;
    //         Connect.readavailablebackrounds();
    //             changesize.x= -statepicture.x;
    //             changesize.y= -statepicture.y;
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
                changesize.visible = true;
                Connect.readavailablebackrounds();
                changesize.x= -statepicture.x;
                changesize.y= -statepicture.y;
            }
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

    Rectangle{
        id : changesize
        color: "darkgrey"
        visible: false
        width : 800 * 0.2875//230 Taking the resolution from the 7" and dividing it by (230/screenWidth)
        height : 480 * 0.7//320 Taking the resolution from the 7" and dividing it by (320/screenHeight)
        x: 0
        y: 0
        z: 200        //ensure the Menu is always in the foreground
        Drag.active: true
        onWidthChanged: {
            changesize.width = 800 * 0.2875
        }
        onHeightChanged: {
            changesize.height = 480 * 0.7
        }

        MouseArea {
            anchors.fill: parent
            drag.target: parent
            enabled: true
        }
        Grid { width: parent.width
            height:parent.height
            rows: 7
            columns: 1
            rowSpacing :5
            Grid {
                rows: 1
                columns: 3
                rowSpacing :5
                RoundButton{text: "-"
                    width: changesize.width /3.2
                    font.pixelSize: 800 * (15 / 800)
                    onPressAndHold: {timer.running = true;
                        increasedecreaseident = "decreasePicture"}
                    onReleased: {timer.running = false;}
                    onClicked: {pictureheight-- && picturewidth--}
                }
                Text{id: sizeTxt
                    text: "Image Size"
                    font.pixelSize: 800 * (15 / 800)
                    width: changesize.width /3.2
                    horizontalAlignment: Text.AlignHCenter
                    onTextChanged: {picturewidth+ "x" + pictureheight == sizeTxt.text}
                }
                RoundButton{ text: "+"
                    font.pixelSize: 800 * (15 / 800)
                    width: changesize.width /3.2
                    onPressAndHold: {timer.running = true;
                        increasedecreaseident = "increasePicture"}
                    onReleased: {timer.running = false;}
                    onClicked: {pictureheight++ && picturewidth++}
                }
            }
            Grid {
                id: valueGrid
                rows: 5
                columns: 2
                rowSpacing :5
            Text{
                text: Translator.translate("Image", Dashboard.language) + " " + Translator.translate("OFF", Dashboard.language)
                font.pixelSize: 800 * (12 / 800)
            }

            ComboBox {
                id: pictureSelectoroff
                //anchors.right: valueGrid
                width: 800 * 0.175 //140
                height: 480 * 0.083 //40
                font.pixelSize: 800 * (12 / 800)
                model: Dashboard.backroundpictures
                currentIndex: 0
                onCurrentIndexChanged: {
                    statepicturesourceoff = "file:///home/pi/Logo/" + pictureSelectoroff.textAt(pictureSelectoroff.currentIndex);
                    //statepicturesourceoff = "file:" + pictureSelectoroff.textAt(pictureSelectoroff.currentIndex); // windows
                    statepictureoff.source = statepicturesourceoff;
                                       }
                delegate: ItemDelegate {
                    width: pictureSelectoroff.width
                    text: pictureSelectoroff.textRole ? (Array.isArray(pictureSelectoroff.model) ? modelData[pictureSelectoroff.textRole] : model[pictureSelectoroff.textRole]) : modelData
                    font.weight: pictureSelectoroff.currentIndex === index ? Font.DemiBold : Font.Normal
                    font.family: pictureSelectoroff.font.family
                    font.pixelSize: pictureSelectoroff.font.pixelSize
                    highlighted: pictureSelectoroff.highlightedIndex === index
                    hoverEnabled: pictureSelectoroff.hoverEnabled
                }
            }
            Text{
                text: Translator.translate("Image", Dashboard.language) + " " + Translator.translate("ON", Dashboard.language)
                font.pixelSize: 800 * (12 / 800)
            }
            ComboBox {
                id: pictureSelectoron
                width: 800 * 0.175 //140
                height: 480 * 0.083 //40
                font.pixelSize: 800 * (12 / 800)
                model: Dashboard.backroundpictures
                currentIndex: 0
                onCurrentIndexChanged: {
                    statepicturesourceon = "file:///home/pi/Logo/" + pictureSelectoron.textAt(pictureSelectoron.currentIndex);
                    //statepicturesourceon = "file:" + pictureSelectoron.textAt(pictureSelectoron.currentIndex); // windows
                    statepictureon.source = statepicturesourceon;
                }


                delegate: ItemDelegate {
                    width: pictureSelectoron.width
                    text: pictureSelectoron.textRole ? (Array.isArray(pictureSelector.model) ? modelData[pictureSelector.textRole] : model[pictureSelector.textRole]) : modelData
                    font.weight: pictureSelectoron.currentIndex === index ? Font.DemiBold : Font.Normal
                    font.family: pictureSelectoron.font.family
                    font.pixelSize: pictureSelectoron.font.pixelSize
                    highlighted: pictureSelectoron.highlightedIndex === index
                    hoverEnabled: pictureSelectoron.hoverEnabled
                }
            }
            Text{
                text: Translator.translate("Source", Dashboard.language)
                font.pixelSize: 800 * (12 / 800)
            }
            ComboBox {
                id: cbxMain
                textRole: "titlename"
                model: powertunedatasource
                width: 800 * 0.175 //140
                height: 480 * 0.083 //40
                font.pixelSize: 800 * (12 / 800)
                Component.onCompleted: {for(var i = 0; i < cbxMain.model.count; ++i) if (powertunedatasource.get(i).sourcename === mainvaluename)cbxMain.currentIndex = i,bind()}
                onCurrentIndexChanged: bind();                
                delegate: ItemDelegate{
                    width: cbxMain.width
                    font.pixelSize: cbxMain.font.pixelSize
                    text: cbxMain.textRole ? (Array.isArray(cbxMain.model) ? modelData[cbxMain.textRole] : model[cbxMain.textRole]) : modelData
                    font.weight: cbxMain.currentIndex === index ? Font.DemiBold : Font.Normal
                    font.family: cbxMain.font.family
                    highlighted: cbxMain.highlightedIndex === index
                    hoverEnabled: cbxMain.hoverEnabled
                }
            }
            Text{
                text: Translator.translate("Trigger", Dashboard.language)
                font.pixelSize: 800 * (12 / 800)
            }
            TextField {
                id: triggeronvalue
                width: 800 * 0.175 //140
                height: 480 * 0.083 //40
                text: triggervalue
                onTextChanged: triggerofffColor();
                font.pixelSize: 800 * (12 / 800)
            }
         Text{
                text: Translator.translate("Trigger", Dashboard.language) +" " +Translator.translate("OFF", Dashboard.language)
                font.pixelSize: 800 * (12 / 800)
            }
            TextField {
                id: triggerofffvalue
                width: 800 * 0.175 //140
                height: 480 * 0.083 //40
                text: triggeroffvalue
                onTextChanged: triggerofffColor();
                font.pixelSize: 800 * (12 / 800)
            }

            }
            RoundButton{
                width: parent.width
                text: Translator.translate("Delete image", Dashboard.language)
                font.pixelSize: 800 * (15 / 800)
                onClicked: statepicture.destroy();
            }
            RoundButton{
                width: parent.width
                text: Translator.translate("Close", Dashboard.language)
                onClicked: {
                    triggervalue = triggeronvalue.text;
                    triggeroffvalue = triggerofffvalue.text;
                    mainvaluename = powertunedatasource.get(cbxMain.currentIndex).sourcename;
                    changesize.visible = false;
            }
                }
        }
    }

    Item {
        Timer {
            id: timer
            interval: 50; running: false; repeat: true
            onTriggered: {increaseDecrease()}
        }

        Text { id: time }
    }
    Item {
        id: warningindication
        function warn()
        {
           if(triggeroffvalue <= triggervalue){
			    if (mainvaluetextfield.text >= triggervalue ){statepictureoff.visible = false,statepictureon.visible = true}
			    if (mainvaluetextfield.text < triggervalue ){statepictureoff.visible = true,statepictureon.visible = false}
		    }else { 
			    if(mainvaluetextfield.text >= triggervalue && mainvaluetextfield.text <= triggeroffvalue){statepictureoff.visible = false,statepictureon.visible = true}
			    else{statepictureoff.visible = true,statepictureon.visible = false}
		    }
        }
    }

function triggerofffColor()
    {
	    triggervalue = triggeronvalue.text;
            triggeroffvalue = triggerofffvalue.text;
                 
	    if (triggervalue >= triggeroffvalue)
	    {

		    triggerofffvalue.background.color = "grey";
	    }
	    else
	    {
		    triggerofffvalue.background.color = "white";
	    }
    }
    function togglemousearea()
    {
    //    //console.log("toggle" + Dashboard.draggable);
        if (Dashboard.draggable === 1)
        {
            touchArea.enabled = true;
        }
        else
            touchArea.enabled = false;
    }
    function increaseDecrease()
    {
        ////console.log("ident "+ increasedecreaseident);
        switch(increasedecreaseident)
        {

        case "increasePicture": {
            pictureheight++;
            picturewidth++;
            break;
        }
        case "decreasePicture": {
            pictureheight--;
            picturewidth--;
            break;
        }
        }
    }
    function bind()
    {
        mainvaluetextfield.text = Qt.binding(function(){return Dashboard[mainvaluename]});
    }

    // These functions update the Picture sources in the ComboBoxes
    function updatppiclist()
    {
                    for(var i = 0; i < pictureSelectoron.count; ++i) //
                    if (statepicturesourceon === "file:///home/pi/Logo/" + pictureSelectoron.textAt(i))
                    pictureSelectoron.currentIndex = i
                    updatppiclistoff()
    }
    function updatppiclistoff()
    {
                    for(var i = 0; i < pictureSelectoroff.count; ++i) //
                    if (statepicturesourceoff === "file:///home/pi/Logo/" + pictureSelectoroff.textAt(i))
                    pictureSelectoroff.currentIndex = i
    }
}
