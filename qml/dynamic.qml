import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQuick.Window

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

    RowLayout {
        id: row_layout
        anchors.fill: parent
        anchors.leftMargin: margin
        anchors.rightMargin: margin
        anchors.bottomMargin: button_height
        spacing: margin

        ColumnLayout {
            id: left_column_layout
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 150
            spacing: margin

            Pane {
                id: parameters_pane
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 100
                Material.elevation: 5
                Material.background: Material.color(custom_color, Material.Shade50)

                Label {
                    id: dynamic_label
                    width: button_width
                    height: button_height
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter

                    font.bold: true
                    font.pixelSize: 16
                    Material.foreground: custom_color

                    text: "Dynamic to Static"
                }

                RowLayout {
                    id: dynamic_row_layout
                    anchors.fill: parent
                    anchors.leftMargin: margin
                    anchors.rightMargin: margin
                    anchors.topMargin: button_height
                    spacing: margin

                    Item {
                        id: lable_item
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredWidth: 100

                        Label {
                            id: configuration_label
                            width: button_width
                            height: button_height
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.leftMargin: margin
                            anchors.topMargin: margin

                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                            font.pixelSize: 14
                            Material.foreground: custom_color

                            text: "Configuration"
                        }

                        Label {
                            id: distance_label
                            width: button_width
                            height: button_height
                            anchors.left: parent.left
                            anchors.top: configuration_label.bottom
                            anchors.leftMargin: margin
                            anchors.topMargin: margin

                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                            font.pixelSize: 14
                            Material.foreground: custom_color

                            text: "Distance, m"
                        }

                        Label {
                            id: velocity_label
                            width: button_width
                            height: button_height
                            anchors.left: parent.left
                            anchors.top: distance_label.bottom
                            anchors.leftMargin: margin
                            anchors.topMargin: margin

                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                            font.pixelSize: 14
                            Material.foreground: custom_color

                            text: "Velocity, m/s"
                        }

                        Label {
                            id: time_label
                            width: button_width
                            height: button_height
                            anchors.left: parent.left
                            anchors.top: velocity_label.bottom
                            anchors.leftMargin: margin
                            anchors.topMargin: margin

                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                            font.pixelSize: 14
                            Material.foreground: custom_color

                            text: "Time, s"
                        }

                        Label {
                            id: coefficient_label
                            width: button_width
                            height: button_height
                            anchors.left: parent.left
                            anchors.top: time_label.bottom
                            anchors.leftMargin: margin
                            anchors.topMargin: margin

                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                            font.pixelSize: 14
                            Material.foreground: custom_color

                            text: "Coefficient"
                        }

                        Label {
                            id: ratio_label
                            width: button_width
                            height: button_height
                            anchors.left: parent.left
                            anchors.top: coefficient_label.bottom
                            anchors.leftMargin: margin
                            anchors.topMargin: margin

                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                            font.pixelSize: 14
                            Material.foreground: custom_color

                            text: "First to Second ratio"
                        }

                    }

                    Item {
                        id: first_item
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredWidth: 100

                        Label {
                            id: first_label
                            width: button_width
                            height: button_height
                            anchors.horizontalCenter: distance_1_text.horizontalCenter
                            anchors.top: parent.top
                            anchors.topMargin: margin

                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                            font.pixelSize: 14
                            Material.foreground: custom_color

                            text: "First"
                        }

                        TextField {
                            id: distance_1_text
                            width: button_width*2
                            height: button_height
                            anchors.top: first_label.bottom
                            anchors.right: parent.right
                            anchors.topMargin: margin
                            anchors.rightMargin: margin
                            text: bridge.view_dynamic[0]
                            color: custom_color
                            validator: DoubleValidator {
                                bottom: 0.1
                            }

                            onTextEdited: {
                                if (acceptableInput) {
                                    bridge.view_dynamic[0] = text
                                    bridge.on_action("dynamic")
                                }
                            }
                        }

                        TextField {
                            id: velocity_1_text
                            width: button_width*2
                            height: button_height
                            anchors.top: distance_1_text.bottom
                            anchors.right: parent.right
                            anchors.topMargin: margin
                            anchors.rightMargin: margin
                            text: bridge.view_dynamic[2]
                            color: custom_color
                            validator: DoubleValidator {
                                bottom: 0.1
                            }

                            onTextEdited: {
                                if (acceptableInput) {
                                    bridge.view_dynamic[2] = text
                                    bridge.on_action("dynamic")
                                }
                            }
                        }

                        TextField {
                            id: time_1_text
                            width: button_width*2
                            height: button_height
                            anchors.top: velocity_1_text.bottom
                            anchors.right: parent.right
                            anchors.topMargin: margin
                            anchors.rightMargin: margin
                            text: bridge.view_dynamic[4]
                            color: custom_color
                            validator: DoubleValidator {
                                bottom: 0.1
                            }

                            onTextEdited: {
                                if (acceptableInput) {
                                    bridge.view_dynamic[4] = text
                                    bridge.on_action("dynamic")
                                }
                            }
                        }

                        Label {
                            id: coefficient_1_label
                            width: button_width
                            height: button_height
                            anchors.horizontalCenter: time_1_text.horizontalCenter
                            anchors.top: time_1_text.bottom
                            anchors.topMargin: margin

                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                            font.pixelSize: 14
                            Material.foreground: custom_color

                            text: bridge.view_dynamic[6].toFixed(3)
                        }

                        Label {
                            id: ratio_value_label
                            width: button_width
                            height: button_height
                            anchors.horizontalCenter: time_1_text.horizontalCenter
                            anchors.top: coefficient_1_label.bottom
                            anchors.topMargin: margin

                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                            font.pixelSize: 14
                            Material.foreground: custom_color

                            text: bridge.view_dynamic[8].toFixed(3)
                        }

                    }

                    Item {
                        id: second_item
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredWidth: 100

                        Label {
                            id: second_label
                            width: button_width
                            height: button_height
                            anchors.horizontalCenter: distance_2_text.horizontalCenter
                            anchors.top: parent.top
                            anchors.topMargin: margin

                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                            font.pixelSize: 14
                            Material.foreground: custom_color

                            text: "Second"
                        }

                        TextField {
                            id: distance_2_text
                            width: button_width*2
                            height: button_height
                            anchors.top: second_label.bottom
                            anchors.right: parent.right
                            anchors.topMargin: margin
                            anchors.rightMargin: margin
                            text: bridge.view_dynamic[1]
                            color: custom_color
                            validator: DoubleValidator {
                                bottom: 0.1
                            }

                            onTextEdited: {
                                if (acceptableInput) {
                                    bridge.view_dynamic[1] = text
                                    bridge.on_action("dynamic")
                                }
                            }
                        }

                        TextField {
                            id: velocity_2_text
                            width: button_width*2
                            height: button_height
                            anchors.top: distance_2_text.bottom
                            anchors.right: parent.right
                            anchors.topMargin: margin
                            anchors.rightMargin: margin
                            text: bridge.view_dynamic[3]
                            color: custom_color
                            validator: DoubleValidator {
                                bottom: 0.1
                            }

                            onTextEdited: {
                                if (acceptableInput) {
                                    bridge.view_dynamic[3] = text
                                    bridge.on_action("dynamic")
                                }
                            }
                        }

                        TextField {
                            id: time_2_text
                            width: button_width*2
                            height: button_height
                            anchors.top: velocity_2_text.bottom
                            anchors.right: parent.right
                            anchors.topMargin: margin
                            anchors.rightMargin: margin
                            text: bridge.view_dynamic[5]
                            color: custom_color
                            validator: DoubleValidator {
                                bottom: 0.1
                            }

                            onTextEdited: {
                                if (acceptableInput) {
                                    bridge.view_dynamic[5] = text
                                    bridge.on_action("dynamic")
                                }
                            }
                        }

                        Label {
                            id: coefficient_2_label
                            width: button_width
                            height: button_height
                            anchors.horizontalCenter: time_2_text.horizontalCenter
                            anchors.top: time_2_text.bottom
                            anchors.topMargin: margin

                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            font.bold: true
                            font.pixelSize: 14
                            Material.foreground: custom_color

                            text: bridge.view_dynamic[7].toFixed(3)
                        }

                    }
                }
            }

            Pane {
                id: picture_pane
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 100
                Material.elevation: 5
                Material.background: Material.color(custom_color, Material.Shade50)

                Image {
                    id: profile_image
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/img/profile.png"
                }

            }
        }

        ColumnLayout {
            id: right_column_layout
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 100
            spacing: margin

            Pane {
                id: limits_pane
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 100
                Material.elevation: 5
                Material.background: Material.color(custom_color, Material.Shade50)

                Label {
                    id: limits_label
                    width: button_width
                    height: button_height
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter

                    horizontalAlignment: Text.AlignHCenter
                    font.bold: true
                    font.pixelSize: 16
                    Material.foreground: custom_color

                    text: "Alarm limit"
                }

                RowLayout {
                    id: limits_row_layout
                    anchors.fill: parent
                    anchors.leftMargin: margin
                    anchors.rightMargin: margin
                    anchors.topMargin: button_height
                    spacing: margin

                    Item {
                        id: limits_lable_item
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredWidth: 100

                        Label {
                            id: background_label
                            width: button_width
                            height: button_height
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.leftMargin: margin
                            anchors.topMargin: margin

                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                            font.pixelSize: 14
                            Material.foreground: custom_color

                            text: "Background, cps"
                        }

                        Label {
                            id: far_label
                            width: button_width
                            height: button_height
                            anchors.left: parent.left
                            anchors.top: background_label.bottom
                            anchors.leftMargin: margin
                            anchors.topMargin: margin

                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                            font.pixelSize: 14
                            Material.foreground: custom_color

                            text: "FAR per s"
                        }

                        Label {
                            id: limit_time_label
                            width: button_width
                            height: button_height
                            anchors.left: parent.left
                            anchors.top: far_label.bottom
                            anchors.leftMargin: margin
                            anchors.topMargin: margin

                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                            font.pixelSize: 14
                            Material.foreground: custom_color

                            text: "Experiment time, s"
                        }

                        Label {
                            id: limit_label
                            width: button_width
                            height: button_height
                            anchors.left: parent.left
                            anchors.top: limit_time_label.bottom
                            anchors.leftMargin: margin
                            anchors.topMargin: margin

                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                            font.pixelSize: 14
                            Material.foreground: custom_color

                            text: "Limit, counts"
                        }

                    }

                    Item {
                        id: limits_first_item
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredWidth: 100

                        TextField {
                            id: background_text
                            width: button_width*2
                            height: button_height
                            anchors.top: parent.top
                            anchors.right: parent.right
                            anchors.topMargin: margin
                            anchors.rightMargin: margin
                            text: bridge.view_dynamic[9]
                            color: custom_color
                            validator: DoubleValidator {
                                bottom: 0.001
                            }

                            onTextEdited: {
                                if (acceptableInput) {
                                    bridge.view_dynamic[9] = text
                                }
                            }
                        }

                        TextField {
                            id: far_text
                            width: button_width*2
                            height: button_height
                            anchors.top: background_text.bottom
                            anchors.right: parent.right
                            anchors.topMargin: margin
                            anchors.rightMargin: margin
                            text: bridge.view_dynamic[10]
                            color: custom_color
                            validator: DoubleValidator {
                                bottom: 0.000001
                            }

                            onTextEdited: {
                                if (acceptableInput) {
                                    bridge.view_dynamic[10] = text
                                }
                            }
                        }

                        TextField {
                            id: limit_time_text
                            width: button_width*2
                            height: button_height
                            anchors.top: far_text.bottom
                            anchors.right: parent.right
                            anchors.topMargin: margin
                            anchors.rightMargin: margin
                            text: bridge.view_dynamic[11]
                            color: custom_color
                            validator: DoubleValidator {
                                bottom: 0.1
                            }

                            onTextEdited: {
                                if (acceptableInput) {
                                    bridge.view_dynamic[11] = text
                                }
                            }
                        }

                        Label {
                            id: limit_value_label
                            width: button_width
                            height: button_height
                            anchors.horizontalCenter: limit_time_text.horizontalCenter
                            anchors.top: limit_time_text.bottom
                            anchors.topMargin: margin

                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                            font.pixelSize: 14
                            Material.foreground: custom_color

                            text: bridge.view_dynamic[12]
                        }
                    }
                }

                Button {
                    id: limit_button
                    width: button_width*1.5
                    height: button_height*2
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: margin
                    anchors.bottomMargin: margin
                    leftPadding: 5
                    rightPadding: 5

                    font.bold: true
                    font.pixelSize: 14
                    Material.background: custom_color
                    highlighted: true

                    text: "Calculate"

                    onClicked: bridge.on_action("limit")
                }

            }

            Pane {
                id: reverse_limits_pane
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 100
                Material.elevation: 5
                Material.background: Material.color(custom_color, Material.Shade50)

                Label {
                    id: reverse_limits_label
                    width: button_width
                    height: button_height
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter

                    horizontalAlignment: Text.AlignHCenter
                    font.bold: true
                    font.pixelSize: 16
                    Material.foreground: custom_color

                    text: "Reverse limits calculation"
                }

                RowLayout {
                    id: reverse_limits_row_layout
                    anchors.fill: parent
                    anchors.leftMargin: margin
                    anchors.rightMargin: margin
                    anchors.topMargin: button_height
                    spacing: margin

                    Item {
                        id: reverse_limits_lable_item
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredWidth: 100

                        Label {
                            id: max_limit_label
                            width: button_width
                            height: button_height
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.leftMargin: margin
                            anchors.topMargin: margin

                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                            font.pixelSize: 14
                            Material.foreground: custom_color

                            text: "Max limit"
                        }

                        Label {
                            id: bckgr_label
                            width: button_width
                            height: button_height
                            anchors.left: parent.left
                            anchors.top: max_limit_label.bottom
                            anchors.leftMargin: margin
                            anchors.topMargin: margin

                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                            font.pixelSize: 14
                            Material.foreground: custom_color

                            text: "Background, cps"
                        }

                    }

                    Item {
                        id: reverse_limits_first_item
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredWidth: 100

                        TextField {
                            id: max_limit_text
                            width: button_width*2
                            height: button_height
                            anchors.top: parent.top
                            anchors.right: parent.right
                            anchors.topMargin: margin
                            anchors.rightMargin: margin
                            text: bridge.view_dynamic[13]
                            Material.background: custom_color
                            validator: IntValidator {
                                bottom: 1
                            }

                            onTextEdited: {
                                if (acceptableInput) {
                                    bridge.view_dynamic[13] = text
                                }
                            }
                        }

                        TextArea {
                            id: bckgr_value_text
                            width: button_width*2.1
                            height: button_height*5
                            anchors.top: max_limit_text.bottom
                            anchors.left: max_limit_text.left
                            anchors.topMargin: margin
                            topPadding: 5
                            wrapMode: TextEdit.WordWrap
                            readOnly: true
                            font.bold: true
                            font.pixelSize: 14
                            color: Material.color(custom_color)
                            horizontalAlignment: TextEdit.AlignJustify
                            background: Rectangle {
                                implicitWidth: parent.width
                                implicitHeight: parent.height
                                color: Material.color(custom_color, Material.Shade50)
                                border.color: "transparent"
                            }
                            text: bridge.view_dynamic[14]

                            MouseArea {
                                id: bckgr_mouse_area
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    bckgr_value_text.color = Material.color(Material.Orange)
                                    cursorShape = Qt.BusyCursor
                                    timer.start()
                                    parent.selectAll()
                                    parent.copy()
                                    parent.deselect()
                                }
                            }
                        }

                        Timer {
                            id: timer
                            interval: 200
                            running: false
                            repeat: false
                            onTriggered: {
                                bckgr_value_text.color = color = Material.color(custom_color)
                                bckgr_mouse_area.cursorShape = Qt.PointingHandCursor
                            }
                        }
                    }

                }

                Button {
                    id: reverse_limit_button
                    width: button_width*1.5
                    height: button_height*2
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: margin
                    anchors.bottomMargin: margin
                    leftPadding: 5
                    rightPadding: 5

                    font.bold: true
                    font.pixelSize: 14
                    Material.background: custom_color
                    highlighted: true

                    text: "Calculate"

                    onClicked: bridge.on_action("reverse_limit")
                }

            }

        }

    }

    footer: Item
    {
        height: button_height
    }

}
