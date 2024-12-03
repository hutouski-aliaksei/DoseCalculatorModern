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
                Layout.preferredHeight: 50
                Material.elevation: 5
                Material.background: Material.color(custom_color, Material.Shade50)

                Label {
                    id: catalogue_label
                    width: button_width
                    height: button_height
                    anchors.left: parent.left
                    anchors.top: parent.top
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
                    anchors.top: catalogue_label.top
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
                Layout.preferredHeight: 250
                Material.elevation: 5
                Material.background: Material.color(custom_color, Material.Shade50)


                Label {
                    id: parameers_label
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
                    anchors.top: parameers_label.bottom
                    anchors.leftMargin: margin

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
//                    currentText: bridge.view_array[1]
                    onActivated: {
//                        bridge.on_source_changed(currentIndex)
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
            }


        }

        ColumnLayout {
            id: rightt_column_layout
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 200
            spacing: margin

        }

    }


    footer: Item
    {
        height: button_height
    }
}
