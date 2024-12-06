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
            Layout.preferredWidth: 100
            spacing: margin

            Pane {
                id: catalogue_pane
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 100
                Material.elevation: 5
                Material.background: Material.color(custom_color, Material.Shade50)

                Label {
                    id: catalogue_label
                    width: button_width
                    height: button_height
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: margin
//                    anchors.topMargin: margin

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
                    model: bridge.catalogue
                    currentIndex: bridge.view_array[0]
                    onActivated: {
                        bridge.on_source_changed(currentIndex)
                    }
                }

            }

            Pane {
                id: parameters_pane
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 450
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
                    currentIndex: indexOfValue(bridge.view_array[1])
                    onActivated: {
                        bridge.view_array[1] = currentValue
                        bridge.on_action("source")
                    }
                    Component.onCompleted: {
                        bridge.on_action("source")
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
                    text: bridge.view_array[2]
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
                    text: bridge.view_array[3]
                    color: custom_color
                    validator: RegularExpressionValidator { regularExpression: /(\d{1,2})([\/]\d{1,2})([\/]\d{4,4})$/ }
                    onTextEdited: {
                        if (acceptableInput) {
                            bridge.view_array[3] = text
                            bridge.on_action("source")
                        }
                    }
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
                    text: bridge.view_array[5]
                    color: custom_color
                    validator: RegularExpressionValidator { regularExpression: /(\d{1,2})([\/]\d{1,2})([\/]\d{4,4})$/ }
                    onTextEdited: {
                        if (acceptableInput) {
                            bridge.view_array[5] = text
                            bridge.on_action("source")
                        }
                    }
                }

                Label {
                    id: orig_activity_label
                    width: button_width
                    height: button_height
                    anchors.left: parent.left
                    anchors.top: cur_date_label.bottom
                    anchors.leftMargin: margin
                    anchors.topMargin: margin

                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                    font.pixelSize: 14
                    Material.foreground: custom_color

                    text: "Original activity, Bq"
                }

                TextField {
                    id: orig_activity_text
                    width: button_width*2
                    height: button_height
                    anchors.top: orig_activity_label.top
                    anchors.right: parent.right
                    anchors.rightMargin: margin
                    text: bridge.view_array[4]
                    color: custom_color
                    validator: RegularExpressionValidator { regularExpression: /\d{1,15}/ }
                    onTextEdited: {
                        if (acceptableInput) {
                            bridge.view_array[4] = text
                            bridge.on_action("source")
                        }
                    }
                }

                Label {
                    id: cur_activity_label
                    width: button_width
                    height: button_height
                    anchors.left: parent.left
                    anchors.top: orig_activity_label.bottom
                    anchors.leftMargin: margin
                    anchors.topMargin: margin

                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                    font.pixelSize: 14
                    Material.foreground: custom_color

                    text: "Current activity, Bq"
                }

                TextField {
                    id: cur_activity_text
                    width: button_width*2
                    height: button_height
                    anchors.top: cur_activity_label.top
                    anchors.right: parent.right
                    anchors.rightMargin: margin
                    text: bridge.view_array[6]
                    color: custom_color
                    validator: RegularExpressionValidator { regularExpression: /\d{1,15}/ }
                    onTextEdited: {
                        if (acceptableInput) {
                            bridge.view_array[6] = text
                            bridge.on_action("activity")
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
                    currentIndex: indexOfValue(bridge.view_array[7])
                    onActivated: {
                        bridge.view_array[7] = currentValue
                        bridge.on_action("activity")
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
                    text: bridge.view_array[8]
                    color: custom_color
                    validator: DoubleValidator {
                        bottom: 0
                    }

                    onTextEdited: {
                        if (acceptableInput) {
                            bridge.view_array[8] = text
                            bridge.on_action("activity")
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
                    text: bridge.view_array[9]
                    color: custom_color
                    validator: DoubleValidator {
                        bottom: 0.1
                    }

                    onTextEdited: {
                        if (acceptableInput) {
                            bridge.view_array[9] = text
                            bridge.on_action("activity")
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
                    currentIndex: indexOfValue(bridge.view_array[10])
                    onActivated: {
                        bridge.view_array[10] = currentValue
                        bridge.on_action("activity")
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
                            property var result_der: bridge.view_array[12]
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
                                if (result_der < 1000) {
                                    der_label.text = result_der.toFixed(3)
                                    der_text_label.text = "Dose equivalent rate, \u03BCSv/h"
                                }
                                if (result_der >= 1000) {
                                    der_label.text = (result_der/1000).toFixed(3)
                                    der_text_label.text = "Dose equivalent rate, mSv/h"
                                }
                                if (result_der >= 1000000) {
                                    der_label.text = (result_der/1000000).toFixed(3)
                                    der_text_label.text = "Dose equivalent rate, Sv/h"
                                }
                                if (bridge.view_array[1] == "Cf-252" || bridge.view_array[1] == "Cm-244")
                                    der_label.text = "Only flux data"
                            }
                        }
                    }

                    Item {
                        id: flux_item
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredWidth: 200


                        Label {
                            id: flux_text_label
                            width: button_width
                            height: button_height
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.verticalCenter
                            anchors.topMargin: margin

                            horizontalAlignment: Text.AlignHCenter
                            font.bold: true
                            font.pixelSize: 22
                            Material.foreground: custom_color

                            text: "Flux, photons/cm\u00B2s"
                        }

                        Label {
                            id: flux_label
                            property var result_flux: bridge.view_array[11]
                            width: button_width
                            height: button_height
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: flux_text_label.bottom
                            anchors.topMargin: margin

                            horizontalAlignment: Text.AlignHCenter
                            font.bold: true
                            font.pixelSize: 28
                            Material.foreground: custom_color

                            text: result_flux
                            onResult_fluxChanged: {
                                if (result_flux < 1000) {
                                    flux_label.text = result_flux.toFixed(3)
                                    flux_text_label.text = "Flux, photons/cm\u00B2s"
                                }
                                if (result_flux >= 1000) {
                                    flux_label.text = (result_flux/1000).toFixed(3)
                                    flux_text_label.text = "Flux, photons/cm\u00B2s \u00D7 10\u00B3"
                                }
                                if (result_flux >= 1000000) {
                                    flux_label.text = (result_flux/1000000).toFixed(3)
                                    flux_text_label.text = "Flux, photons/cm\u00B2s \u00D7 10\u2076"
                                }
                            }
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
                    model: bridge.view_table
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
                        text: "Energy, keV\t\tYield, %\t\tKR, \u03BCGy/h\t\tDER, \u03BCSv/h\t\tFlux, p/cm\u00B2s"
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
                        property var backData: bridge.view_table
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
