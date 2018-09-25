import QtQuick 1.1

Rectangle {
    width: 309
    height: 72
    color: "#00000000"
    visible: true
    opacity: 1

    function setProgress(progress) {
        progressBar.barValue = progress;
        setProgressText(progress.toFixed(2) + "%");
    }

    function setProgressText(textToSet) {
        progressTxt.text = textToSet;
    }

    function setXferSpeedText(bitrate) {
        if(bitrate > 1024) { //convert to MB, long values can make the text not render
            var fVal = bitrate / 1024;
            bitrateTxt.text = fVal.toFixed(2);
            bitrateUnitTxt.text = "MB/s";
        } else {
            bitrateTxt.text = bitrate;
            bitrateUnitTxt.text = "KB/s";
        }

    }

    function getOverlayInfo() {
        return Qt.rect(overlay_info.x, overlay_info.y, overlay_info.width, overlay_info.height);
    }

    //this is important, below are the counterpart in skin.xml
    // x and y = windowposition
    // width and heith = windowscaleres
    Rectangle {
        id: overlay_info
        x: 1286
        y: 30
        width: 1920
        height: 1200
        visible: false
    }

    Image {
        id: image1
        x: 0
        y: 0
        width: 309
        height: 72
        fillMode: Image.PreserveAspectFit
        source: "overlay_background.png"

        Text {
            id: bitrateUnitTxt
            x: 241
            y: 22
            color: "#ffffff"
            text: qsTr("MB/s")
            font.pixelSize: 10
        }
    }

    Rectangle {
        x: 18
        y: 51
        width: 270
        height: 11
        color: "#00000000"
    }

    Rectangle {
        id: progressBar
        x: 23
        y: 54
        width: 260
        height: 4
        color: "#00000000"
        property double barValue: 100

        Rectangle {
            id: clipRect
            color: "#00000000"
            clip: true
            width: progressBar.width * (progressBar.barValue / 100);
            height: progressBar.height

            AnimatedImage {
                id: progressImg
                width: progressBar.width
                height: progressBar.height
                source: "progress.gif"
            }
        }
    }

    Text {
        id: progressTxt
        x: 244
        y: 39
        width: 44
        height: 12
        color: "#ffffff"
        text: qsTr("99.27%")
        horizontalAlignment: Text.AlignHCenter
        font.bold: true
        font.family: "Arial"
        font.pixelSize: 10
    }

    Text {
        id: bitrateTxt
        x: 154
        y: 18
        width: 77
        height: 24
        color: "#999999"
        text: qsTr("203")
        horizontalAlignment: Text.AlignHCenter
        font.bold: false
        font.family: digital7.name
        font.pixelSize: 26
    }

    FontLoader {
        id: digital7
        source: "DS-DIGIT.TTF"
    }
}
