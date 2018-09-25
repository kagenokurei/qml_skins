import QtQuick 1.1

import QtWebKit 1.0

import BRTools 1.0

Rectangle {
    id: mainRect
    property string webURL: "http://www.tantrarumble.com/client/launcher/"

    Flickable {
        id: browserFlickable
        interactive: false
        boundsBehavior: Flickable.StopAtBounds
        contentWidth: webView.width
        anchors.fill: parent
        contentHeight: webView.height

        Behavior on contentY {
            id: verticalScrollBehavior

            NumberAnimation {
                duration: 100
            }

        }

        pressDelay: 0

        Timer {
            id: reloadTimer
            interval: 5000
            repeat: true
            running: true
            triggeredOnStart: true
            onTriggered: {
                webView.reload();
            }
        }

        WebView {
            id: webView
            url: webURL
            preferredWidth: 980
            preferredHeight: browserFlickable.height
            pressGrabTime: 0

            onLoadFinished: {
                reloadTimer.stop();
                evaluateJavaScript(' \
             var els = document.getElementsByTagName("a"); \
             for (var i in els){ \
             if(els[i].hasAttribute("href")) { \
             els[i].onclick = function(e){e.preventDefault(); \
             qml.qmlCall(this.getAttribute("href")); \
             return false;} \
             } \
             } \
             ')
                enabled = true;
                background.visible = false;
            }

            javaScriptWindowObjects: QtObject {
                WebView.windowObjectName: "qml"

                function qmlCall(url) {
//                    if(url.indexOf("javascript:") === 0)
//                        return;
                    console.log("opening URL in another window: " + url);
                    Qt.openUrlExternally(url)
                }
            }

        }

        Image {
            id: background
            x: 0
            y: 0
            source: "background.png"
            opacity: 1

            Image {
                id: go_logo
                x: 779
                y: -18
                source: "go_logo.png"
            }

            Image {
                id: logo
                source: "logo.png"
                x: 3
                y: 12
                opacity: 1
            }

            Image {
                id: bg
                x: 337
                y: 50
                source: "bg.png"
            }
        }

    }

    WheelArea {
        anchors.fill: parent
        onVerticalWheel: {
            verticalScrollBehavior.enabled = true;
            console.log("wheel delta = " + delta);
            var y = browserFlickable.contentY - delta;
            y = Math.max( 0, y );
            y = Math.min( y, browserFlickable.contentHeight - verticalScrollBar.height );
            browserFlickable.contentY = y;
        }
    }

    Item {
        id: verticalScrollBar
        width: 12
        z: 100
        anchors.right: parent.right
        height: mainRect.height
        property variant orientation: Qt.Vertical
        visible : false
        opacity: 1
        function position() {
            var ny = 0;
            if (verticalScrollBar.orientation == Qt.Vertical)
                ny = browserFlickable.visibleArea.yPosition * verticalScrollBar.height;
            else
                ny = browserFlickable.visibleArea.xPosition * verticalScrollBar.width;
            if (ny > 2) return ny; else return 2;
        }
        function size() {
            var nh, ny;
            if (verticalScrollBar.orientation == Qt.Vertical)
                nh = browserFlickable.visibleArea.heightRatio * verticalScrollBar.height;
            else
                nh = browserFlickable.visibleArea.widthRatio * verticalScrollBar.width;
            if (verticalScrollBar.orientation == Qt.Vertical)
                ny = browserFlickable.visibleArea.yPosition * verticalScrollBar.height;
            else
                ny = browserFlickable.visibleArea.xPosition * verticalScrollBar.width;
            if (ny > 3) {
                var t;
                if (verticalScrollBar.orientation == Qt.Vertical)
                    t = Math.ceil(verticalScrollBar.height - 3 - ny);
                else
                    t = Math.ceil(verticalScrollBar.width - 3 - ny);
                if (nh > t) return t; else return nh;
            }
            else return nh + ny;

        }

        Rectangle {
            anchors.fill: parent;
            color: "white";
            opacity: 1
        }

        Rectangle {
            color: "black"
            x: verticalScrollBar.orientation == Qt.Vertical ? 2 : verticalScrollBar.position()
            width: verticalScrollBar.orientation == Qt.Vertical ? verticalScrollBar.width - 4 : verticalScrollBar.size()
            y: verticalScrollBar.orientation == Qt.Vertical ? verticalScrollBar.position() : 2
            height: verticalScrollBar.orientation == Qt.Vertical ? verticalScrollBar.size() : verticalScrollBar.height - 4
        }

        MouseArea
        {
            anchors.fill: parent
            property variant clickPos: "1,1"
            property variant startPos

            onPressed: {
                clickPos = Qt.point(mouse.x,mouse.y)
                startPos = Qt.point(browserFlickable.contentX, browserFlickable.contentY)
            }

            onPositionChanged: {
                var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)
                verticalScrollBehavior.enabled = false;

                if (verticalScrollBar.orientation == Qt.Vertical) {
                    var y = startPos.y + delta.y / browserFlickable.visibleArea.heightRatio;
                    y = Math.max( 0, y );
                    y = Math.min( y, browserFlickable.contentHeight - verticalScrollBar.height );
                    browserFlickable.contentY = y;
                }

                else {
                    var x = startPos.x + delta.x;
                    x = Math.max( 0, x );
                    x = Math.min( x, browserFlickable.contentWidth - verticalScrollBar.width );
                    browserFlickable.contentX = x;
                }
            }


            onClicked: {
                var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)
                verticalScrollBehavior.enabled = false;

                if ( delta.x == 0 && delta.y == 0 ) {
                    if (verticalScrollBar.orientation == Qt.Vertical) {
                        console.log(mouseY, position())
                        var y = browserFlickable.contentY + verticalScrollBar.height * (mouseY > position() ? 1 : -1);
                        y = Math.max( 0, y );
                        y = Math.min( y, browserFlickable.contentHeight - verticalScrollBar.height );
                        browserFlickable.contentY = y;
                    }

                    else {
                        var x = browserFlickable.contentX + verticalScrollBar.width * (mouseX > position() ? 1 : -1);
                        x = Math.max( 0, x );
                        x = Math.min( x, browserFlickable.contentWidth - verticalScrollBar.width );
                        browserFlickable.contentX = x;
                    }
                }
            }
        }
    }
}
