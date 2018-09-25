import QtQuick 1.1

Rectangle {
    id: statusTextRect
    color: "transparent"

    property string textFont: "Arial"
    property int fontPxSize: 10
    property bool fontBold: false
    property bool fontItalic: false
    property string fontColor: "#ffffff"
    property real fontOpacity: 1

    function addText(strText) {
        statusTextModel.insert(0,
                               {"textToDisplay": strText});
    }

    ListModel {
        id: statusTextModel
    }

    Component {
        id: statusTextDelegate
        Text {
            x: statusText.width
            text: textToDisplay
            smooth: true
            wrapMode: Text.WordWrap
            rotation: 180
            transformOrigin: Item.Left
            clip: false
            width: statusText.width
            font.pixelSize: fontPxSize
            font.family: textFont
            font.bold: fontBold
            font.italic: fontItalic
            color: fontColor
            opacity: fontOpacity
        }
    }

    ListView {
        id: statusText
        width: statusTextRect.width
        height: statusTextRect.height
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        rotation: 180
        model: statusTextModel
        delegate: statusTextDelegate
    }
}
