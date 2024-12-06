import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material

ApplicationWindow {
    id: main_window
    width: 1280
    height: 768
    x: 100
    y: 100
    visible: true
    title: "DoseCalculator 0.1.3"

    property int button_width: 100
    property int button_height: 30
    property int custom_color: Material.Indigo
    property int margin: 10

    Material.theme: Material.Light
    Material.accent: custom_color

    function change_view(ind) {
        switch (ind) {
        case 0:
             main_layout.replace("der.qml")
            break
        case 1:
             main_layout.replace("coefficients.qml")
            break
        default:
            break
        }

    }

    TabBar {
        id: bar
        width: parent.width
        contentHeight: 30
        onCurrentIndexChanged: {
            change_view(currentIndex)
        }

        TabButton {
            text: "DER"
        }

//        TabButton {
//            text: "Coefficients"
//        }

    }

    StackView {
        id: main_layout
        width: parent.width
        anchors.top: bar.bottom
        anchors.bottom: parent.bottom
        Component.onCompleted: {
        }
        initialItem: "der.qml"

    }

}
