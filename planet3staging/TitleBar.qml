import QtQuick 1.1

MouseArea {
    id: titleBarRegion
    property variant clickPos: "1,1"
    onPressed: {
        clickPos  = Qt.point(mouse.x,mouse.y);
    }
    onPositionChanged: {
        var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)
        cppWindow.moveWindow(delta);
    }
}
