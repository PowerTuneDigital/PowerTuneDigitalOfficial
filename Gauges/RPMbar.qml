import QtQuick 2.5
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.1
import QtQuick.Extras 1.4
import QtQuick 2.8
import com.powertune 1.0
Rectangle {
    id: rpmParent
  visible: true
  color:"transparent"
  anchors.fill:parent
  property  var unit : Dashboard.units;
  Component.onCompleted: {units.unitadjust();}

  Row{
      spacing: 5
      x: groove1.width * 0.26
      y: groove1.height * 0.2
      topPadding: 3
      Text {
          id: rpmText
          text:"RPM"
          topPadding: 80

          font.pixelSize: 20
          font.bold: true
          font.family: "Eurostile"
          color: "grey"
          Component.onCompleted: {
              if(rpmParent.width == 800){
                  rpmText.font.pixelSize = 20
              }else{
                  rpmText.font.pixelSize = 40
              }
              console.log(rpmText.font.pixelSize)
          }
      }
      Text {
          id:rpmNumbers
          text: (Dashboard.rpm)
          topPadding: 30
          font.pixelSize: 100
          font.italic: true
          font.bold: true
          font.family: "Eurostile"
          color: "white"
          Component.onCompleted: {
              if(rpmParent.width == 800){
                  rpmNumbers.font.pixelSize = 100
              }else{
                  rpmNumbers.font.pixelSize = 150
              }
              console.log(rpmNumbers.font.pixelSize)
          }
      }
  }

  Row{
      spacing: 5
      x: groove1.width * 0.67
      y: groove1.height * 0.2
      Text {
          id :speed
          text: "km/h"
          topPadding: 80
          font.pixelSize: 20
          font.bold: true
          font.family: "Eurostile"
          color: "grey"
          Component.onCompleted: {
              if(rpmParent.width == 800){
                  speed.font.pixelSize = 20
              }else{
                  speed.font.pixelSize = 40
              }
              console.log(speed.font.pixelSize)
          }
      }
      Text {
          id: speedNumbers
          text: (Dashboard.speed).toFixed(0);
          topPadding: 30
          font.pixelSize: 100
          font.italic: true
          font.bold: true
          font.family: "Eurostile"
          color: "white"
          Component.onCompleted: {
              if(rpmParent.width == 800){
                  speedNumbers.font.pixelSize = 100
              }else{
                  speedNumbers.font.pixelSize = 150
              }
              console.log(speedNumbers.font.pixelSize)
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
      source:"qrc:/graphics/empty.png"
      //width: parent.width
      //height: parent.height
      anchors.top:parent.top
      anchors.left:parent.left
      smooth: true

      Item{
            id: displayWindow1
            height: parent.height
            width: (651*(Dashboard.rpm)/Dashboard.maxRPM)+61 //+61 is the pixel where the RPM bar starts and from there is 651 pixels wide, Needs to be scaled dynamically

            clip: true

              anchors.bottom: parent.bottom
              anchors.left: parent.left
             /* anchors.rightMargin:{switch(true)
             {
                case slider.value>=0 && slider.value < 111:return 10;
                case slider.value>=111 && slider.value < 124:return 9.7;
                case slider.value>=124 && slider.value < 132:return 8.4;
                case slider.value>=132 && slider.value < 135:return 8;
                case slider.value>=135 && slider.value <= 165:return 7.15;
                case slider.value>=165 && slider.value <= 240:return 6;

                }
              }*/

            Image
            {
              id:speedarcfill
              anchors.top:parent.top
              anchors.left:parent.left
              //width: groove1.width
              //height: groove1.height
              source:"qrc:/graphics/fill.png"
              smooth: true
              z: 1
            }
          }

    PathInterpolator {
      id: motionPath
      property int value

     /* path: Path {
        startX: 27; startY: 189
        PathLine { x: 98; y: 54 }
        PathArc { x: 176; y: 11; radiusX: 90; radiusY: 90 }
        PathLine { x: 245; y: 11 }
      }*/
         path: Path {
         startX: 61; startY: 189
         PathLine { x: 712; y: 480 }
         //PathArc { x: 176; y: 11; radiusX: 90; radiusY: 90 }
         //PathLine { x: 800; y: 11 }
       }
      progress: Dashboard.rpm / Dashboard.maxRPM //slider.value/8000 // replace this with Dashboard.rpm
    }
    }
            ShiftLights{}
// remove slider
/*
    Slider {
          id: slider
          anchors.bottom: parent.bottom
          width: parent.width-10
          height: 100

          style: SliderStyle {
            handle:
              Rectangle {
                    anchors.centerIn: parent
                    color: control.pressed ? "white" : "lightgray"
                    border.color: "gray"
                    implicitWidth: 10
                    implicitHeight: 40
                  }

            groove: Rectangle {
              width: slider.width
              height: 10
              color:"black"

              LinearGradient {
                anchors.verticalCenter: parent.verticalCenter
                start: Qt.point(0, 0)
                end: Qt.point(parent.width, 0)
                width: styleData.handlePosition
                height: 10

                gradient: Gradient {
                  GradientStop {position: 0.0; color: "#008BFF" }
                  GradientStop {position: 0.5; color: "#3FFFD0" }
                  GradientStop { position: 1.0; color: "#3FFF41" }
                }
              }
            }

          }

          maximumValue: 8000

        }*/
//Remove till here

}
