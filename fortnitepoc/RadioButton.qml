import QtQuick 1.1

Rectangle {
    id: sideButton
    property string normalSrc: ""
    property string selectedSrc: ""
    property string hoverSrc: ""
    property bool selected: radioGroup.selected === sideButton
    property bool hovered: sideButtonMouseArea.containsMouse
    property Item radioGroup
    color: "transparent"
    MouseArea {
        id: sideButtonMouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: sideButton.radioGroup.selected = sideButton
    }

    Image {
        id: sideButtonImageNormal
        source: normalSrc
        anchors.left: sideButton.left
        visible: !selected
    }

    Image {
        id: sideButtonImageCheked
        source: selectedSrc
        anchors.left: sideButton.left
        visible: selected
    }

    Image {
        id: sideButtonImagehover
        source: hoverSrc
        anchors.left: sideButton.left
        visible: sideButtonMouseArea.containsMouse
    }
}
