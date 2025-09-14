import QtQuick 2.15
import QtQuick.Controls 2.15
import QtCharts 2.15

Item {
    width: parent.width
    height: parent.height

    // --- function to check metric/imperial dynamically ---
    function isMetric() {
        return Dashboard.speedunits === "metric"
    }

    ChartView {
        id: chart
        width: parent.width
        height: parent.height
        antialiasing: true
        legend.font.pixelSize: chart.height / 40
/*
        title: isMetric()
               ? "Torque (Nm)  / Power (kW)1 "
               : "Torque (ft·lb) / Power (HP)"
*/
        ValueAxis { id: axisX; min: 0; max: 8000; titleText: "RPM"; labelsFont:Qt.font({pointSize: chart.height / 70}) }
        ValueAxis { id: axisY; min: 0; max: 100; titleText: isMetric() ? "Nm / kW" : "ft·lb / HP";labelsFont:Qt.font({pointSize: chart.height / 70}) }

        LineSeries { id: torqueSeries; name: isMetric() ? "Torque (Nm)" : "Torque (ft·lb)"; axisX: axisX; axisY: axisY }
        LineSeries { id: powerSeries; name: isMetric() ? "Power (kW)" : "Power (HP)"; axisX: axisX; axisY: axisY }

        Button {
            id: startButton
            text: "Start Dyno"
            anchors.centerIn: parent
            onClicked: {
                torqueSeries.clear()
                powerSeries.clear()
                DynoAnalyzer.prime()
                startButton.enabled = false
                startButton.visible = false
            }
        }
    }

    // Max Torque Indicator
    Rectangle {
        width: chart.height / 70
        height: chart.height / 70
        color: "blue"
        anchors.verticalCenter: maxTorqueValuesText.verticalCenter
        anchors.right: maxTorqueValuesText.left
        anchors.rightMargin: 5
    }

    // Max Torque Text
    Text {
        id: maxTorqueValuesText
        anchors.left: chart.left
        anchors.top: chart.top
        anchors.leftMargin: chart.width / 7
        anchors.topMargin: chart.height / 5
        font.pixelSize: chart.height / 50
        text: isMetric()
              ? "Max Torque: 0 Nm @ 0 RPM"
              : "Max Torque: 0 ft·lb @ 0 RPM"

    }

    // Max Power Indicator
    Rectangle {
        width: chart.height / 70
        height: chart.height / 70
        color: "green"
        anchors.verticalCenter: maxPowerValuesText.verticalCenter
        anchors.right: maxPowerValuesText.left
        anchors.rightMargin: 5
    }

    // Max Power Text
    Text {
        id: maxPowerValuesText
        anchors.left: chart.left
        anchors.top: maxTorqueValuesText.bottom
        anchors.leftMargin: chart.width / 7
        anchors.topMargin: 5
        font.pixelSize: chart.height / 50
        text: isMetric()
              ? "Max Power:  0 kW @ 0 RPM"
              : "Max Power:  0 HP    @ 0 RPM"

    }

    // --- DynoAnalyzer Connections ---
    Connections {
        target: DynoAnalyzer

        function onNewTorquePoint(rpm, torque) {
            torqueSeries.append(rpm, torque)
        }
        function onNewPowerPoint(rpm, power) {
            powerSeries.append(rpm, power)
        }
        function onYRangeChanged(minY, maxY) {
            axisY.min = 0
            axisY.max = maxY
        }
        function onRunningChanged(running) {
            startButton.enabled = !running
            startButton.text = running ? "Running..." : "Start Dyno Run"
            startButton.visible = !running
        }
        function onFinished() {
            maxTorqueValuesText.text =
                isMetric() ? "Max Torque: " + DynoAnalyzer.maxTorque.toFixed(0) + " Nm @ " + DynoAnalyzer.maxTorqueRpm.toFixed(0) + " RPM"
                           : "Max Torque: " + DynoAnalyzer.maxTorque.toFixed(0) + " ft·lb @ " + DynoAnalyzer.maxTorqueRpm.toFixed(0) + " RPM"
            maxPowerValuesText.text =
                    isMetric() ? "Max Power: " + DynoAnalyzer.maxPower.toFixed(0) + " kW @ " + DynoAnalyzer.maxTorqueRpm.toFixed(0) + " RPM"
                               : "Max Power: " + DynoAnalyzer.maxPower.toFixed(0) + " HP @ " + DynoAnalyzer.maxTorqueRpm.toFixed(0) + " RPM"

        }
    }

    // --- Dashboard Connections to detect speed unit changes ---
    Connections {
        target: Dashboard
        function onspeedunitsChanged() {
            console.log("Speed units changed, chart and labels should update dynamically")
            // Force redraw/update
            axisY.titleText = isMetric() ? "Nm / kW" : "ft·lb / HP"
            torqueSeries.name = isMetric() ? "Torque (Nm)" : "Torque (ft·lb)"
            powerSeries.name = isMetric() ? "Power (kW)" : "Power (HP)"
        }
    }
}
