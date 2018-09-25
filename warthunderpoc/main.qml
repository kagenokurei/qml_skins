import QtQuick 1.1

Item {
    id: mainRect
    width:704
    height:438

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

    Image {
        id: background
        source: "background.png"
        x: 1
        y: 1
        opacity: 1
    }

    AnimatedImage {
        id: animation
        source: "animated.gif"
        x: 10
        y: 10
        opacity: 1
    }

    TitleBar {
        anchors.fill: parent
    }

    Image {
        id: footer
        source: "background__1.png"
        x: 10
        y: 10
        opacity: 1
    }
    Text {
        id: copyright
        text: "© 2009—2014 by Gaijin Entertainment."
        font.pixelSize: 12
        font.family: opensanslight.name
        color: "#ffffff"
        smooth: true
        x: 462
        y: 62
        opacity: 0.4
    }
    Image {
        id: header
        source: "header.png"
        x: 10
        y: 10
        opacity: 1
    }

    ProgressBar {
        id: progressbar1
        barImage: "preinstallbar.png"
        x: 124
        y: 325
        width: 406
        height: 18
        opacity: 1
        barValue: 50
    }

    ProgressBar {
        id: progressbar2
        barImage: "streambar.png"
        x: 124
        y: 325
        width: 406
        height: 18
        opacity: 1
        barValue: 20
    }

    Image {
        id: progressholder
        source: "progressholder.png"
        x: 116
        y: 317
        opacity: 1
    }

    Image {
        id: preinstallmarker
        source: "preinstallmarker.png"
        property real preinstallPct: 0.15
        x: progressbar1.width * preinstallPct + progressbar1.x - 17
        y: 307
        opacity: 1
    }
    Image {
        id: logscontainer
        source: "logscontainer.png"
        x: 135
        y: 208
        opacity: 1
    }

    Button {
        id: playBtn
        x: 541
        y: 194
        width: 158
        height: 158
        onClicked: brCmd.brPlay("");
        enabled: false
        defaultImage: "play.png"
        downImage: "playpush.png"
        hoverImage: "playhover.png"
        disabledImage: "playdisabled.png"
    }

    MultiButton {
        id: pauseBtn
        x: 540
        y: 325
        width: 18
        height: 18
        opacity: enabled ? 1 : 0.3

        onClicked: {
            isPaused = brCmd.brTogglePause();
            refreshImage();
        }
        property bool isPaused: false

        defaultImage: isPaused ? "playbtn.png" : "pausebtn.png"
        hoverImage: isPaused ? "playbtnhover.png" : "pausebtnhover.png"
    }

    Text {
        id: preinstalllabel
        text: "Pre-Install @"
        font.pixelSize: 10
        font.family: opensanslight.name
        color: "#ffffff"
        smooth: true
        x: 125
        y: 346
        opacity: 0.6
    }
    Text {
        id: preinstall
        text: "10 %"
        font.pixelSize: 13
        font.family: opensanslight.name
        color: "#ffffff"
        smooth: true
        x: 193
        y: 346
        opacity: 1
    }
    Text {
        id: speedlabel
        text: "Speed @"
        font.pixelSize: 10
        font.family: opensanslight.name
        color: "#ffffff"
        smooth: true
        x: 125
        y: 364
        opacity: 0.6
        visible: mainRect.speedText.trim().length > 0
    }
    Text {
        id: speed
        text: mainRect.speedText
        font.pixelSize: 13
        font.family: opensanslight.name
        color: "#ffffff"
        smooth: true
        x: 193
        y: 364
        opacity: 1
        visible: speedlabel.visible
    }
    Text {
        id: totallabel
        text: "Total Size"
        font.pixelSize: 10
        font.family: opensanslight.name
        color: "#ffffff"
        smooth: true
        x: 396
        y: 347
        opacity: 0.6
    }
    Text {
        id: total
        text: "13,419.87 MB"
        font.pixelSize: 13
        font.family: opensanslight.name
        color: "#ffffff"
        smooth: true
        x: 451
        y: 346
        opacity: 1
        visible: totallabel.visible
    }
    Text {
        id: downloadlabel
        text: "Download @"
        font.pixelSize: 10
        font.family: opensanslight.name
        color: "#ffffff"
        smooth: true
        x: 409
        y: 364
        opacity: 0.6
        visible: totallabel.visible
    }
    Text {
        id: download
        text: "2,300 MB"
        font.pixelSize: 13
        font.family: opensanslight.name
        color: "#ffffff"
        smooth: true
        x: 476
        y: 364
        opacity: 1
        visible: downloadlabel.visible
    }

    StatusBox {
        id: logs
        x: 163
        y: 226
        width: 373
        height: 75
        textFont: opensanslight.name
        fontPxSize: 11
        fontColor: "#b5b5b5"
    }

    Button {
        id: minimize
        defaultImage: "minimize.png"
        hoverImage: "minimizehover.png"
        x: 649
        y: 23
        width: 14
        height: 14
        onClicked: cppWindow.minimizeWindow();
    }

    Button {
        id: close
        defaultImage: "close.png"
        hoverImage: "closehover.png"
        x: 664
        y: 23
        width: 14
        height: 14
        onClicked: Qt.quit();
    }

    FontLoader {
        id: opensanslight
        source: "OpenSans-Light.ttf"
    }

    Text {
        id: medialink
        text: "MEDIA"
        font.pixelSize: 12
        font.family: opensanslight.name
        color: "#ffffff"
        smooth: true
        x: 138
        y: 400
        opacity: 1

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(medialink, 13);

            MouseArea {
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("http://warthunder.com/en/media/")
            }
        }
    }

    Text {
        id: gamelink
        text: "GAME"
        font.pixelSize: 12
        font.family: opensanslight.name
        color: "#ffffff"
        smooth: true
        x: 87
        y: 400
        opacity: 1

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(gamelink, 13);

            MouseArea {
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("http://warthunder.com/en/game/")
            }
        }
    }

    Text {
        id: homelink
        text: "HOME"
        font.pixelSize: 12
        font.family: opensanslight.name
        color: "#ffffff"
        smooth: true
        x: 36
        y: 400
        opacity: 1

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(homelink, 13);

            MouseArea {
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("http://warthunder.com/")
            }
        }
    }

    Text {
        id: storeink
        text: "STORE"
        font.pixelSize: 12
        font.family: opensanslight.name
        color: "#ffffff"
        smooth: true
        x: 397
        y: 400
        opacity: 1

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(storeink, 13);

            MouseArea {
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("http://warthunder.com/en/store/")
            }
        }
    }

    Text {
        id: devlogink
        text: "DEVBLOG"
        font.pixelSize: 12
        font.family: opensanslight.name
        color: "#ffffff"
        smooth: true
        x: 329
        y: 400
        opacity: 1

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(devlogink, 13);

            MouseArea {
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("http://devblog.warthunder.com/")
            }
        }
    }

    Text {
        id: forumink
        text: "FORUM"
        font.pixelSize: 12
        font.family: opensanslight.name
        color: "#ffffff"
        smooth: true
        x: 274
        y: 400
        opacity: 1

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(forumink, 13);

            MouseArea {
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("http://forum.warthunder.com/")
            }
        }
    }

    Text {
        id: communitylink
        text: "COMMUNITY"
        font.pixelSize: 12
        font.family: opensanslight.name
        color: "#ffffff"
        smooth: true
        x: 190
        y: 400
        opacity: 1

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(communitylink, 13);

            MouseArea {
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("http://warthunder.com/en/community/")
            }
        }
    }
}
