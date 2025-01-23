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
            Layout.preferredWidth: 100
            spacing: margin

            Pane {
                id: catalogue_pane
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 75
                Material.elevation: 5
                Material.background: Material.color(custom_color, Material.Shade50)

                Label {
                    id: catalogue_label
                    width: button_width
                    height: button_height
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: margin

                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                    font.pixelSize: 14
                    Material.foreground: custom_color

                    text: "Sources catalogue"
                }

                ComboBox {
                    id: catalogue_combobox
                    width: button_width*2
                    height: button_height
                    anchors.verticalCenter: catalogue_label.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: margin
                    model: bridge.catalogue9000
                    currentIndex: bridge.view_array9000[0]
                    enabled: bridge.db_exists
                    onActivated: {
                        bridge.on_action(currentIndex+10000)
                    }
                }

            }

            Pane {
                id: parameters_pane
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 520
                Material.elevation: 5
                Material.background: Material.color(custom_color, Material.Shade50)


                Label {
                    id: parameters_label
                    width: button_width
                    height: button_height
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top

                    horizontalAlignment: Text.AlignHCenter
                    font.bold: true
                    font.pixelSize: 16
                    Material.foreground: custom_color

                    text: "Source parameters"
                }

                Label {
                    id: isotope_label
                    width: button_width
                    height: button_height
                    anchors.left: parent.left
                    anchors.top: parameters_label.bottom
                    anchors.leftMargin: margin
                    anchors.topMargin: margin

                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                    font.pixelSize: 14
                    Material.foreground: custom_color

                    text: "Isotope"
                }

                ComboBox {
                    id: isotope_combobox
                    width: button_width*2
                    height: button_height
                    anchors.top: isotope_label.top
                    anchors.right: parent.right
                    anchors.rightMargin: margin
                    model: bridge.isotope_list
                    currentIndex: indexOfValue(bridge.view_array9000[1])
                    enabled: false
                    Component.onCompleted: {
                        if (bridge.db_exists) {
                            bridge.on_action("parameters9000")
                        }
                    }
                }

                Label {
                    id: halflife_label
                    width: button_width
                    height: button_height
                    anchors.left: parent.left
                    anchors.top: isotope_label.bottom
                    anchors.leftMargin: margin
                    anchors.topMargin: margin

                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                    font.pixelSize: 14
                    Material.foreground: custom_color

                    text: "Halflife, days"
                }

                TextField {
                    id: halflife_text
                    width: button_width*2
                    height: button_height
                    anchors.top: halflife_label.top
                    anchors.right: parent.right
                    anchors.rightMargin: margin
                    enabled: false
                    text: bridge.view_array9000[2]
                    color: custom_color
                }

                Label {
                    id: prod_date_label
                    width: button_width
                    height: button_height
                    anchors.left: parent.left
                    anchors.top: halflife_label.bottom
                    anchors.leftMargin: margin
                    anchors.topMargin: margin

                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                    font.pixelSize: 14
                    Material.foreground: custom_color

                    text: "Production date"
                }

                TextField {
                    id: prod_date_text
                    width: button_width*2
                    height: button_height
                    anchors.top: prod_date_label.top
                    anchors.right: parent.right
                    anchors.rightMargin: margin
                    text: bridge.view_array9000[3]
                    color: custom_color
                    enabled: false
                }

                Label {
                    id: cur_date_label
                    width: button_width
                    height: button_height
                    anchors.left: parent.left
                    anchors.top: prod_date_label.bottom
                    anchors.leftMargin: margin
                    anchors.topMargin: margin

                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                    font.pixelSize: 14
                    Material.foreground: custom_color

                    text: "Current date"
                }

                TextField {
                    id: cur_date_text
                    width: button_width*2
                    height: button_height
                    anchors.top: cur_date_label.top
                    anchors.right: parent.right
                    anchors.rightMargin: margin
                    text: bridge.view_array9000[4]
                    color: custom_color
                    validator: RegularExpressionValidator { regularExpression: /(\d{1,2})([\/]\d{1,2})([\/]\d{4,4})$/ }
                    enabled: bridge.db_exists
                    onTextEdited: {
                        if (acceptableInput) {
                            bridge.view_array9000[4] = text
                            bridge.on_action("parameters9000")
                        }
                    }
                }
            }

            Pane {
                id: shield_pane
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 350
                Material.elevation: 5
                Material.background: Material.color(custom_color, Material.Shade50)


                Label {
                    id: shield_label
                    width: button_width
                    height: button_height
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top

                    horizontalAlignment: Text.AlignHCenter
                    font.bold: true
                    font.pixelSize: 16
                    Material.foreground: custom_color

                    text: "Shield parameters"
                }

                Label {
                    id: material_label
                    width: button_width
                    height: button_height
                    anchors.left: parent.left
                    anchors.top: shield_label.bottom
                    anchors.leftMargin: margin
                    anchors.topMargin: margin

                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                    font.pixelSize: 14
                    Material.foreground: custom_color

                    text: "Material"
                }

                ComboBox {
                    id: material_combobox
                    width: button_width*2
                    height: button_height
                    anchors.top: material_label.top
                    anchors.right: parent.right
                    anchors.rightMargin: margin
                    model: bridge.shields_list
                    currentIndex: indexOfValue(bridge.view_array9000[5])
                    enabled: bridge.db_exists
                    onActivated: {
                        bridge.view_array9000[5] = currentValue
                        bridge.on_action("parameters9000")
                    }
                }

                Label {
                    id: thickness_label
                    width: button_width
                    height: button_height
                    anchors.left: parent.left
                    anchors.top: material_label.bottom
                    anchors.leftMargin: margin
                    anchors.topMargin: margin

                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                    font.pixelSize: 14
                    Material.foreground: custom_color

                    text: "Thickness, cm"
                }

                TextField {
                    id: thickness_text
                    width: button_width*2
                    height: button_height
                    anchors.top: thickness_label.top
                    anchors.right: parent.right
                    anchors.rightMargin: margin
                    text: bridge.view_array9000[6]
                    color: custom_color
                    validator: DoubleValidator {
                        bottom: 0
                    }
                    enabled: bridge.db_exists
                    onTextEdited: {
                        if (acceptableInput) {
                            if (text * 1 > bridge.view_array9000[7] * 1) {
                                text = bridge.view_array9000[7]
                            }
                            bridge.view_array9000[6] = text
                            bridge.on_action("parameters9000")
                        }
                    }
                }

                Label {
                    id: distance_label
                    width: button_width
                    height: button_height
                    anchors.left: parent.left
                    anchors.top: thickness_label.bottom
                    anchors.leftMargin: margin
                    anchors.topMargin: margin

                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                    font.pixelSize: 14
                    Material.foreground: custom_color

                    text: "Distance, cm"
                }

                TextField {
                    id: distance_text
                    width: button_width*2
                    height: button_height
                    anchors.top: distance_label.top
                    anchors.right: parent.right
                    anchors.rightMargin: margin
                    text: bridge.view_array9000[7]
                    color: custom_color
                    validator: DoubleValidator {
                        bottom: 0.1
                    }
                    enabled: bridge.db_exists
                    onTextEdited: {
                        if (acceptableInput) {
                            bridge.view_array9000[7] = text
                            if (text * 1 < bridge.view_array9000[6] * 1) {
                                bridge.view_array9000[6] = text
                                thickness_text.text = bridge.view_array9000[6]
                            }
                            bridge.on_action("der9000")
                        }
                    }
                }

                Label {
                    id: dose_type_label
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

                    text: "Dose type"
                }

                ComboBox {
                    id: dose_type_combobox
                    width: button_width*2
                    height: button_height
                    anchors.top: dose_type_label.top
                    anchors.right: parent.right
                    anchors.rightMargin: margin
                    model: bridge.dose_types
                    currentIndex: indexOfValue(bridge.view_array9000[8])
                    enabled: bridge.db_exists
                    onActivated: {
                        bridge.view_array9000[8] = currentValue
                        bridge.on_action("parameters9000")
                    }
                }
            }


            Pane {
                id: dose_pane
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 150
                Material.elevation: 5
                Material.background: Material.color(custom_color, Material.Shade50)


                Label {
                    id: dose_label
                    width: button_width
                    height: button_height
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top

                    horizontalAlignment: Text.AlignHCenter
                    font.bold: true
                    font.pixelSize: 16
                    Material.foreground: custom_color

                    text: "Search DER"
                }


                Label {
                    id: desired_der_label
                    width: button_width
                    height: button_height
                    anchors.left: parent.left
                    anchors.top: dose_label.bottom
                    anchors.leftMargin: margin
                    anchors.topMargin: margin

                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                    font.pixelSize: 14
                    Material.foreground: custom_color

                    text: "Desired DER, mSv/h"
                }

                TextField {
                    id: desired_der_text
                    width: button_width*2
                    height: button_height
                    anchors.top: desired_der_label.top
                    anchors.right: parent.right
                    anchors.rightMargin: margin
                    text: bridge.view_array9000[9]
                    color: custom_color
                    validator: DoubleValidator {
                        bottom: 0.00001
                    }
                    enabled: bridge.db_exists
                    onTextEdited: {
                        if (acceptableInput) {
                            bridge.view_array9000[9] = text
                            bridge.on_action("parameters9000")
                        }
                    }
                }
            }


        }

        ColumnLayout {
            id: right_column_layout
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 200
            spacing: margin

            Pane {
                id: results_pane
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 200
                Material.elevation: 5
                Material.background: Material.color(custom_color, Material.Shade50)

                RowLayout {
                    id: results_row_layout
                    anchors.fill: parent
                    anchors.leftMargin: margin
                    anchors.rightMargin: margin
                    anchors.bottomMargin: button_height
                    spacing: margin

                    Item {
                        id: der_item
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredWidth: 200


                        Label {
                            id: der_text_label
                            width: button_width
                            height: button_height
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.verticalCenter
                            anchors.topMargin: margin

                            horizontalAlignment: Text.AlignHCenter
                            font.bold: true
                            font.pixelSize: 22
                            Material.foreground: custom_color

                            text: "Dose equivalent rate, \u03BCSv/h"
                        }

                        Label {
                            id: der_label
                            property var result_der: bridge.view_array9000[9]*1
                            width: button_width
                            height: button_height
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: der_text_label.bottom
                            anchors.topMargin: margin

                            horizontalAlignment: Text.AlignHCenter
                            font.bold: true
                            font.pixelSize: 28
                            Material.foreground: custom_color

                            text: result_der
                            onResult_derChanged: {
                                console.debug(result_der)
                                if (result_der < 1000) {
                                    der_label.text = result_der.toFixed(3)
                                    der_text_label.text = "Dose equivalent rate, mSv/h"
                                }
                                if (result_der < 1) {
                                    der_label.text = (result_der*1000).toFixed(3)
                                    der_text_label.text = "Dose equivalent rate, \u03BCSv/h"
                                }
                                if (result_der >= 1000) {
                                    der_label.text = (result_der/1000).toFixed(3)
                                    der_text_label.text = "Dose equivalent rate, Sv/h"
                                }
                            }
                        }
                    }

                    Item {
                        id: distance_item
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredWidth: 200


                        Label {
                            id: distance_result_text_label
                            width: button_width
                            height: button_height
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.verticalCenter
                            anchors.topMargin: margin

                            horizontalAlignment: Text.AlignHCenter
                            font.bold: true
                            font.pixelSize: 22
                            Material.foreground: custom_color

                            text: "Distance, cm"
                        }

                        Label {
                            id: distance_result_label
                            width: button_width
                            height: button_height
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: distance_result_text_label.bottom
                            anchors.topMargin: margin

                            horizontalAlignment: Text.AlignHCenter
                            font.bold: true
                            font.pixelSize: 28
                            Material.foreground: custom_color

                            text: bridge.view_array9000[7]
                        }
                    }
                }

            }

            Pane {
                id: table_pane
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 500
                Material.elevation: 5
                Material.background: Material.color(custom_color, Material.Shade50)

                ListView {
                    id: lines_view
                    model: bridge.view_table9000
                    anchors.fill: parent
                    anchors.topMargin: margin
                    anchors.leftMargin: margin
                    anchors.bottomMargin: button_height+margin
                    anchors.rightMargin: margin
                    flickableDirection: Flickable.VerticalFlick
                    boundsBehavior: Flickable.StopAtBounds
                    headerPositioning: ListView.OverlayHeader

                    header:     Label {
                        id: lines_header_label
                        height: button_height
                        width: lines_view.width
                        text: "Distance, cm\t\tOriginal Kerma Gy/s\t\tCurrent DER, Sv/h"
                        font.bold: true
                        font.pixelSize: 14
                        color: Material.color(custom_color)
                        background: Rectangle {
                            color: Material.color(custom_color, Material.Shade50)
                            y: -15
                            height: button_height*1.5
                        }
                        z: 2
                    }

                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    ScrollBar.vertical: ScrollBar {}

                    delegate: Label {
                        required property int index
                        property var backData: bridge.view_table9000
                        font.pixelSize: 14
                        color: Material.color(custom_color)
                        onBackDataChanged: {
                            text = lines_view.model[index]
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
