import QtQuick 1.1

MouseArea {
    id: btnArea
    hoverEnabled: true

    property string defaultImage: ""
    property string disabledImage: ""

    //hover code
    onEntered: {
        if(btnArea.enabled)
            btnImg.scale = 1.03;
    }

    //hover exit
    onExited: {
        if(btnArea.enabled)
            btnImg.scale = 1.0;
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
        if(btnArea.enabled) {
            btnImg.source = defaultImage
            if(btnArea.containsMouse)
                btnImg.scale = 1.03;
            else
                btnImg.scale = 1.0;
        } else {
            btnImg.source = disabledImage;
            btnImg.scale = 1.0;
        }
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
    }
}
