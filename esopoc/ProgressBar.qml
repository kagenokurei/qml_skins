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
        width: progressBar.width;
        height: progressBar.height

        Image {
            id: progressImg
            x: 62 - (progressBar.width) + ((progressBar.width - 62) * barValue / 100)
            width: progressBar.width
            height: progressBar.height
            source: barImage
        }
    }
}
