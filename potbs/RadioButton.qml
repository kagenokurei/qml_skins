import QtQuick 1.1

Rectangle {
    id: sideButton
    property string normalImage: ""
    property string checkedImage: ""
    property RadioGroup radioGroup
    color: "transparent"
    MouseArea {
        id: sideButtonMouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: sideButton.radioGroup.selected = sideButton
    }

    Image {
        id: sideButtonImageNormal
        source: normalImage
        anchors.left: sideButton.left
        visible: !(radioGroup.selected === sideButton)
    }

    Image {
        id: sideButtonImageCheked
        source: checkedImage
        anchors.left: sideButton.left
        visible: radioGroup.selected === sideButton
    }
}
