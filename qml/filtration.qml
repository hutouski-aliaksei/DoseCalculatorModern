import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQuick.Window
import QtCharts
import Qt.labs.qmlmodels

Page {
    id: root

    property int button_width: 100
    property int button_height: 30
    property int margin: 10

    Material.theme: Material.Light
    Material.accent: custom_color
    width: 1280
    height: 768
    header: Item {
        height: 10
    }

    ColumnLayout {
        id: column_layout
        anchors.fill: parent
        anchors.leftMargin: margin
        anchors.rightMargin: margin
        anchors.bottomMargin: button_height
        spacing: margin

        RowLayout {
            id: row_layout
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 200
            spacing: margin

            Pane {
                id: add_pane
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 200
                Material.elevation: 5
                Material.background: Material.color(custom_color, Material.Shade50)

                ColumnLayout {
                    id: add_column_layout
                    anchors.fill: parent
                    anchors.leftMargin: margin
                    anchors.rightMargin: margin
                    anchors.bottomMargin: button_height
                    spacing: margin

                    Button {
                        id: open_file_button
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredHeight: button_height
                        leftPadding: 5
                        rightPadding: 5

                        font.bold: true
                        font.pixelSize: 14
                        Material.background: custom_color
                        highlighted: true

                        text: "Open file"

                        // onClicked: bridge.on_action("limit")
                    }

                    ComboBox {
                        id: material_combobox
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredHeight: button_height
                        model: bridge.shields_list
                        currentIndex: indexOfValue(bridge.view_array[7])
                        enabled: bridge.db_exists
                        onActivated: {
                            // bridge.view_array[7] = currentValue
                            // bridge.on_action("activity")
                        }
                    }

                    Button {
                        id: add_layer_button
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredHeight: button_height
                        leftPadding: 5
                        rightPadding: 5

                        font.bold: true
                        font.pixelSize: 14
                        Material.background: custom_color
                        highlighted: true

                        text: "Add layer"

                        // onClicked: bridge.on_action("limit")
                    }

                    Button {
                        id: clear_filter_button
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredHeight: button_height
                        leftPadding: 5
                        rightPadding: 5

                        font.bold: true
                        font.pixelSize: 14
                        Material.background: custom_color
                        highlighted: true

                        text: "Clear filter"

                        // onClicked: bridge.on_action("limit")
                    }
                }
            }

            Pane {
                id: filter_pane
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 400
                Material.elevation: 5
                Material.background: Material.color(custom_color, Material.Shade50)
            }
        }

        Pane {
            id: chart_pane
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 400
            Material.elevation: 5
            Material.background: Material.color(custom_color, Material.Shade50)

            ChartView {
                id: filtration_chart
                anchors.fill: parent
                antialiasing: true
                legend.visible: false
                backgroundColor: Material.color(custom_color)
                margins { top: 10; bottom: 0; left: 10; right: 10 }
                property int cursorPositionX: 0
                property int cursorPositionY: 0
                property int initial_position_X: 0
                property int initial_position_Y: 0
                property int total_X: 0
                property int total_Y: 0

                ValueAxis {
                    id: my_axisX
                    min: 0
                    max: 1500
                    tickCount: 16
                    tickType: ValueAxis.TicksFixed
                    labelsColor: "white"
                    labelFormat: "%d"
                }

                ValueAxis {
                    id: my_axisY
                    min: -2
                    max: 2
                    labelsColor: "white"
                    labelFormat: "%d"
                    onRangeChanged:{
                    }
                }

                ScatterSeries {
                    id: filtration_series
                    // property var commandID: commands.calculate_compression_table
                    property var displayData: []
                    name: "filtration_series"
                    color: "#234E9B"
                    axisX: my_axisX
                    axisY: my_axisY
                    markerSize: 10
                    // Component.onCompleted: idList.push(commands.calculate_compression_table)
                    onDisplayDataChanged: {
                        if (displayData.length > 0) {
                            filtration_series.removePoints(0, filtration_series.count)
                            for (let i=0; i < (displayData.length/2); i++) {
                                my_axisX.max = my_axisX.max > (displayData[i*2] + 50) ? my_axisX.max : (displayData[i*2] + 50)
                                my_axisY.max = my_axisY.max > (displayData[i*2 + 1] + 1) ? my_axisY.max : (displayData[i*2 + 1] + 1)
                                my_axisY.min = my_axisY.min < (displayData[i*2 +1 ] - 1) ? my_axisY.min : (displayData[i*2 + 1] - 1)
                                filtration_series.append(displayData[i*2], displayData[i*2 + 1])
                            }
                        }
                    }
                }

                Text {
                    id: cursor_value_text
                    font.pixelSize: 20
                    color: "white"
                }

                Rectangle {
                    id: zoom_rectangle
                    color: "#234E9B"
                    opacity: 0.2
                    visible: false
                }

                MouseArea {
                    id: mA
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    pressAndHoldInterval: 200

                    Rectangle {
                        id: cursor
                        // x: compression_chart.plotarea.x
                        y: filtration_chart.cursorPositionY
                        height: 2
                        width: filtration_chart.plotArea.width
                        color: "#E6792B"
                        visible: false
                    }

                    property bool left_pressed: false
                    property bool short_pressed: false
                    property bool right_pressed: false

                    onPressAndHold: {
                        cursor.visible = false
                        cursor_value_text.text = ""
                        if (mouse.button === Qt.LeftButton)
                        {
                            left_pressed = true;
                            zoom_rectangle.x = mouseX;
                            zoom_rectangle.y = mouseY;
                            zoom_rectangle.visible = true;
                        }
                        if (mouse.button === Qt.RightButton)
                        {
                            right_pressed = true;
                            filtration_chart.initial_position_X = mouseX;
                            filtration_chart.initial_position_Y = mouseY;
                        }
                    }

                    onPressed: {
                        filtration_chart.cursorPositionY = mouseY
                        cursor_value_text.text = filtration_chart.mapToValue(Qt.point(mouseX, mouseY), filtration_series).y.toFixed(1)
                        cursor_value_text.x = mouseX + 10
                        cursor_value_text.y = mouseY + 20
                        cursor.visible = false
                    }

                    onMouseXChanged: {
                        if (left_pressed)
                        {
                            zoom_rectangle.width = mouseX - zoom_rectangle.x
                        }
                        if (right_pressed)
                        {
                            filtration_chart.scrollRight(filtration_chart.initial_position_X - mouseX)
                            filtration_chart.total_X += filtration_chart.initial_position_X - mouseX
                            filtration_chart.initial_position_X = mouseX
                        }
                    }

                    onMouseYChanged: {
                        if (left_pressed)
                        {
                            zoom_rectangle.height = mouseY - zoom_rectangle.y
                        }
                        if (right_pressed)
                        {
                            filtration_chart.scrollDown(filtration_chart.initial_position_Y - mouseY)
                            filtration_chart.total_Y += filtration_chart.initial_position_Y - mouseY
                            filtration_chart.initial_position_Y = mouseY
                        }
                    }

                    onReleased: {
                        if (left_pressed)
                        {
                            filtration_chart.zoomIn(Qt.rect(zoom_rectangle.x, zoom_rectangle.y, zoom_rectangle.width, zoom_rectangle.height))
                            zoom_rectangle.width = 0
                            zoom_rectangle.height = 0
                            zoom_rectangle.visible = false
                            left_pressed = false
                        }
                        if (right_pressed)
                        {
                            right_pressed = false
                        }
                    }

                    onDoubleClicked: {
                        if (mouse.button === Qt.LeftButton)
                        {
                            filtration_chart.zoomReset()
                        }
                        if (mouse.button === Qt.RightButton)
                        {
                            filtration_chart.scrollRight(-spectrum_chart.total_X)
                            filtration_chart.total_X = 0
                            filtration_chart.scrollDown(-spectrum_chart.total_Y)
                            filtration_chart.total_Y = 0
                        }
                    }
                }
            }
        }
    }


    footer: Item
    {
        height: button_height
    }
}
