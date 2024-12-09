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
    title: "DoseCalculator 0.2.0"

    maximumHeight: height
    maximumWidth: width
    minimumHeight: height
    minimumWidth: width

    property int button_width: 100
    property int button_height: 30
    property int custom_color: Material.Indigo
    property int margin: 10
    property var waiting: bridge.wait

    Material.theme: Material.Light
    Material.accent: custom_color

    Popup{
        id: wait_popup
        modal: false
        width: 200
        height: 200
        anchors.centerIn: parent

        contentItem:
            Image {
            id: loading
            anchors.fill: parent
            source: "qrc:/user_avatar.png"
            opacity: 0.5
            NumberAnimation on rotation {
                from: 0
                to: 360
                running: loading.visible == true
                loops: Animation.Infinite
                duration: 2000
            }
        }
        background: Rectangle{
            color: "transparent"
            border.color: "transparent"
            radius: width * 0.5
        }
        onOpened: {
            console.debug("popup ready");
        }
        onClosed: {
            console.debug("popup hide");
        }
    }


    onWaitingChanged: {
        if (waiting) {
           wait_popup.open()
        }
        else {
            wait_popup.close()
        }
    }

    function change_view(ind) {
        switch (ind) {
        case 0:
             main_layout.replace("der.qml")
            break
        case 1:
             main_layout.replace("dynamic.qml")
            break
        case 2:
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

        TabButton {
            text: "Dynamic"
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
