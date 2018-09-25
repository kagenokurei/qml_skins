import QtQuick 1.1

MouseArea {
    id: btnArea
    hoverEnabled: true

    property string defaultImage: ""
    property string hoverImage: defaultImage
    property string downImage: defaultImage
    property string disabledImage: defaultImage

    //hover code
    onEntered: {
        btnImg.source = hoverImage;
    }

    //hover exit
    onExited: {
        btnImg.source = defaultImage;
    }

    //released code
    onReleased: {
        btnImg.source = defaultImage;
    }

    //pressed code
    onPressed: {
        btnImg.source = downImage;
    }

    onEnabledChanged: {
        if(btnArea.enabled)
            btnImg.source = defaultImage;
        else
            btnImg.source = disabledImage;
    }

    Component.onCompleted: {
        if(btnArea.enabled)
            btnImg.source = defaultImage;
        else
            btnImg.source = disabledImage;
    }

    Image {
        id: btnImg
        width: btnArea.width
        height: btnArea.height
        source: defaultImage
        sourceSize.width: width
        sourceSize.height: height
        scale: btnArea.pressed ? 0.97 : (btnArea.containsMouse ? 1.03 : 1)
        smooth: btnArea.pressed
        Component.onCompleted: cppWindow.setItemCursor(btnArea, 13);
    }
}
