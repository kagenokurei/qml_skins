import QtQuick 1.1

Item {
    id: mainRect
    width:820
    height:520

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
//        var cStage = brQuery.getStage();
//        if(cStage == 101 || cStage == 102) //we use custom code for these stages
//            return;

        streamprogress.value = progress;
        preinstalllabel.text = mainRect.stageDesc
//        preinstall.text = mainRect.stageProgress
    }

    function setMainProgressText(textToSet) {
        stageProgress = textToSet;
    }

    function setSubProgress(progress) {
        preinstallprogress.value = progress;
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
                preinstall.text = mainRect.stageProgress;

//                //xferred bar
//                var pctXferred = brQuery.getGenericUalt2(5/*XFER*/) / 100;
//                var pctPendingXfer = brQuery.getSpecUval2(5/*XFER*/) / totalBytes * 100;
//                if(streamprogress.value == 0)
//                    preinstallprogress.value = pctXferred + pctPendingXfer;
//                else if((pctXferred + pctPendingXfer) > preinstallprogress.value)
//                    preinstallprogress.value = pctXferred + pctPendingXfer;

//                //unpacked bar
//                streamprogress.value = pctRecvd;

//                preinstallMarker.preInstallPct = preInstallPct;
//                preinstallMarker.visible = true;
                downloadlabel.visible = true;
            } else {
//                preinstallMarker.visible = false;
//                preinstallprogress.value = 0;
                downloadlabel.visible = false;
            }
        }
    }

    Image {
        id: background
        source: "background.png"
        x: 1
        y: 1
        opacity: 1
    }

    TitleBar {
        id: titleBar1
        x: 9
        y: 9
        width: 802
        height: 502
    }

    CircularProgress {
        id: streamprogress
        value: 70
        width: 175
        height: 175
        progressBackground: "progressbar.png"
        displayLabel : false
        x: 201
        y: 142
    }


    CircularProgress {
        id: preinstallprogress
        value: 70
        width: 130
        height: 130
        progressBackground: "preinstallbar.png"
        displayLabel : false
        x: 223
        y: 165
    }


    Image {
        id: hood
        source: "hood.png"
        x: 220
        y: 129
        opacity: 0.10980392156863
    }

    Text {
        id: preinstalllabel
        text: ""
        font.pixelSize: 10
        font.family: helveticaneuelight.name
        color: "#8a6b00"
        smooth: true
        x: 64
        y: 126.5
        opacity: 1
    }

    Text {
        id: preinstall
        text: ""
        font.pixelSize: 13
        font.family: helveticaneuelight.name
        color: "#ffffff"
        smooth: true
        x: 132
        y: 126.75
        opacity: 1
    }

    Text {
        id: speedlabel
        text: "speed"
        font.pixelSize: 10
        font.family: helveticaneuelight.name
        color: "#8a6b00"
        smooth: true
        x: 64
        y: 141.5
        opacity: 1
        visible: mainRect.speedText.trim().length != 0
    }

    Text {
        id: speed
        text: mainRect.speedText
        font.pixelSize: 13
        font.family: helveticaneuelight.name
        color: "#ffffff"
        smooth: true
        x: 132
        y: 141.75
        opacity: 1
        visible: speedlabel.visible
    }

    Text {
        id: downloadlabel
        text: "completed"
        font.pixelSize: 10
        font.family: helveticaneuelight.name
        color: "#8a6b00"
        smooth: true
        x: 376
        y: 306.5
        opacity: 1
    }

    Text {
        id: download
        text: ""
        font.pixelSize: 13
        font.family: helveticaneuelight.name
        color: "#ffffff"
        smooth: true
        x: 444
        y: 305.75
        opacity: 1
        visible: downloadlabel.visible
    }

    Text {
        id: totallabel
        text: "total size"
        font.pixelSize: 10
        font.family: helveticaneuelight.name
        color: "#8b6a00"
        smooth: true
        x: 377
        y: 321.5
        opacity: 1
        visible: downloadlabel.visible
    }

    Text {
        id: total
        text: ""
        font.pixelSize: 13
        font.family: helveticaneuelight.name
        color: "#ffffff"
        smooth: true
        x: 444
        y: 320.75
        opacity: 1
        visible: totallabel.visible
    }


    MultiButton {
        id: pauseBtn
        x: 266
        y: 208
        width: 44
        height: 45
        onClicked: {
            isPaused = brCmd.brTogglePause();
            refreshImage();
        }
        property bool isPaused: false

        defaultImage: isPaused ? "resume.png" : "pause.png"
        disabledImage: isPaused ? "resume.png" : "pause.png"
        hoverImage: isPaused ? "resumehover.png" : "pausehover.png"
    }


    Button {
        id: closebutton
        defaultImage: "close.png"
        disabledImage: "close.png"
        hoverImage: "closehover.png"
        x: 795
        y: 16
        width: 8
        height: 8
        onClicked: Qt.quit()
    }


    Button {
        id: minimizebutton
        defaultImage: "minimize.png"
        disabledImage: "minimize.png"
        hoverImage: "minimizehover.png"
        x: 780
        y: 16
        width: 8
        height: 8
        onClicked: cppWindow.minimizeWindow();
    }


    StatusBox {
        id: logs
        width: 426
        height: 66
        anchors.top: parent.top
        anchors.topMargin: 380
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 74
        x: 76
        y: 381
        fontPxSize: 11
        textFont: helveticaneuelight.name
        fontHorizontalAlignment: Text.AlignHCenter
        fontColor: "#ffffff"
        clip: true
    }


    Button {
        id: playBtn
        defaultImage: "play.png"
        hoverImage: "playhover.png"
        width: 225
        height: 78
        x: 585
        y: 374
        opacity: enabled ? 1 : 0.3
        onClicked: brCmd.brPlay("");
        enabled: false
    }


    FontLoader {
        id: helveticaneuelight
        source: "HelveticaNeueLight.ttf"
    }


    FontLoader {
        id: helveticaneuemedium
        source: "HelveticaNeue-Medium.ttf"
    }

}
