import QtQuick 1.1

Item {
    id: mainRect
    width:860
    height:476

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
    Image {
        id: logo
        source: "logo.png"
        x: 247
        y: 23
        opacity: 1
    }

    StatusBox {
        id: logs
        width: 426
        height: 67
        anchors.top: parent.top
        anchors.topMargin: 309
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 92
        x: 219
        y: 315
        fontPxSize: 10
        textFont: helveticaneuelight.name
        fontHorizontalAlignment: Text.AlignHCenter
        fontColor: "#d58001"
        clip: true
    }

    CircularProgress {
        id: streamprogress
        value: 70
        width: 164
        height: 164
        progressBackground: "progressbar.png"
        displayLabel : false
        x: 347
        y: 125
    }
    CircularProgress {
        id: preinstallprogress
        value: 70
        width: 116
        height: 116
        progressBackground: "preinstallbar.png"
        displayLabel : false
        x: 372
        y: 149
    }
    MultiButton {
        id: pauseBtn
        x: 407
        y: 184
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
    Text {
        id: preinstall
        text: ""
        font.pixelSize: 16
        font.family: helveticaneuemedium.name
        color: "#f89602"
        smooth: true
        x: 293
        y: 154
        opacity: 1
    }
    Text {
        id: preinstalllabel
        text: ""
        font.pixelSize: 10
        font.family: helveticaneuemedium.name
        color: "#caac11"
        smooth: true
        x: 300
        y: 144
        opacity: 1
    }
    Text {
        id: speed
        text: mainRect.speedText
        font.pixelSize: 16
        font.family: helveticaneuemedium.name
        color: "#f78f03"
        smooth: true
        x: 261
        y: 206
        opacity: 1
        visible: speedlabel.visible
    }
    Text {
        id: speedlabel
        text: "speed"
        font.pixelSize: 10
        font.family: helveticaneuemedium.name
        color: "#c5a814"
        smooth: true
        x: 311
        y: 196
        opacity: 1
        visible: mainRect.speedText.trim().length != 0
    }
    Text {
        id: download
        text: ""
        font.pixelSize: 16
        font.family: helveticaneuemedium.name
        color: "#f78f03"
        smooth: true
        x: 260
        y: 270
        opacity: 1
        visible: downloadlabel.visible
    }
    Text {
        id: downloadlabel
        text: "completed"
        font.pixelSize: 10
        font.family: helveticaneuemedium.name
        color: "#caab11"
        smooth: true
        x: 310
        y: 259
        opacity: 1
    }
    Text {
        id: total
        text: ""
        font.pixelSize: 16
        font.family: helveticaneuemedium.name
        color: "#f89602"
        smooth: true
        x: 504
        y: 270
        opacity: 1
        visible: totallabel.visible
    }
    Text {
        id: totallabel
        text: "total size"
        font.pixelSize: 10
        font.family: helveticaneuemedium.name
        color: "#caab11"
        smooth: true
        x: 505
        y: 259
        opacity: 1
        visible: downloadlabel.visible
    }

    Button {
        id: playBtn
        defaultImage: "play.png"
        hoverImage: "playhover.png"
        width: 188
        height: 49
        x: 512
        y: 158
        opacity: enabled ? 1 : 0.3
        onClicked: brCmd.brPlay("");
        enabled: false
    }

    Button {
        id: closebutton
        defaultImage: "close.png"
        disabledImage: "close.png"
        hoverImage: "closehover.png"
        x: 837
        y: 13
        width: 8
        height: 8
        onClicked: Qt.quit()
    }

    Button {
        id: minimizebutton
        defaultImage: "minimize.png"
        disabledImage: "minimize.png"
        hoverImage: "minimizehover.png"
        x: 825
        y: 13
        width: 8
        height: 8
        onClicked: cppWindow.minimizeWindow();
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
