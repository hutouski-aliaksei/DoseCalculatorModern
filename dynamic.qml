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
                id: parameters_pane
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 100
                Material.elevation: 5
                Material.background: Material.color(custom_color, Material.Shade50)
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
