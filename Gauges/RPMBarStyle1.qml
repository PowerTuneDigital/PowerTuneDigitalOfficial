import QtQuick 2.8
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.1
import QtQuick.Extras 1.4
import com.powertune 1.0

Item {
  id: speedUnits
  anchors.fill:parent
  property  var unit : Dashboard.speedunits;
  Component.onCompleted: {units.unitadjust();}


Rectangle{
id: gaugebackround
height: parent.height /2.2
width: parent.width
color: "darkgrey"
}

  Gauge {
      id: gauge
      height: parent.height
      width: parent.width /1.024
      y:0
      minorTickmarkCount: 0
      tickmarkStepSize : Dashboard.maxRPM
      orientation : Qt.Horizontal
      minimumValue: 0
      maximumValue: Dashboard.maxRPM

      value: Dashboard.rpm
      Behavior on value {
          NumberAnimation {
              duration: 5
          }
      }
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
              id: rpmFill
              width:  210
              color: Qt.rgba(gauge.value / gauge.maximumValue, 1.1 - gauge.value / gauge.maximumValue, 0, 1)
              Component.onCompleted: {
                  if(speedUnits.width == 1600){
                      rpmFill.width = 320
                  }
              }
          }
      }
}

Image
    {
      id: rpmDash
      source:"qrc:/graphics/Racedash.png"
      anchors.fill: parent
      smooth: true
 }

Row{
    spacing: 5
    //using rpmDash as its the full size of the screen
    x: rpmDash.width * 0.26
    y: rpmDash.height * 0.2
    topPadding: 8
    Text {
        id: rpmText
        text:"RPM"
        topPadding: 20
        //font.pixelSize: rpmDash.width * 0.025 //20
        font.pixelSize: 20
        font.bold: true
        font.family: "Eurostile"
        color: "grey"
        Component.onCompleted: {
            if(speedUnits.width == 800){
                rpmText.font.pixelSize = 20
            }else{
                rpmText.font.pixelSize = 40
            }
        }


    }
    Text {
        id: rpmNumber
        text: (Dashboard.rpm)
        font.pixelSize: 100
        font.italic: true
        font.bold: true
        font.family: "Eurostile"
        color: "white"
        Component.onCompleted: {
            if(speedUnits.width == 800){
                rpmNumber.font.pixelSize = 80
            }else{
                rpmNumber.font.pixelSize = 130
            }
        }
    }
}

Row{
    spacing: 5
    x: rpmDash.width * 0.67
    y: rpmDash.height * 0.2
    topPadding: 8
    Text {
        id :speed
        text: "km/h"
        topPadding: 20
        font.pixelSize: 20
        font.bold: true
        font.family: "Eurostile"
        color: "grey"
        Component.onCompleted: {
            if(speedUnits.width == 800){
                speed.font.pixelSize = 20
            }else{
                speed.font.pixelSize = 40
            }
        }
    }
    Text {
        id: speedNumbers
        text: (Dashboard.speed).toFixed(0);
        font.pixelSize: 100
        font.italic: true
        font.bold: true
        font.family: "Eurostile"
        color: "white"
        Component.onCompleted: {
            if(speedUnits.width == 800){
                speedNumbers.font.pixelSize = 80
            }else{
                speedNumbers.font.pixelSize = 130
            }
        }
    }
}


        ShiftLights{}

Item {
    id: units
    function unitadjust()
    {
        if (unit == "imperial") {speed.text = "mph"};
        if (unit == "metric") {speed.text = "km/h"};
    }
}
}
