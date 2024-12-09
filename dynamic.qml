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
    //    property int custom_color: Material.DeepOrange

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

                RowLayout {
                    id: dynamic_row_layout
                    anchors.fill: parent
                    anchors.leftMargin: margin
                    anchors.rightMargin: margin
                    anchors.bottomMargin: button_height
                    spacing: margin

                    Item {
                        id: lable_item
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredWidth: 100

                        Label {
                            id: distance_label
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

                        TextField {
                            id: distance_1_text
                            width: button_width*2
                            height: button_height
                            anchors.top: parent.top
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
                            anchors.left: parent.left
                            anchors.top: time_1_text.bottom
                            anchors.leftMargin: margin
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
                            anchors.left: parent.left
                            anchors.top: coefficient_1_label.bottom
                            anchors.leftMargin: margin
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

                        TextField {
                            id: distance_2_text
                            width: button_width*2
                            height: button_height
                            anchors.top: parent.top
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
                            anchors.left: parent.left
                            anchors.top: time_2_text.bottom
                            anchors.leftMargin: margin
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

                    source: "profile.png"
                }

            }
        }

        ColumnLayout {
            id: right_column_layout
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 100
            spacing: margin

        }

    }

    footer: Item
    {
        height: button_height
    }

}
