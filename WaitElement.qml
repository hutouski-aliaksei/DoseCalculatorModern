import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Popup{
    id: waitRoot
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
