import QtQuick 2.5
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick 2.8
import QtQuick.Controls 2.1
import QtQuick.Extras 1.4
import com.powertune 1.0
Rectangle {
    id:rpmDash
  visible: true
  color:"transparent"
  anchors.fill:parent
  property  var unit : Dashboard.speedunits;

  property int pathStartX: 47
  property int pathLineX: 137
  property int pathArcX: 251
  property int pathArcXRadius: 90
  property int pathLineXFinal: 776

  property int pathStartY: 186
  property int pathLineY: 123
  property int pathArcY: 88
  property int pathArcRadius: 90
  property int pathLineYFinal: 76

  property int rpmFillStart: 70


  Component.onCompleted: {
      units.unitadjust()

      if(rpmDash.width == 1600){
          pathStartX = 94
          pathLineX = 274
          pathArcX = 502
          pathArcXRadius = 180
          pathLineXFinal = 1552

          pathStartY = 279
          pathLineY = 184.5
          pathArcY = 132
          pathArcRadius = 135
          pathLineYFinal = 114

          rpmFillStart = 140

          console.log(pathStartX + " " + pathStartY)
      }
  }

  Row{
      spacing: 1
      x: rpmDash.width * 0.26
      y: rpmDash.height * 0.2
      topPadding: 30
    Text {
      id: rpmText
      text:"RPM"
      topPadding: 30
      font.pixelSize: 20
      font.bold: true
      font.family: "Eurostile"
      color: "grey"
      Component.onCompleted: {
          if(rpmDash.width == 800){
              rpmText.font.pixelSize = 20
          }else{
              rpmText.font.pixelSize = 40
          }
      }

  }
  Text {
      id: rpmNumbers
      text: (Dashboard.rpm)
      font.pixelSize: 100
  font.italic: true
      font.bold: true
      font.family: "Eurostile"
      color: "white"
      Component.onCompleted: {
          if(rpmDash.width == 800){
              rpmNumbers.font.pixelSize = 80
          }else{
              rpmNumbers.font.pixelSize = 130
          }
      }

  }
  }

  Row{
      spacing: 1
      x: rpmDash.width * 0.67
      y: rpmDash.height * 0.2
      topPadding: 30
      Text {
          id :speed
          text: "km/h"
          topPadding: 30
          font.pixelSize: 20
          font.bold: true
          font.family: "Eurostile"
          color: "grey"
          Component.onCompleted: {
              if(rpmDash.width == 800){
                  speed.font.pixelSize = 20
              }else{
                  speed.font.pixelSize = 40
              }
          }
      }
      Text {
          id: speedNumber
          text: (Dashboard.speed).toFixed(0);
          font.pixelSize: 100
          font.italic: true
          font.bold: true
          font.family: "Eurostile"
          color: "white"
          Component.onCompleted: {
              if(rpmDash.width == 800){
                  speedNumber.font.pixelSize = 80
              }else{
                  speedNumber.font.pixelSize = 130
              }
          }

      }
  }




  Item {
      id: units
      function unitadjust()
      {
          if (unit == "imperial") {speed.text = "mph"};
          if (unit == "metric") {speed.text = "km/h"};
      }
  }


    Image
    {
      id:groove1
      source:"qrc:/graphics/RPM_BG.png"
      anchors.top:parent.top
      anchors.left:parent.left
      smooth: true
      width: parent.width
      height: parent.width /4
      Item{
            id: displayWindow1
            height: parent.height
            width: (groove1.width*0.85*(Dashboard.rpm)/Dashboard.maxRPM)+rpmFillStart //+70 is the pixel where the RPM bar starts and from there is 678 pixels wide
            clip: true

              anchors.bottom: parent.bottom
              anchors.left: parent.left
               anchors.rightMargin:{switch(true)
              {
                 case Dashboard.rpm>=0 && Dashboard.rpm < 500:return 10;
                 case Dashboard.rpm>=500 && Dashboard.rpm < 700:return 9.7;
                 case Dashboard.rpm>=700 && Dashboard.rpm < 900:return 8.4;
                 case Dashboard.rpm>=900 && Dashboard.rpm < 1000:return 8;
                 case Dashboard.rpm>=1100 && Dashboard.rpm <= 1200:return 7.15;
                 case Dashboard.rpm>=1200 && Dashboard.rpm <= 1300:return 6;

                 }
               }

            Image
            {
              id:speedarcfill
              anchors.top:parent.top
              anchors.left:parent.left
              source:"qrc:/graphics/RPM_Fill.png"
              smooth: true
              width: groove1.width
              height: groove1.height
              z: 1
              Component.onCompleted: {
                  if(rpmDash.width == 1600){
                      speedarcfill.width = 1600
                      speedarcfill.height = groove1.height
                  }
              }
            }
          }

    PathInterpolator {
      id: motionPath
      property int value

         path: Path {
         startX: pathStartX; startY: pathStartY
         PathLine { x: pathLineX; y: pathLineY }
         PathArc { x: pathArcX; y: pathArcY; radiusX: pathArcXRadius; radiusY: pathArcRadius }
         PathLine { x: pathLineXFinal; y: pathLineYFinal }

         Component.onCompleted: {
             console.log(pathStartX + " " + pathStartY + " 800 width")
         }
       }
      progress: Dashboard.rpm / Dashboard.maxRPM
    }
    }

    ShiftLights{}
}
