import QtQuick 1.1

Item {
    id: mainRect

    width:766
    height:492

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

                preinstallsplit.preinstallPct = preInstallPct;
                preinstallsplit.visible = true;
                totallabel.visible = true;
            } else {
                totallabel.visible = false;
                preinstallsplit.visible = false;
                progressbar2.barValue = 0;
            }
        }
    }

    Image {
        id: background
        source: "background.png"
        x: 0
        y: 3
        opacity: 1
    }

    TitleBar {
        anchors.fill: parent
    }

    Image {
        id: footer
        source: "footer.png"
        x: 7
        y: 387
        opacity: 1
    }
    Image {
        id: logsblock
        source: "logsblock.png"
        x: 63
        y: 225
        opacity: 1
    }
    Image {
        id: mincloseholder
        source: "mincloseholder.png"
        x: 656
        y: 0
        opacity: 1
    }
    Image {
        id: animals
        source: "animals.png"
        x: 7
        y: 18
        opacity: 1
    }
    Image {
        id: playbackground
        source: "playbackground.png"
        x: 550
        y: 216
        opacity: 1
    }
    Image {
        id: logos
        source: "logos.png"
        x: 557
        y: 427
        opacity: 1
    }
    Image {
        id: progressbox
        source: "progressbox.png"
        x: 118
        y: 372
        opacity: 0.6
    }
    Image {
        id: logo
        source: "logo.png"
        x: 123
        y: 12
        opacity: 1
    }

    MultiButton {
        id: pauseBtn
        x: 474
        y: 381
        width: 38
        height: 36

        onClicked: {
            isPaused = brCmd.brTogglePause();
            refreshImage();
        }
        property bool isPaused: false

        defaultImage: isPaused ? "play.png" : "pause.png"
        disabledImage: isPaused ? "playdisabled.png" : "pausedisabled.png"
        hoverImage: isPaused ? "playhover.png" : "pausehover.png"
    }

    Text {
        id: preinstalllabel
        text: "Pre-Install @"
        font.pixelSize: 10
        font.family:  opensans.name
        color: "#ffffff"
        smooth: true
        x: 164
        y: 430.5
        opacity: 0.30196078431373
    }
    Text {
        id: preinstall
        text: "10 %"
        font.pixelSize: 13
        font.family:  opensans.name
        color: "#ffffff"
        smooth: true
        x: 232
        y: 430.75
        opacity: 1
    }

    Text {
        id: speedlabel
        text: "Speed @"
        font.pixelSize: 10
        font.family:  opensans.name
        color: "#ffffff"
        smooth: true
        x: 164
        y: 445.5
        opacity: 0.30196078431373
        visible: mainRect.speedText.trim().length > 0
    }

    Text {
        id: speed
        text: mainRect.speedText
        font.pixelSize: 13
        font.family:  opensans.name
        color: "#ffffff"
        smooth: true
        x: 232
        y: 445.75
        visible: speedlabel.visible
    }

    Text {
        id: totallabel
        text: "Total Size"
        font.pixelSize: 10
        font.family:  opensans.name
        color: "#ffffff"
        smooth: true
        x: 325
        y: 431.5
        opacity: 0.30196078431373
    }
    Text {
        id: total
        text: "13,419.87 MB"
        font.pixelSize: 13
        font.family:  opensans.name
        color: "#ffffff"
        smooth: true
        x: 393
        y: 430.75
        opacity: 1
        visible: totallabel.visible
    }
    Text {
        id: downloadlabel
        text: "Download @"
        font.pixelSize: 10
        font.family:  opensans.name
        color: "#ffffff"
        smooth: true
        x: 326
        y: 445.5
        opacity: 0.30196078431373
        visible: totallabel.visible
    }
    Text {
        id: download
        text: "2,300 MB"
        font.pixelSize: 13
        font.family:  opensans.name
        color: "#ffffff"
        smooth: true
        x: 393
        y: 445.75
        opacity: 1
        visible: downloadlabel.visible
    }

    Image {
        id: progressholder
        source: "progressholder.png"
        x: 135
        y: 382
        opacity: 1
    }

    ProgressBar {
        id: progressbar1
        x: 149
        y: 396
        width: 305
        height: 9
        barImage: "preinstallbar.png"
        barValue: 50
    }

    ProgressBar {
        id: progressbar2
        x: 149
        y: 396
        width: 305
        height: 9
        barImage: "streambar.png"
        barValue: 20
    }

    Image {
        id: preinstallsplit
        property real preinstallPct: 0.15
        source: "preinstallsplit.png"
        x: progressbar1.width * preinstallPct + progressbar1.x - 7
        y: 412
        width: 14
        height: 15
    }

    MultiButton {
        id: playBtn
        x: 563
        y: 229
        width: 188
        height: 188
        opacity: enabled ? 1 : 0.3
        enabled: false

        defaultImage: "playnow.png"
        disabledImage: "playnowdisabled.png"
        hoverImage: "playnowhover.png"

        onClicked: brCmd.brPlay("");
    }

    Button {
        id: minimize
        x: 692
        y: 17
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
        x: 720
        y: 17
        width: 24
        height: 24
        onClicked: Qt.quit();
    }

    Text {
        id: gameguidelink
        text: "Game Guide"
        font.pixelSize: 12
        font.family:  opensansbold.name
        font.bold: true
        color: "#fdcf00"
        smooth: true
        x: 213
        y: 230
        opacity: 1

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(gameguidelink, 13);

            MouseArea {
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("http://www.villagersandheroes.com/game-guide/")
            }
        }
    }

    Text {
        id: homelink
        text: "Home"
        font.pixelSize: 12
        font.family:  opensansbold.name
        font.bold: true
        color: "#fdcf00"
        smooth: true
        x: 144
        y: 230
        opacity: 1

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(homelink, 13);

            MouseArea {
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("http://www.villagersandheroes.com/")
            }
        }
    }

    Text {
        id: communitylink
        text: "Community"
        font.pixelSize: 12
        font.family:  opensansbold.name
        font.bold: true
        color: "#fdcf00"
        smooth: true
        x: 317
        y: 230
        opacity: 1

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(communitylink, 13);

            MouseArea {
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("http://www.villagersandheroes.com/community/")
            }
        }
    }

    Text {
        id: forumslink
        text: "Forums"
        font.pixelSize: 12
        font.family:  opensansbold.name
        font.bold: true
        color: "#fdcf00"
        smooth: true
        x: 424
        y: 230
        opacity: 1

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(forumslink, 13);

            MouseArea {
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("https://forum.villagersandheroes.com/")
            }
        }
    }

    Text {
        id: medialink
        text: "Media"
        font.pixelSize: 12
        font.family:  opensansbold.name
        font.bold: true
        color: "#fdcf00"
        smooth: true
        x: 507
        y: 230
        opacity: 1

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(medialink, 13);

            MouseArea {
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("http://www.villagersandheroes.com/media/")
            }
        }
    }

    StatusBox {
        id: logs
        x: 141
        y: 259.25
        width: 373
        height: 75
        fontPxSize: 11
        textFont: opensanslight.name
        fontColor: "#3b352d"
    }

    FontLoader {
        id: opensanslight
        source: "OpenSans-Light.ttf"
    }

    FontLoader {
        id: opensans
        source: "OpenSans-Regular.ttf"
    }

    FontLoader {
        id: opensansbold
        source: "OpenSans-Bold.ttf"
    }
}
