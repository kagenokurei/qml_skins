import QtQuick 1.1

Rectangle {
    id: progressBar
    property string barImage: ""
    property double barValue: 100
    color: "transparent"

    Rectangle {
        id: clipRect
        color: "#00000000"
        clip: true
        width: progressBar.width * (barValue / 100);
        height: progressBar.height

        Image {
            id: progressImg
            width: progressBar.width
            height: progressBar.height
            source: barImage
        }
    }
}
