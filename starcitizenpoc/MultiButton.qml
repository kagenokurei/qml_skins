import QtQuick 1.1

MouseArea {
    id: btnArea
    hoverEnabled: true

    property string defaultImage: ""
    property string disabledImage: ""
    property string hoverImage: ""

    function refreshImage() {
        if(btnArea.enabled) {
            if(btnArea.containsMouse)
                btnImg.source = hoverImage;
            else
                btnImg.source = defaultImage;
        } else {
            btnImg.source = disabledImage;
            btnImg.scale = 1.0;
        }
    }

    //hover code
    onEntered: {
        if(btnArea.enabled)
            btnImg.source = hoverImage;
    }

    //hover exit
    onExited: {
        if(btnArea.enabled)
            btnImg.source = defaultImage;
    }

    //released code
    onReleased: {
        if(btnArea.enabled)
            btnImg.scale = 1.0;
    }

    //pressed code
    onPressed: {
        if(btnArea.enabled)
            btnImg.scale = 0.97;
    }

    onEnabledChanged: {
        refreshImage();
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
        smooth: scale != 1.0
        Component.onCompleted: cppWindow.setItemCursor(btnArea, 13);
        opacity: btnArea.enabled ? 1 : 0.3
    }
}
