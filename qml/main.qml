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
    title: "DoseCalculator 0.3.0"

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

    property var database: bridge.db_exists

    onDatabaseChanged:  {
        if (!database) {
        db_popup.open()
        }
    }

    Popup {
            id: db_popup
            width: button_width*4
            height: button_height*7
            anchors.centerIn: parent
            modal: true
            focus: true
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
            // Material.background: Material.color(custom_color, Material.Shade50)

            background: Rectangle {
                width: button_width*4
                height: button_height*7
                color: Material.color(custom_color, Material.Shade50)
                radius: 5
            }

            Label {
                id: popup_text
                width: button_width*3
                height: button_height
                Material.foreground: custom_color
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: margin*5
                text: "No Database found"
                wrapMode: "Wrap"
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 20
            }

            Button {
                id: close_popup_button
                width: button_width*1.5
                height: button_height*2
                text: "Close"
                font.bold: true
                font.pixelSize: 14
                Material.background: custom_color
                highlighted: true
                leftPadding: 5
                rightPadding: 5
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: db_popup.close()
            }

            onClosed: {

            }

        }

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
            source: "qrc:/img/user_avatar.png"
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
             main_layout.replace("der9000.qml")
            break
        case 3:
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
            text: "Dynamic and Limits"
        }

        TabButton {
            text: "PM9000"
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
