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
  Component.onCompleted: {units.unitadjust()}

  Row{
      spacing: 1
      x: rpmDash.width * 0.26
      y: rpmDash.height * 0.2
      topPadding: 30
    Text {
      text:"RPM"
      topPadding: 30
      font.pixelSize: rpmDash.width * 0.025
      font.bold: true
      font.family: "Eurostile"
      color: "grey"

  }
  Text {
      text: (Dashboard.rpm)
      font.pixelSize: rpmDash.width * 0.095//100
  font.italic: true
      font.bold: true
      font.family: "Eurostile"
      color: "white"

  }
  }

  Row{
      spacing: 1
      x: rpmDash.width * 0.65
      y: rpmDash.height * 0.2
      topPadding: 30
      Text {
          id :speed
          text: "km/h"
          topPadding: 30
          font.pixelSize: rpmDash.width * 0.025//20
          font.bold: true
          font.family: "Eurostile"
          color: "grey"

      }
      Text {
          text: (Dashboard.speed).toFixed(0);
          font.pixelSize: rpmDash.width * 0.095//100
          font.italic: true
          font.bold: true
          font.family: "Eurostile"
          color: "white"

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
            //width: (678*(Dashboard.rpm)/Dashboard.maxRPM)+70 //+70 is the pixel where the RPM bar starts and from there is 678 pixels wide
            width: (parent.width*(Dashboard.rpm)/Dashboard.maxRPM)+70
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
            }
          }

    PathInterpolator {
      id: motionPath
      property int value

         path: Path {
         startX: 47; startY: 186
         PathLine { x: 137; y: 123 }
         PathArc { x: 251; y: 88; radiusX: 90; radiusY: 90 }
         PathLine { x: 776; y: 76 }
       }
      progress: Dashboard.rpm / Dashboard.maxRPM
    }
    }
            ShiftLights{}
}
