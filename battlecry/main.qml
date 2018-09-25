import QtQuick 1.1

Item {
    id: mainRect
    width:800
    height:472

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
        id: background
        source: "background.png"
        x: 0
        y: 0
        opacity: 1
    }
    AnimatedImage {
        id: animation
        source: "animated.gif"
        width:800
        height:472
        x: 0
        y: 0
        opacity: 0.15
    }
    Image {
        id: foreground
        source: "foreground.png"
        x: -1
        y: -1
        opacity: 1
    }
    Text {
        id: a_new_team_action_game_where_brutality_and_beauty_collide
        text: "A New Team Action Game Where Brutality and Beauty Collide"
        font.pixelSize: 17
        font.family: ramagothic.name
        color: "#ffffff"
        smooth: true
        x: 237
        y: 153.75
        opacity: 0.4
    }
    Image {
        id: logobattlecrywhite
        source: "logo_battlecry-white_copy.png"
        x: 0
        y: 0
        opacity: 0.67058823529412
    }
    Text {
        id: copyright
        text: "©2014 ZeniMax Media Inc. All Rights Reserved."
        font.pixelSize: 7
        font.family: verdana.name
        color: "#ffffff"
        smooth: true
        x: 24
        y: 452.25
        opacity: 0.5
    }
    Image {
        id: slashes
        source: "slashes.png"
        x: 72
        y: 436
        opacity: 1
    }

    Text {
        id: legalinfolink
        text: "LEGAL INFO"
        font.pixelSize: 15
        font.family: ramagothic.name
        color: "#ffffff"
        smooth: true
        x: 289
        y: 432.25
        opacity: 0.5

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(parent, 13);

            MouseArea {
                hoverEnabled: true
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("http://www.zenimax.com/legal_information")
                onEntered: parent.parent.opacity = 1
                onExited: parent.parent.opacity = 0.5
            }
        }
    }

    Text {
        id: termsofservicelink
        text: "TERMS OF SERVICE"
        font.pixelSize: 15
        font.family: ramagothic.name
        color: "#ffffff"
        smooth: true
        x: 183
        y: 432.25
        opacity: 0.5

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(parent, 13);

            MouseArea {
                hoverEnabled: true
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("http://www.zenimax.com/legal_terms_us")
                onEntered: parent.parent.opacity = 1
                onExited: parent.parent.opacity = 0.5
            }
        }
    }

    Text {
        id: privacypolicylink
        text: "PRIVACY POLICY    "
        font.pixelSize: 15
        font.family: ramagothic.name
        color: "#ffffff"
        smooth: true
        x: 88
        y: 432.25
        opacity: 0.5

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(parent, 13);

            MouseArea {
                hoverEnabled: true
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("http://www.zenimax.com/legal_privacy_us")
                onEntered: parent.parent.opacity = 1
                onExited: parent.parent.opacity = 0.5
            }
        }
    }

    Text {
        id: contactlink
        text: "CONTACT"
        font.pixelSize: 15
        font.family: ramagothic.name
        color: "#ffffff"
        smooth: true
        x: 24
        y: 432.25
        opacity: 0.5

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(parent, 13);

            MouseArea {
                hoverEnabled: true
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("http://bethsoft.com/en-us/contact")
                onEntered: parent.parent.opacity = 1
                onExited: parent.parent.opacity = 0.5
            }
        }
    }

    Text {
        id: battlecrytaglink
        text: "#BATTLECRY"
        font.pixelSize: 18
        font.family: ramagothic.name
        color: "#ffffff"
        smooth: true
        x: 25
        y: 14.5
        opacity: 0.50196078431373

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(parent, 13);

            MouseArea {
                hoverEnabled: true
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("https://twitter.com/search?q=BATTLECRY")
                onEntered: parent.parent.opacity = 1
                onExited: parent.parent.opacity = 0.50196078431373
            }
        }
    }

    Button {
        id: playBtn
        x: 493
        y: 350
        width: 264
        height: 48
        onClicked: brCmd.brPlay("");
        opacity: enabled ? 1 : 0.2
        enabled: false
        defaultImage: "play.png"
        hoverImage: "playhover.png"
        disabledImage: "playdisabled.png"
    }

    Image {
        id: iconbethblog
        source: "iconbethblog.png"
        x: 699
        y: 16
        opacity: 0.5

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(parent, 13);

            MouseArea {
                hoverEnabled: true
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("http://www.bethblog.com/")
                onEntered: parent.parent.opacity = 1
                onExited: parent.parent.opacity = 0.5
            }
        }
    }

    Image {
        id: iconfacebook
        source: "iconfacebook.png"
        x: 581
        y: 16
        opacity: 0.5

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(parent, 13);

            MouseArea {
                hoverEnabled: true
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("https://www.facebook.com/BATTLECRYTheGame")
                onEntered: parent.parent.opacity = 1
                onExited: parent.parent.opacity = 0.5
            }
        }
    }

    Image {
        id: iconinstagram
        source: "iconinstagram.png"
        x: 667
        y: 16
        opacity: 0.5

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(parent, 13);

            MouseArea {
                hoverEnabled: true
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("http://instagram.com/bethesdasoftworks")
                onEntered: parent.parent.opacity = 1
                onExited: parent.parent.opacity = 0.5
            }
        }
    }

    Image {
        id: icontwitter
        source: "icontwitter.png"
        x: 604
        y: 17
        opacity: 0.5

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(parent, 13);

            MouseArea {
                hoverEnabled: true
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("http://www.twitter.com/battlecry_game")
                onEntered: parent.parent.opacity = 1
                onExited: parent.parent.opacity = 0.5
            }
        }
    }

    Image {
        id: iconyoutube
        source: "iconyoutube.png"
        x: 635
        y: 16
        opacity: 0.5

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(parent, 13);

            MouseArea {
                hoverEnabled: true
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("https://www.youtube.com/user/BethesdaSoftworks")
                onEntered: parent.parent.opacity = 1
                onExited: parent.parent.opacity = 0.5
            }
        }
    }

    StatusBox {
        id: logs
        width: 444
        height: 60
        x: 173
        y: 235
        fontPxSize: 10
        textFont: verdana.name
        fontColor: "#b4b4b4"
    }

    Button {
        id: minimize
        defaultImage: "minimize.png"
        hoverImage: "minimizehover.png"
        x: 752
        y: 18
        width: 14
        height: 14
        onClicked: cppWindow.minimizeWindow();
    }

    Button {
        id: close
        defaultImage: "close.png"
        hoverImage: "closehover.png"
        x: 767
        y: 18
        width: 14
        height: 14
        onClicked: Qt.quit();
    }

    Image {
        id: progresscontainer
        source: "progresscontainer.png"
        x: 38
        y: 360
        opacity: 1
    }

    ProgressBar {
        id: progressbar1
        barImage: "preinstall.png"
        x: 40
        y: 363
        width: 377
        height: 20
        opacity: 1
        barValue: 50
    }

    ProgressBar {
        id: progressbar2
        barImage: "stream.png"
        x: 40
        y: 363
        width: 377
        height: 20
        opacity: 1
        barValue: 20
    }

    Image {
        id: patternoverlay
        source: "patternoverlay.png"
        x: 40
        y: 363
        opacity: 1
    }

    Image {
        id: preinstallmarker
        source: "preinstallmarker.png"
        property real preinstallPct: 0.15
        x: progressbar1.width * preinstallPct + progressbar1.x - 4
        y: 360
        opacity: 1
    }

    Text {
        id: preinstalllabel
        text: "Pre-Install @"
        font.pixelSize: 10
        font.family: opensanslight.name
        color: "#ffffff"
        smooth: true
        x: 40
        y: 341.5
        opacity: 0.5
    }

    MultiButton {
        id: pauseBtn
        x: 424
        y: 358
        width: 30
        height: 30
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
        id: preinstall
        text: "10 %"
        font.pixelSize: 13
        font.family: opensanslight.name
        color: "#ffffff"
        smooth: true
        x: 108
        y: 341.75
        opacity: 1
    }

    Text {
        id: speedlabel
        text: "Speed @"
        font.pixelSize: 10
        font.family: opensanslight.name
        color: "#ffffff"
        smooth: true
        x: 40
        y: 387.5
        opacity: 0.5
        visible: mainRect.speedText.trim().length > 0
    }

    Text {
        id: speed
        text: mainRect.speedText
        font.pixelSize: 13
        font.family: opensanslight.name
        color: "#ffffff"
        smooth: true
        x: 108
        y: 387.75
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
        x: 284
        y: 342.5
        opacity: 0.5
    }
    Text {
        id: total
        text: "13,419.87 MB"
        font.pixelSize: 13
        font.family: opensanslight.name
        color: "#ffffff"
        smooth: true
        x: 339
        y: 341.75
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
        x: 297
        y: 387.5
        opacity: 0.5
        visible: totallabel.visible
    }
    Text {
        id: download
        text: "2,300 MB"
        font.pixelSize: 13
        font.family: opensanslight.name
        color: "#ffffff"
        smooth: true
        x: 364
        y: 387.75
        opacity: 1
        visible: downloadlabel.visible
    }
    FontLoader {
        id: opensanslight
        source: "OpenSans-Light.ttf"
    }
    FontLoader {
        id: verdana
        source: "verdana.ttf"
    }
    FontLoader {
        id: ramagothic
        source: "ramagothice_regular-webfont.ttf"
    }
}
