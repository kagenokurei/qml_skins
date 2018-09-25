import QtQuick 1.1
Item {
    id: mainRect
    width:860
    height:510

    property string stageDesc: "Downloading"
    property string stageProgress: "100%"
    property string speedText: "500Mbps"

    /*
    REQUIRED FUNCTIONS
    */
    function setStageText(textToSet) {
        stageDesc = textToSet;
        stageDesc = stageDesc.replace(":", " @");
    }

    function setSubStageText(textToSet) {

    }

    function setMainProgress(progress) {
        setMainProgressText(Math.round(progress) + "%");
        var cStage = brQuery.getStage();
        if(cStage == 101 || cStage == 102) //we use custom code for these stages
            return;

        progressbar1.barValue = progress;
        preinstalllabel.text = mainRect.stageDesc
        preinstall.text = mainRect.stageProgress
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

                download.text = receivedMBytes.toFixed(2) + " MB";
                total.text = totalMBytes.toFixed(2) + " MB";
                preinstalllabel.text = mainRect.stageDesc;
                preinstall.text = mainRect.stageProgress;

                //xferred bar
                var pctXferred = brQuery.getGenericUalt2(5/*XFER*/) / 100;
                var pctPendingXfer = brQuery.getSpecUval2(5/*XFER*/) / totalBytes * 100;
                if(progressbar2.barValue == 0)
                    progressbar1.barValue = pctXferred + pctPendingXfer;
                else if((pctXferred + pctPendingXfer) > progressbar1.barValue)
                    progressbar1.barValue = pctXferred + pctPendingXfer;

                //unpacked bar
                progressbar2.barValue = pctRecvd;

                preinstallmarker.preinstallPct = preInstallPct;
                preinstallmarker.visible = true;
                totallabel.visible = true;
            } else {
                totallabel.visible = false;
                preinstallmarker.visible = false;
                progressbar2.barValue = 0;
            }
        }
    }

    TitleBar {
        anchors.fill: parent
    }

    Image {
        id: bg
        source: "background.png"
        x: 0
        y: 0
        opacity: 1
    }

    StatusBox {
        id: logs
        fontColor: "#b5b5b5"
        fontPxSize: 11
        textFont: opensans_light.name
        smooth: true
        x: 28
        y: 371
        width: 381
        height: 70
    }



    ProgressBar {
        id: progressbar1
        x: 210
        y: 308
        width: 406
        height: 18
        barImage: "streambar.png"
        barValue: 50
    }

    ProgressBar {
        id: progressbar2
        x: 210
        y: 308
        width: 406
        height: 18
        barImage: "preinstallbar.png"
        barValue: 20
    }

    Image {
        id: progressbarcontainer
        source: "progressholder.png"
        x: 202
        y: 300
        opacity: 1
    }


    Image {
        id: preinstallmarker
        source: "preinstallsplit.png"
        property real preinstallPct: 0.3
        x: ((progressbar1.width) * preinstallPct) + progressbar1.x - 4
        y: 323
        opacity: 1
    }

    MultiButton {
        id: pauseBtn
        x: 622
        y: 304
        width: 30
        height: 30
        opacity: enabled ? 1 : 0.3

        onClicked: {
            isPaused = brCmd.brTogglePause();
            refreshImage();
        }
        property bool isPaused: false

        defaultImage: isPaused ? "play.png" : "pause.png"
        hoverImage: isPaused ? "playhover.png" : "pausehover.png"
        disabledImage: isPaused ? "playdisabled.png" : "pausedisabled.png"
    }

    Text {
        id: preinstalllabel
        text: "Pre-Install @"
        font.pixelSize: 10
        font.family: opensans_light.name
        color: "#ffffff"
        smooth: true
        x: 211
        y: 288.5
        opacity: 0.30196078431373
    }
    Text {
        id: preinstall
        text: "10 %"
        font.pixelSize: 13
        font.family: opensans_light.name
        color: "#ffffff"
        smooth: true
        x: 279
        y: 288.75
        opacity: 1
    }
    Text {
        id: speedlabel
        text: "Speed @"
        font.pixelSize: 10
        font.family: opensans_light.name
        color: "#ffffff"
        smooth: true
        x: 211
        y: 330.5
        opacity: 0.30196078431373
        visible: mainRect.speedText.trim().length > 0
    }
    Text {
        id: speed
        text: mainRect.speedText
        font.pixelSize: 13
        font.family: opensans_light.name
        color: "#ffffff"
        smooth: true
        x: 279
        y: 330.75
        opacity: 1
        visible: speedlabel.visible
    }
    Text {
        id: totallabel
        text: "Total Size"
        font.pixelSize: 10
        font.family: opensans_light.name
        color: "#ffffff"
        smooth: true
        x: 468
        y: 289.5
        opacity: 0.30196078431373
    }
    Text {
        id: total
        text: "13,419.87 MB"
        font.pixelSize: 13
        font.family: opensans_light.name
        color: "#ffffff"
        smooth: true
        x: 537
        y: 288.75
        opacity: 1
        visible: totallabel.visible
    }
    Text {
        id: downloadlabel
        text: "Download @"
        font.pixelSize: 10
        font.family: opensans_light.name
        color: "#ffffff"
        smooth: true
        x: 495
        y: 330.5
        opacity: 0.30196078431373
        visible: totallabel.visible
    }
    Text {
        id: download
        text: "2,300 MB"
        font.pixelSize: 13
        font.family: opensans_light.name
        color: "#ffffff"
        smooth: true
        x: 562
        y: 330.75
        opacity: 1
        visible: downloadlabel.visible
    }

    Button {
        id: playBtn
        x: 524
        y: 379
        width: 237
        height: 55
        onClicked: brCmd.brPlay("");
        enabled: false

        defaultImage: "playnow.png"
        disabledImage: "playnowdisabled.png"
        hoverImage: "playnowhover.png"
    }

    Button {
        id: minimize
        x: 792
        y: 14
        width: 24
        height: 24
        defaultImage: "minimize.png"
        hoverImage: "minimizehover.png"
        onClicked: cppWindow.minimizeWindow();
    }

    Button {
        id: close
        defaultImage: "close.png"
        hoverImage: "closehover.png"
        x: 819
        y: 14
        width: 24
        height: 24
        onClicked: Qt.quit();
    }

    FontLoader {
        id: opensans_light
        source: "OpenSans-Light.ttf"
    }

}
