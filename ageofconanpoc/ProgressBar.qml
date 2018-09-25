import QtQuick 1.1

Rectangle {
    id: progressBar
    color: "#00000000"
    property string barImage: ""
    property double barValue: 30

    Rectangle {
        id: clipRect
        color: "#00000000"
        clip: true
        width: progressBar.width
        height: progressBar.height * (barValue / 100)
        anchors.bottom: progressBar.bottom

        Image {
            id: progressImg
            width: progressBar.width
            height: progressBar.height
            source: barImage
            anchors.bottom: clipRect.bottom
        }
    }
}
