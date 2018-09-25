import QtQuick 1.1

Item {
    id: mainRect
    width:705
    height:607

    property string stageDesc: "downloading"
    property string stageProgress: "100%"
    property string speedText: "500Mbps"

    /*
    REQUIRED FUNCTIONS
    */
    function setStageText(textToSet) {
        stageDesc = textToSet;
        stageDesc = stageDesc.replace(":", " @");
        stageDesc = stageDesc.toLowerCase();
    }

    function setSubStageText(textToSet) {

    }

    function setMainProgress(progress) {
        setMainProgressText(Math.round(progress) + "%");
        var cStage = brQuery.getStage();
        if(cStage == 101 || cStage == 102) //we use custom code for these stages
            return;

        progressOrange.barValue = progress;
        preinstall.text = mainRect.stageDesc + " " + mainRect.stageProgress;
    }

    function setMainProgressText(textToSet) {
        stageProgress = textToSet;
    }

    function setSubProgress(progress) {

    }

    function setSubProgressText(textToSet) {

    }

    function setXferSpeedText(textToSet) {
        speedText = textToSet;
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

                download.text = receivedMBytes.toFixed(2) + " MB / "  + totalMBytes.toFixed(2) + " MB";
                preinstall.text = mainRect.stageDesc + " " + mainRect.stageProgress;

                //xferred bar
                var pctXferred = brQuery.getGenericUalt2(5/*XFER*/) / 100;
                var pctPendingXfer = brQuery.getSpecUval2(5/*XFER*/) / totalBytes * 100;
                if(progressGreen.barValue == 0)
                    progressOrange.barValue = pctXferred + pctPendingXfer;
                else if((pctXferred + pctPendingXfer) > progressOrange.barValue)
                    progressOrange.barValue = pctXferred + pctPendingXfer;

                //unpacked bar
                progressGreen.barValue = pctRecvd;

                preinstallMarker.preInstallPct = preInstallPct;
                preinstallMarker.visible = true;
            } else {
                preinstallMarker.visible = false;
                progressGreen.barValue = 0;
            }
        }
    }

    Image {
        id: layer_1
        source: "layer_1.png"
        x: 0
        y: 0
        opacity: 1
    }

    TitleBar {
        anchors.fill: parent
    }

    MultiButton {
        id: pauseBtn
        x: 587
        y: 410
        width: 70
        height: 50
        opacity: 1

        onClicked: {
            isPaused = brCmd.brTogglePause();
            refreshImage();
        }
        property bool isPaused: false

        defaultImage: isPaused ? "resume.png" : "pause.png"
        disabledImage: isPaused ? "resumedisable.png" : "pausedisable.png"
        hoverImage: isPaused ? "resumehover.png" : "pausehover.png"
    }

    MultiButton {
        id: playBtn
        x: 348
        y: 410
        width: 238
        height: 50
        opacity: 1
        enabled: false

        defaultImage: "play.png"
        disabledImage: "playdisable.png"
        hoverImage: "playhover.png"

        onClicked: brCmd.brPlay("");
    }

    Image {
        id: righthand
        source: "righthand.png"
        x: 343
        y: 384
        opacity: 1
    }
    Image {
        id: lefthand
        source: "lefthand.png"
        x: 611
        y: 384
        opacity: 1
    }

    Rectangle {
        id: progressOrange
        x: 20
        y: 297
        property int barValue: 30
        width: 665 * (barValue / 100)
        height: 10
        clip: true
        color: "transparent"

        Image {
            width: 665
            height: 10
            source: "progressorange.png"
            opacity: 1
        }
    }

    Rectangle {
        id: progressGreen
        x: 20
        y: 297
        property int barValue: 10
        width: 665 * (barValue / 100)
        height: 10
        color: "transparent"
        clip: true

        Image {
            width: 665
            height: 10
            source: "progressgreen.png"
            opacity: 1
        }
    }

    Rectangle {
        id: preinstallMarker
        x: 20
        y: 294
        width: 665 * preInstallPct
        height: 1
        clip: true
        property real preInstallPct: 0

        Image {
            width: 665
            height: 1
            source: "preinstallmarker.png"
            opacity: 1
        }
    }

    Text {
        id: download
        text: ""
        horizontalAlignment: Text.AlignRight
        font.pixelSize: 11
        font.family: "Verdana-Bold"
        font.bold: true
        color: "#ffffff"
        smooth: true
        anchors.right: mainRect.right
        anchors.rightMargin: 28
        y: 316.25
        opacity: 1
    }

    Text {
        id: speed
        text: "speed @ " + mainRect.speedText
        font.pixelSize: 11
        font.family: "Verdana-Bold"
        font.bold: true
        color: "#ffffff"
        smooth: true
        x: 28
        y: 316.25
        opacity: 1
        visible: mainRect.speedText.trim().length != 0
    }

    Text {
        id: preinstall
        text: ""
        font.pixelSize: 11
        font.family: "Verdana-Bold"
        font.bold: true
        color: "#ffffff"
        smooth: true
        x: 28
        y: 273.25
        opacity: 1
    }

// what to do with this?
    Text {
        id: status
        text: "status: playable"
        horizontalAlignment: Text.AlignRight
        font.pixelSize: 11
        font.family: "Verdana-Bold"
        font.bold: true
        color: "#ffffff"
        smooth: true
        x: 576
        y: 273.25
        opacity: 1
        visible: playBtn.enabled
    }

    StatusBox {
        id: logs
        fontPxSize: 11
        textFont: "Verdana"
        fontColor: "#000000"
        x: 48
        y: 361
        width: 281
        height: 78
        opacity: 1
    }

    Image {
        id: logo
        source: "logo.png"
        x: 81
        y: -10
        opacity: 1
    }

    Button {
        id: closeBtn
        x: 632
        y: 233
        width: 19
        height: 19
        opacity: 1

        defaultImage: "close.png"
        disabledImage: "close.png"

        onClicked: Qt.quit();
    }

    Button {
        id: minimizeBtn
        x: 612
        y: 233
        width: 19
        height: 19
        opacity: 1

        defaultImage: "minimize.png"
        disabledImage: "minimize.png"

        onClicked: cppWindow.minimizeWindow();
    }
}
