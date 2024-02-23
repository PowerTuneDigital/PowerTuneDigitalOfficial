import QtQuick 2.8
import QtQuick.Extras 1.4
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4


Item {
    id: userDash
    anchors.fill: parent

      Image
      {
        id:groove1
        source:"qrc:/graphics/fueltechempty.png"
        width: parent.width
        height: parent.width /4
        anchors.top:parent.top
        anchors.left:parent.left
        smooth: true

        Item{
              id: displayWindow1
              height: parent.height
              width: (parent.width*(Dashboard.rpm)/Dashboard.maxRPM)
              clip: true

                anchors.bottom: parent.bottom
                anchors.left: parent.left

              Image
              {
                id:speedarcfill
                anchors.top:parent.top
                anchors.left:parent.left
                width: groove1.width
                height: groove1.height
                source:"qrc:/graphics/fueltechfill.png"
                smooth: true
                z: 1
              }
            }

      PathInterpolator {
        id: motionPath
        property int value

           path: Path {
           startX: 0; startY: parent.width /4.2
           PathLine { x: parent.width; y: parent.height }
         }
        progress: Dashboard.rpm / Dashboard.maxRPM
      }
}
//
        ShiftLights{ }


        Text {
            x: 0
            y: userDash.width / 18.6 // 43
            font.pixelSize:  userDash.width / 11.4 //70
            font.bold: true
            color: "white"
            text: Dashboard.rpm
            horizontalAlignment: Text.AlignLeft
            font.letterSpacing: 3
            font.wordSpacing: 0
        }
}
