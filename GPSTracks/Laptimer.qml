import QtQuick 2.9
import QtLocation 5.9
import QtPositioning 5.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.0
import QtQuick.XmlListModel 2.0
import IMD 1.0





Rectangle {
    id: mapItem
    anchors.fill: parent
    color: "black"
//Timer is inacurate for real timing therefore we use some Javascript to measure time and update the frontend with the measured time via Timer
    property double startTime: 0
    property int msecondsElapsed: 0

    property real  linex1;
    property real  liney1;
    property real  linex2;
    property real  liney2;

    function restartCounter()  {
        mapItem.startTime = 0;
    }


    function timeChanged()  {
        if(mapItem.startTime==0)
        {
            mapItem.startTime = new Date().getTime(); //returns the number of milliseconds since the epoch (1970-01-01T00:00:00Z);
        }
        var currentTime = new Date().getTime();
        mapItem.msecondsElapsed = (currentTime-startTime)/100;
    }


    Timer  {
        id: elapsedTimer
        interval: 100;
        running: false;
        repeat: true;
        onTriggered: {
            mapItem.timeChanged()
            time.text = new Date(mapItem.msecondsElapsed*100).toLocaleTimeString(Qt.locale(),"mm" + ":" + "ss" + "." + "zzz")
        }
    }


    Connections{
        target: Dashboard
        onGpsLatitudeChanged : {pos.poschanged()}
        onGpsLongitudeChanged : {pos.poschanged()}
        onCurrentLapChanged :{
            if (Dashboard.currentLap > 1)
            {
                laptimeModel.append({"lap":Dashboard.currentLap-1, "time":Dashboard.laptime})
                laptimelistview.incrementCurrentIndex()
            }
            if (Dashboard.currentLap == 0){
                laptimeModel.clear()
                laptimelistview.currentIndex = 0
            }
        }
    }

    Rectangle{
        anchors.fill: parent
        color: "black"

        Connections{
            target: Dashboard
            onCurrentLapChanged :{
                if (Dashboard.currentLap > 0){elapsedTimer.running = true,mapItem.startTime = 0};
                if (Dashboard.currentLap == 0){elapsedTimer.running = false,mapItem.startTime = 0};
            }
        }

        Map {
                id: map
                copyrightsVisible : false
                height : 480
                width : 400
                //plugin: Plugin { name: "osm" }
                tilt: 0
        }


            Map {
                id: mapOverlay
                anchors.fill: map
                plugin: Plugin { name: "itemsoverlay" }
                gesture.enabled: false
                center: map.center
                color: 'transparent' // Necessary to make this map transparent
                zoomLevel: map.zoomLevel
                tilt: map.tilt;

                MapPolyline
                {
                    id: trackLine
                    line.width: 10
                    line.color: 'white'
                }

                MapPolyline {
                    id:startline
                    line.width: 6
                    line.color: 'green'
                }
                MapPolyline {
                    id:finishline2
                    line.width: 6
                    line.color: 'red'
                }
                Component.onCompleted:
                {
                    var lines = []
                    for(var i=0;i<geopath.size();i++)
                    {
                        lines[i] = geopath.coordinateAt(i)
                    }
                    trackLine.path = lines
                }
            // Draw a small red circle for current Vehicle Location
            MapQuickItem {
                id: marker
                anchorPoint.x: 10
                anchorPoint.y: 10
                width: 15
                coordinate: QtPositioning.coordinate(Dashboard.gpsLatitude,Dashboard.gpsLongitude)
                sourceItem: Rectangle {
                    id: image
                    width:20
                    height: width
                    radius: width*0.5
                    color: "red"
                }
            }
        }
        ComboBox {
            id: countryselect
            width: 170
            height: 30
            anchors.left: map.right
            font.pixelSize: 20

            delegate: ItemDelegate {
                width: countryselect.width
                text: countryselect.textRole ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
                font.weight: countryselect.currentIndex == index ? Font.DemiBold : Font.Normal
                font.family: countryselect.font.family
                font.pixelSize: countryselect.font.pixelSize
                highlighted: countryselect.highlightedIndex == index
                hoverEnabled: countryselect.hoverEnabled
            }
            onActivated: {
                           AppSettings.writeCountrySettings(textAt(countryselect.currentIndex))
                         }
            onCurrentIndexChanged: changecountry.change()
            Component.onCompleted: {
                var countrylist = []
                for(var i=0;i<mapIO.getCountryCount();i++)
                {
                    countrylist[i] = mapIO.getCountries()[i];
                }
                countryselect.model = countrylist;
                countryselect.currentIndex =  find(Dashboard.CBXCountrysave)
                }
        }
        ComboBox {
            id: trackselect
            width: 230
            height: 30
            anchors.left: countryselect.right
            font.pixelSize: 20
            delegate: ItemDelegate {
                width: trackselect.width
                text: trackselect.textRole ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
                font.weight: trackselect.currentIndex == index ? Font.DemiBold : Font.Normal
                font.family: trackselect.font.family
                font.pixelSize: trackselect.font.pixelSize
                highlighted: trackselect.highlightedIndex == index
                hoverEnabled: trackselect.hoverEnabled
            }
            onCurrentIndexChanged: changetrack.change()
            onModelChanged: {
                            changetrack.change()//needed if when the Country is changed
                            if (find(Dashboard.CBXTracksave) !== -1)
                            {
                            trackselect.currentIndex =  find(Dashboard.CBXTracksave)
                            }
                            else
                            {
                            trackselect.currentIndex = 0
                            }
                            }
            onActivated: {
                           AppSettings.writeTrackSettings(textAt(trackselect.currentIndex))
                         }
        }
        Grid {
            id:buttongrid
            rows: 1
            columns: 2
            anchors.margins: 20
            anchors.bottom: parent.bottom
            anchors.left: map.right
            columnSpacing :5
        Button {
            id: changeview
            //visible: false
            text: "TOP VIEW"
            width: 170
            height: 30
            font.pixelSize: 20
            onClicked: {
                if (changeview.text == "DRIVER VIEW" )
                {
                    map.center=QtPositioning.coordinate(parseFloat(mapIO.getCenter(countryselect.textAt(countryselect.currentIndex),trackselect.textAt(trackselect.currentIndex))[0]),parseFloat(mapIO.getCenter(countryselect.textAt(countryselect.currentIndex),trackselect.textAt(trackselect.currentIndex))[1]));
                    map.zoomLevel = mapIO.getZOOMLEVEL(countryselect.textAt(countryselect.currentIndex),trackselect.textAt(trackselect.currentIndex));
                    map.tilt = 0;
                    map.bearing = 0;
                }
                else
                {
                    map.tilt = 45;
                    map.zoomLevel = 18;
                }
                changeview.text == "TOP VIEW" ? changeview.text = "DRIVER VIEW" : changeview.text = "TOP VIEW";
                changeview.text == "DRIVER VIEW" ? changeview.text = "DRIVER VIEW" : changeview.text = "TOP VIEW";
            }
        }

        Button {
            id: stop
            text: "Reset"
            width: 170
            height: 30
            font.pixelSize: 20
            onClicked: {
                        laptimeModel.clear()
                        elapsedTimer.running = false
                        time.text= "00:00.000"
                        mapItem.startTime = 0
                        GPS.resetLaptimer()
                        }
        }
        }
        Grid {
            id:grid1
            rows: 3
            columns: 2
            spacing: 5
            anchors.left: map.right
            anchors.top: countryselect.bottom


            Text { text: "Current : "
                font.pixelSize: 15
                font.bold: true
                color : "orangered"
                font.family: "Eurostile"}
            Text {
                id: time
                text: "00:00.000"
                font.pixelSize: 30
                font.bold: true
                color : "orangered"
                font.family: "Eurostile"}
            Text { text: "Best Lap: "
                font.pixelSize: 15
                font.bold: true
                color: "#00ff00"
                font.family: "Eurostile"}
            Text { text: Dashboard.bestlaptime
                font.pixelSize: 30
                font.bold: true
                color: "#00ff00"
                font.family: "Eurostile"}
            Text { text: "GPS FIX type: "
                font.pixelSize: 15
                font.bold: true
                color: "#00ff00"
                font.family: "Eurostile"}
            Text { text: Dashboard.gpsFIXtype
                font.pixelSize: 15
                font.bold: true
                color: "#00ff00"
                font.family: "Eurostile"}
        }
Rectangle{
    id :laptimes

    anchors.top: grid1.bottom
    anchors.topMargin: 5
    anchors.left: map.right
    anchors.leftMargin: 5
    anchors.bottom : buttongrid.top
    anchors.bottomMargin: 5
    width: 400
    height: 200
    color: "grey"
    ListModel {
        id: laptimeModel
    }

    Component {
        id: contactDelegate

        Item {
            id:leftcolum
            width: 400; height: 40
            Row {
            Column {
                Text {
                        text: "LAP " + lap
                        width: 110
                        color: "white"
                        font.pixelSize:  15
                        font.bold: true}
            }
            Column {
                Text { text: time
                       anchors.right: parent.right
                       width: 195
                       color: "white"
                       font.pixelSize:  30
                       font.bold: true}
            }
        }
        }
    }

    ListView {
        id: laptimelistview
        width: 400
        height: 200
        anchors.fill: parent
        model: laptimeModel
        delegate: contactDelegate
        highlight: Rectangle { color: "#505050"; radius: 5}
        focus: false
        clip: true

        addDisplaced: Transition {
            NumberAnimation { properties: "x,y"; duration: 1000 }
        }
    }
}
IMD
{
    id:mapIO
}
        Item
        {
            id: changecountry
            function change(){
                    var lines = []
                    var l2 = mapIO.getTracks(countryselect.textAt(countryselect.currentIndex));
                    for(var i=0;i<mapIO.getTrackCount(countryselect.textAt(countryselect.currentIndex));i++)
                    {
                        lines[i] = mapIO.getTracks(countryselect.textAt(countryselect.currentIndex))[i];
                    }
                    trackselect.model = lines;
            }
        }
        Item
        {
            id: changetrack
            function change()
            {
                if(mapIO.getTrackExists(countryselect.textAt(countryselect.currentIndex),trackselect.textAt(trackselect.currentIndex)))
                {
                    map.center=QtPositioning.coordinate(parseFloat(mapIO.getCenter(countryselect.textAt(countryselect.currentIndex),trackselect.textAt(trackselect.currentIndex))[0]),parseFloat(mapIO.getCenter(countryselect.textAt(countryselect.currentIndex),trackselect.textAt(trackselect.currentIndex))[1]));
                    map.zoomLevel = mapIO.getZOOMLEVEL(countryselect.textAt(countryselect.currentIndex),trackselect.textAt(trackselect.currentIndex));
                    map.tilt = 0;
                    map.bearing = 0;
                    map.fitViewportToVisibleMapItems();
                    changeview.text = "TOP VIEW";

                    linex1 = mapIO.getStartFinishLine(countryselect.textAt(countryselect.currentIndex),trackselect.textAt(trackselect.currentIndex))[0];
                    liney1 = mapIO.getStartFinishLine(countryselect.textAt(countryselect.currentIndex),trackselect.textAt(trackselect.currentIndex))[1];
                    linex2 = mapIO.getStartFinishLine(countryselect.textAt(countryselect.currentIndex),trackselect.textAt(trackselect.currentIndex))[2];
                    liney2 = mapIO.getStartFinishLine(countryselect.textAt(countryselect.currentIndex),trackselect.textAt(trackselect.currentIndex))[3];
                    //TODO fill in DefineFinishLine
                    Gps.defineFinishLine(linex1,liney1,linex2,liney2);
                    trackLine.setPath( mapIO.loadMapData(countryselect.textAt(countryselect.currentIndex),trackselect.textAt(trackselect.currentIndex)));
                    startline.path = [
                                { latitude: linex1, longitude: liney1 },
                                { latitude: linex2, longitude: liney2},
                                       ]
                    if(mapIO.getExistsSecondFinish(countryselect.textAt(countryselect.currentIndex),trackselect.textAt(trackselect.currentIndex)))
                    {

                        var linex21 = mapIO.getSecondFinishLine(countryselect.textAt(countryselect.currentIndex),trackselect.textAt(trackselect.currentIndex))[0];
                        var liney21 = mapIO.getSecondFinishLine(countryselect.textAt(countryselect.currentIndex),trackselect.textAt(trackselect.currentIndex))[1];
                        var linex22 = mapIO.getSecondFinishLine(countryselect.textAt(countryselect.currentIndex),trackselect.textAt(trackselect.currentIndex))[2];
                        var liney22 = mapIO.getSecondFinishLine(countryselect.textAt(countryselect.currentIndex),trackselect.textAt(trackselect.currentIndex))[3];
                        Gps.defineFinishLine2(linex21,liney21,linex22,liney22);
                        finishline2.path = [
                                    { latitude: linex21, longitude: liney21 },
                                    { latitude: linex22, longitude: liney22},
                                           ]
                    }
                }
            }
        }
        Item
        {
            //Needed to permanently update the Map Center if Current Position view is selected
            id: pos
            function poschanged(){
                if (changeview.text == "DRIVER VIEW"){map.center= QtPositioning.coordinate(Dashboard.gpsLatitude,Dashboard.gpsLongitude),map.bearing=Dashboard.gpsbearing,map.tilt=45,map.zoomLevel = 18};
            }
        }
    }
}
