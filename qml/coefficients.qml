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
        height: 50
    }


    footer: Item
    {
        height: button_height
    }
}
