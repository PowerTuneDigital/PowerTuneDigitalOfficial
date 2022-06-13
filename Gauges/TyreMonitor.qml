import QtQuick 2.8
import QtQuick.Controls 2.1

Item {
    id: mainwindow
    anchors.fill: parent

    property int greencolor : 40
    property int yellowcolor : 60
    property int redcolor : 80
Rectangle {
    id: tyremonLF
    anchors.left: mainwindow.left
    height:75
    width:160
Grid{

    columns: 8
    Rectangle{
    id:templf01
    height:75
    width: 20
    color: "blue"
    }
    Rectangle{
    id:templf02
    height:75
    width: 20
    color: "blue"
    }
    Rectangle{
    id:templf03
    height:75
    width: 20
    color: "blue"
    }
    Rectangle{
    id:templf04
    height:75
    width: 20
    color: "blue"
    }
    Rectangle{
    id:templf05
    height:75
    width: 20
    color: "blue"
    }
    Rectangle{
    id:templf06
    height:75
    width: 20
    color: "green"
    }
    Rectangle{
    id:templf07
    height:75
    width: 20
    color: "blue"
    }
    Rectangle{
    id:templf08
    height:75
    width: 20
    color: "blue"
    }
}
}
Rectangle {
    id: tyremonRF
    anchors.right: mainwindow.right
    height:75
    width:160
Grid{

    columns: 8
    Rectangle{
    id:temprf01
    height:75
    width: 20
    color: "blue"
    }
    Rectangle{
    id:temprf02
    height:75
    width: 20
    color: "blue"
    }
    Rectangle{
    id:temprf03
    height:75
    width: 20
    color: "blue"
    }
    Rectangle{
    id:temprf04
    height:75
    width: 20
    color: "blue"
    }
    Rectangle{
    id:temprf05
    height:75
    width: 20
    color: "blue"
    }
    Rectangle{
    id:temprf06
    height:75
    width: 20
    color: "green"
    }
    Rectangle{
    id:temprf07
    height:75
    width: 20
    color: "blue"
    }
    Rectangle{
    id:temprf08
    height:75
    width: 20
    color: "blue"
    }
}
}
Rectangle {
    id: tyremonLR
    anchors.left: mainwindow.left
    anchors.bottom: mainwindow.bottom
    height:75
    width:160
Grid{

    columns: 8
    Rectangle{
    id:templr01
    height:100
    width: 20
    color: {
             if (Dashboard.LR_Tyre_Temp_01  < greencolor)
                 return "blue"
             else if (Dashboard.LR_Tyre_Temp_01 >= greencolor && Dashboard.LR_Tyre_Temp_01 < yellowcolor)
                 return "green"
             else if (Dashboard.LR_Tyre_Temp_01 >= yellowcolor && Dashboard.LR_Tyre_Temp_01 < redcolor)
                return "yellow"
             else if (Dashboard.LR_Tyre_Temp_01 >= redcolor )
                return "red"
         }
    Text{
    anchors.fill: parent
    text: (Dashboard.LR_Tyre_Temp_01).toFixed(0)
    wrapMode: Text.WrapAnywhere
    font.pixelSize: 20
    }
    }
    Rectangle{
    id:templr02
    height:75
    width: 20
    color: {
             if (Dashboard.LR_Tyre_Temp_02  < greencolor)
                 return "blue"
             else if (Dashboard.LR_Tyre_Temp_02 >= greencolor && Dashboard.LR_Tyre_Temp_02 < yellowcolor)
                 return "green"
             else if (Dashboard.LR_Tyre_Temp_02 >= yellowcolor && Dashboard.LR_Tyre_Temp_02 < redcolor)
                return "yellow"
             else if (Dashboard.LR_Tyre_Temp_02 >= redcolor )
                return "red"
         }
    Text{
    anchors.fill: parent
    text: (Dashboard.LR_Tyre_Temp_02).toFixed(0)
    wrapMode: Text.WrapAnywhere
    font.pixelSize: 20
    }
    }
    Rectangle{
    id:templr03
    height:75
    width: 20
    color: {
             if (Dashboard.LR_Tyre_Temp_03  < greencolor)
                 return "blue"
             else if (Dashboard.LR_Tyre_Temp_03 >= greencolor && Dashboard.LR_Tyre_Temp_03 < yellowcolor)
                 return "green"
             else if (Dashboard.LR_Tyre_Temp_03 >= yellowcolor && Dashboard.LR_Tyre_Temp_03 < redcolor)
                return "yellow"
             else if (Dashboard.LR_Tyre_Temp_03 >= redcolor )
                return "red"
         }
    Text{
    anchors.fill: parent
    text: (Dashboard.LR_Tyre_Temp_03).toFixed(0)
    wrapMode: Text.WrapAnywhere
    font.pixelSize: 20
    }
    }
    Rectangle{
    id:templr04
    height:75
    width: 20
    color: {
             if (Dashboard.LR_Tyre_Temp_04  < greencolor)
                 return "blue"
             else if (Dashboard.LR_Tyre_Temp_04 >= greencolor && Dashboard.LR_Tyre_Temp_04 < yellowcolor)
                 return "green"
             else if (Dashboard.LR_Tyre_Temp_04 >= yellowcolor && Dashboard.LR_Tyre_Temp_04 < redcolor)
                return "yellow"
             else if (Dashboard.LR_Tyre_Temp_04 >= redcolor )
                return "red"
         }
    Text{
    anchors.fill: parent
    text: (Dashboard.LR_Tyre_Temp_04).toFixed(0)
    wrapMode: Text.WrapAnywhere
    font.pixelSize: 20
    }
    }
    Rectangle{
    id:templr05
    height:75
    width: 20
    color: {
             if (Dashboard.LR_Tyre_Temp_05  < greencolor)
                 return "blue"
             else if (Dashboard.LR_Tyre_Temp_05 >= greencolor && Dashboard.LR_Tyre_Temp_05 < yellowcolor)
                 return "green"
             else if (Dashboard.LR_Tyre_Temp_05 >= yellowcolor && Dashboard.LR_Tyre_Temp_05 < redcolor)
                return "yellow"
             else if (Dashboard.LR_Tyre_Temp_05 >= redcolor )
                return "red"
         }
    Text{
    anchors.fill: parent
    text: (Dashboard.LR_Tyre_Temp_05).toFixed(0)
    wrapMode: Text.WrapAnywhere
    font.pixelSize: 20
    }
    }
    Rectangle{
    id:templr06
    height:75
    width: 20
    color: {
             if (Dashboard.LR_Tyre_Temp_06  < greencolor)
                 return "blue"
             else if (Dashboard.LR_Tyre_Temp_06 >= greencolor && Dashboard.LR_Tyre_Temp_06 < yellowcolor)
                 return "green"
             else if (Dashboard.LR_Tyre_Temp_06 >= yellowcolor && Dashboard.LR_Tyre_Temp_06 < redcolor)
                return "yellow"
             else if (Dashboard.LR_Tyre_Temp_06 >= redcolor )
                return "red"
         }
    Text{
    anchors.fill: parent
    text: (Dashboard.LR_Tyre_Temp_03).toFixed(0)
    wrapMode: Text.WrapAnywhere
    font.pixelSize: 20
    }
    }
    Rectangle{
    id:templr07
    height:75
    width: 20
    color: {
             if (Dashboard.LR_Tyre_Temp_07  < greencolor)
                 return "blue"
             else if (Dashboard.LR_Tyre_Temp_07 >= greencolor && Dashboard.LR_Tyre_Temp_07 < yellowcolor)
                 return "green"
             else if (Dashboard.LR_Tyre_Temp_07 >= yellowcolor && Dashboard.LR_Tyre_Temp_07 < redcolor)
                return "yellow"
             else if (Dashboard.LR_Tyre_Temp_07 >= redcolor )
                return "red"
         }
    Text{
    anchors.fill: parent
    text: (Dashboard.LR_Tyre_Temp_07).toFixed(0)
    wrapMode: Text.WrapAnywhere
    font.pixelSize: 20
    }
    }
    Rectangle{
    id:templr08
    height:75
    width: 20
    color: {
             if (Dashboard.LR_Tyre_Temp_08  < greencolor)
                 return "blue"
             else if (Dashboard.LR_Tyre_Temp_08 >= greencolor && Dashboard.LR_Tyre_Temp_08 < yellowcolor)
                 return "green"
             else if (Dashboard.LR_Tyre_Temp_08 >= yellowcolor && Dashboard.LR_Tyre_Temp_08 < redcolor)
                return "yellow"
             else if (Dashboard.LR_Tyre_Temp_08 >= redcolor )
                return "red"
         }
    Text{
    anchors.fill: parent
    text: (Dashboard.LR_Tyre_Temp_08).toFixed(0)
    wrapMode: Text.WrapAnywhere
    font.pixelSize: 20
    }
    }
}
}
Rectangle {
    id: tyremonRR
    anchors.right: mainwindow.right
    anchors.bottom: mainwindow.bottom
    height:75
    width:160
Grid{

    columns: 8
    Rectangle{
    id:temprr01
    height:75
    width: 20
    color: "blue"
    }
    Rectangle{
    id:temprr02
    height:75
    width: 20
    color: "blue"
    }
    Rectangle{
    id:temprr03
    height:75
    width: 20
    color: "blue"
    }
    Rectangle{
    id:temprr04
    height:75
    width: 20
    color: "blue"
    }
    Rectangle{
    id:temprr05
    height:75
    width: 20
    color: "blue"
    }
    Rectangle{
    id:temprr06
    height:75
    width: 20
    color: "green"
    }
    Rectangle{
    id:temprr07
    height:75
    width: 20
    color: "blue"
    }
    Rectangle{
    id:temprr08
    height:75
    width: 20
    color: "blue"
    }
}
}
}
/*

*/

