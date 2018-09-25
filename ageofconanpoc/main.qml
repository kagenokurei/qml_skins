import QtQuick 1.1

Item {
    width:700
    height:582

    /*
    REQUIRED FUNCTIONS
    */
    function setStageText(textToSet) {
        preinstalllabel.text = textToSet;
        preinstalllabel.text = preinstalllabel.text.replace(":", "");
        preinstalllabel.text += " @";
    }

    function setSubStageText(textToSet) {

    }

    function setMainProgress(progress) {
        var cStage = brQuery.getStage();
        if(cStage == 101 || cStage == 102) //we use custom code for these stages
            return;

        full.barValue = progress;
        setMainProgressText(Math.round(progress) + " percent");
    }

    function setMainProgressText(textToSet) {
        preinstalltext.text = textToSet;
//        preinstalltext.text.replace("%", " percent");
    }

    function setSubProgress(progress) {

    }

    function setSubProgressText(textToSet) {

    }

    function setXferSpeedText(textToSet) {
        speedtext.text = textToSet;
    }

    function appendStatusText(textToAppend) {
        logs.addText(textToAppend);
    }

    function setPlayEnable(bEnable) {
        playBtn.enabled = bEnable;
    }

    function setPauseState(bIsPaused) {
        pauseBtn.isPaused = bIsPaused;
    }

    function setPauseEnable(bIsEnabled) {
        pauseBtn.enabled = bIsEnabled;
    }

    /*
    END REQUIRED FUNCTIONS
    */

    Timer {
        id: main_ui_timer
        interval: 500
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: {
            var cStage = brQuery.getStage();
            if(cStage == 101 || cStage == 102) { //we use custom code for these stages
                var totalBytes = brQuery.getControllerTotalBytes();
                if(totalBytes <= 0)
                    return;

                var totalMBytes = totalBytes / 1048576;
                var pctRecvd = 100 - (brQuery.getControllerPercentageRecvd() / 100);
                var receivedMBytes = pctRecvd * totalMBytes / 100;
                var preInstallPct = brQuery.getGenericUalt1(5/*XFER*/) / 10000;

                //unpacked bar
                full.barValue = pctRecvd;
                setMainProgressText(Math.round(pctRecvd) + " percent");
                downloadtext.text = receivedMBytes.toFixed(2) + " mb";
                barMarker.preInstallPct = preInstallPct;

                downloadlabel.visible = true;
            } else {
                downloadlabel.visible = false;
                barMarker.preInstallPct = 0;
            }
        }
    }

    Image {
        id: background
        source: "bg_black.png"
        width: 682
        height: 562
        x: 9
        y: 0
        opacity: 1
    }

    AnimatedImage {
        x: -146
        y: 95
        width: 700
        height: 370
        fillMode: Image.PreserveAspectFit
        source: "ember.gif"
        mirror: true
        smooth: true
    }

    Image {
        id: background2
        source: "bg_trans.png"
        width: 682
        height: 562
        x: 9
        y: 0
        opacity: 1
    }

    TitleBar {
        anchors.fill: parent
    }

    Button {
        id: closeBtn
        x: 662
        y: 100
        width: 14
        height: 14
        opacity: 1

        defaultImage: "close.png"
        disabledImage: "close.png"

        onClicked: Qt.quit();
    }

    Button {
        id: minimizeBtn
        x: 647
        y: 100
        width: 14
        height: 14
        opacity: 1

        defaultImage: "minimize.png"
        disabledImage: "minimize.png"

        onClicked: cppWindow.minimizeWindow();
    }

    Text {
        id: downloadlabel
        text: "Download @"
        horizontalAlignment: Text.AlignRight
        font.pixelSize: 9
        font.family: wind.name
        color: "#ffffff"
        smooth: true
        x: 569
        y: 163
        opacity: 1
        visible: false
    }

    Text {
        id: preinstalllabel
        text: ""
        font.pixelSize: 9
        font.family: wind.name
        color: "#ffffff"
        smooth: true
        x: 292
        y: 187
        opacity: 1
    }

    Text {
        id: speedlabel
        text: "Speed @"
        horizontalAlignment: Text.AlignRight
        font.pixelSize: 9
        font.family: wind.name
        color: "#ffffff"
        smooth: true
        x: 595
        y: 211
        opacity: 1
        visible: speedtext.text.trim().length != 0
    }

    Text {
        id: downloadtext
        text: "7023.23 mb"
        horizontalAlignment: Text.AlignRight
        font.pixelSize: 15
        font.family: wind.name
        color: "#ffffff"
        smooth: true
        x: 545
        y: 170
        opacity: 1
        width: 89
        height: 34
        visible: downloadlabel.visible
    }

    Text {
        id: preinstalltext
        text: "70 percent"
        font.pixelSize: 15
        font.family: wind.name
        color: "#ffffff"
        smooth: true
        x: 291
        y: 197
        opacity: 1
    }

    Text {
        id: speedtext
        text: "2.4 mbps"
        horizontalAlignment: Text.AlignRight
        font.pixelSize: 15
        font.family: wind.name
        color: "#ffffff"
        smooth: true
        x: 574
        y: 222
        opacity: 1
    }

    StatusBox {
        id: logs
        textFont: "Tahoma"
        fontPxSize: 10
        fontColor: "#ffffff"

        x: 323
        y: 283

        width: 261
        height: 72

        opacity: 1
    }

    MultiButton {
        id: playBtn
        x: 274
        y: 394
        width: 236
        height: 71
        opacity: 1
        enabled: false

        defaultImage: "play.png"
        disabledImage: "play_disabled.png"
        hoverImage: "play_hover.png"

        onClicked: brCmd.brPlay("");
    }

    MultiButton {
        id: pauseBtn
        x: 516
        y: 401
        width: 80
        height: 53
        opacity: 1

        onClicked: {
            isPaused = brCmd.brTogglePause();
            refreshImage();
        }
        property bool isPaused: false

        defaultImage: isPaused ? "resume.png" : "pause.png"
        disabledImage: isPaused ? "resumedisabled.png" : "pause_disabled.png"
        hoverImage: isPaused ? "resumehover.png" : "pause_hover.png"
    }

    Image {
        id: empty
        source: "empty.png"
        x: 394
        y: 154
        opacity: 1
    }

    ProgressBar {
        id: full
        barImage: "full.png"
        x: 394
        y: 154
        width: 117
        height: 114
    }

    Rectangle {
        id: barMarker
        property real preInstallPct: 0
        color: "transparent"

        x: 383
        y: 152
        width: 16
        height: 119

        Rectangle {
            anchors.bottom: barMarker.bottom
            anchors.left: barMarker.left
            anchors.right: barMarker.right
            height: barMarker.height * barMarker.preInstallPct
            color: "transparent"
            clip: true

            Image {
                id: redmarker
                source: "redmarker.png"
                width: 16
                height: 119
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                opacity: 1
            }
        }

        Rectangle {
            anchors.top: barMarker.top
            anchors.left: barMarker.left
            anchors.right: barMarker.right
            height: barMarker.height - (barMarker.height * barMarker.preInstallPct)
            color: "transparent"
            clip: true

            Image {
                id: greenmarker
                source: "greenmarker.png"
                width: 16
                height: 119
                anchors.top: parent.top
                anchors.left: parent.left
                opacity: 1
            }
        }

        Image {
            id: pointer
            source: "pointer.png"
            x: 0
            y: barMarker.height - (barMarker.height * barMarker.preInstallPct) - 2
            opacity: 1
            visible: barMarker.preInstallPct != 0
        }
    }

    FontLoader {
        id: wind
        source: "wind.ttf"
    }
}

