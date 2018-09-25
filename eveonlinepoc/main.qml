import QtQuick 1.1

Item {
    id: mainRect
    width:1020
    height:545

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

    TitleBar {
        anchors.fill: parent
    }

    AnimatedImage {
        id: animation
        source: "animation.gif"
        x: 10
        y: 10
    }

    Image {
        id: lines
        source: "lines.png"
        x: 10
        y: 11
        opacity: 0.3
    }

    ListModel {
        id: characterModel
        ListElement {
            source: "bountyhunter.png"
        }
        ListElement {
            source: "empirebuilder.png"
        }
        ListElement {
            source: "explorer.png"
        }
        ListElement {
            source: "fleetcommander.png"
        }
        ListElement {
            source: "freedomfighter.png"
        }
        ListElement {
            source: "industrialist.png"
        }
        ListElement {
            source: "loyalist.png"
        }
        ListElement {
            source: "manufacturer.png"
        }
        ListElement {
            source: "miner.png"
        }
        ListElement {
            source: "pirate.png"
        }
        ListElement {
            source: "salvager.png"
        }
        ListElement {
            source: "trader.png"
        }

    }

    Rectangle {
        id: characterflip
        x: 116
        y: 22
        width: 236
        height: 507
        color: "transparent"
        property int modelIndex: Math.floor(Math.random() * 11);

        Image {
            id: characterImage
            source: characterModel.get(characterflip.modelIndex).source
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            smooth: true
        }

        SequentialAnimation {
            id: characterTransition
            PropertyAnimation {
                target: characterImage
                property: "opacity"
                duration: 1000
                to: 0
            }
            ScriptAction {
                script: {
                    //sequential
                    if(characterflip.modelIndex < (characterModel.count - 1))
                        characterflip.modelIndex++;
                    else
                        characterflip.modelIndex = 0;
                }
            }
            PropertyAnimation {
                target: characterImage
                property: "opacity"
                duration: 1000
                to: 1
            }
            ScriptAction {
                script: transitionTimer.start();
            }
        }

        Timer {
            id: transitionTimer
            interval: 10000
            repeat: false
            running: true
            onTriggered: characterTransition.start();
        }
    }

    Image {
        id: logo
        source: "logo.png"
        x: 52
        y: 220
        opacity: 1
    }

    Text {
        id: copyright
        text: "Copyright © CCP 1997-2014"
        font.pixelSize: 14
        font.family: engschriftdind.name
        color: "#ffffff"
        smooth: true
        x: 698
        y: 483.5
        opacity: 0.10980392156863
    }

    Image {
        id: footerlogo
        source: "footerlogo.png"
        x: 842
        y: 479
        opacity: 1
    }

    Image {
        id: progresscontainerback
        source: "progresscontainerback.png"
        x: 447
        y: 295
        opacity: 1
    }

    Image {
        id: logscontainer
        source: "logscontainer.png"
        x: 440
        y: 185
        opacity: 1
    }

    StatusBox {
        id: logs
        width: 373
        height: 75
        x: 459
        y: 207.25
        textFont: opensanslight.name
        fontColor: "#b5b5b5"
        fontPxSize: 11
    }

    Image {
        id: progresscontainerfront
        source: "progresscontainerfront.png"
        x: 446
        y: 179
        opacity: 1
    }

    Button {
        id: playBtn
        x: 782
        y: 243
        width: 151
        height: 151
        onClicked: brCmd.brPlay("");
        opacity: enabled ? 1 : 0.21176470588235
        enabled: false

        defaultImage: "playnow.png"
        disabledImage: "playnowdisabled.png"
    }

    ProgressBar {
        id: progressbar1
        x: 462
        y: 356
        width: 278
        height: 11
        barImage: "streambar.png"
        barValue: 50
    }

    ProgressBar {
        id: progressbar2
        x: 462
        y: 356
        width: 278
        height: 11
        barImage: "preinstallbar.png"
        barValue: 20
    }

    Image {
        id: station
        source: "station.png"
        x: 767
        y: 71
        opacity: 1
    }

    Image {
        id: preinstallmarker
        source: "preinstallmarker.png"
        property real preinstallPct: 0.15
        x: progressbar1.width * preinstallPct + progressbar1.x - 6
        y: 346
        opacity: 0.81960784313725
    }

    MultiButton {
        id: pauseBtn
        x: 746
        y: 349
        width: 20
        height: 21
        opacity: enabled ? 1 : 0.3

        onClicked: {
            isPaused = brCmd.brTogglePause();
            refreshImage();
        }
        property bool isPaused: false

        defaultImage: isPaused ? "play.png" : "pause.png"
    }

    Image {
        id: barstrip
        source: "barstrip.png"
        x: 463
        y: 356
        opacity: 1
    }

    Text {
        id: oneuniverselink
        text: "One Universe"
        font.pixelSize: 14
        font.family: engschriftdind.name
        color: "#ffffff"
        smooth: true
        x: 108
        y: 483.5
        opacity: 1

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(oneuniverselink, 13);

            MouseArea {
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("http://www.eveonline.com/universe/")
            }
        }
    }

    Text {
        id: homelink
        text: "Home"
        font.pixelSize: 14
        font.family: engschriftdind.name
        color: "#ffffff"
        smooth: true
        x: 51
        y: 483.5
        opacity: 1

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(homelink, 13);

            MouseArea {
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("http://www.eveonline.com/")
            }
        }
    }

    Text {
        id: thesandboxlink
        text: "The Sandbox"
        font.pixelSize: 14
        font.family: engschriftdind.name
        color: "#ffffff"
        smooth: true
        x: 198
        y: 483.5
        opacity: 1

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(thesandboxlink, 13);

            MouseArea {
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("http://www.eveonline.com/sandbox/")
            }
        }
    }

    Text {
        id: creationslink
        text: "Creations"
        font.pixelSize: 14
        font.family: engschriftdind.name
        color: "#ffffff"
        smooth: true
        x: 288
        y: 483.5
        opacity: 1

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(creationslink, 13);

            MouseArea {
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("http://www.eveonline.com/creations/")
            }
        }
    }

    Text {
        id: capsuleerslink
        text: "Capsuleers"
        font.pixelSize: 14
        font.family: engschriftdind.name
        color: "#ffffff"
        smooth: true
        x: 364
        y: 483.5
        opacity: 1

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(capsuleerslink, 13);

            MouseArea {
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("http://www.eveonline.com/capsuleers/")
            }
        }
    }

    Text {
        id: preinstalllabel
        text: "Pre-Install @"
        font.pixelSize: 10
        font.family: electrolizeregular.name
        color: "#ffffff"
        smooth: true
        x: 453
        y: 300.5
        opacity: 0.30196078431373
    }

    Text {
        id: preinstall
        text: "10 %"
        font.pixelSize: 13
        font.family: electrolizeregular.name
        color: "#ffffff"
        smooth: true
        x: 520
        y: 299.75
        opacity: 1
    }

    Text {
        id: speedlabel
        text: "Speed @"
        font.pixelSize: 10
        font.family: electrolizeregular.name
        color: "#ffffff"
        smooth: true
        x: 453
        y: 315.5
        opacity: 0.30196078431373
        visible: mainRect.speedText.trim().length > 0
    }

    Text {
        id: speed
        text: mainRect.speedText
        font.pixelSize: 13
        font.family: electrolizeregular.name
        color: "#ffffff"
        smooth: true
        x: 521
        y: 314.75
        opacity: 1
        visible: speedlabel.visible
    }

    Text {
        id: totallabel
        text: "Total Size"
        font.pixelSize: 10
        font.family: electrolizeregular.name
        color: "#ffffff"
        smooth: true
        x: 613
        y: 300.5
        opacity: 0.30196078431373
    }

    Text {
        id: total
        text: "13,419.87 MB"
        font.pixelSize: 13
        font.family: electrolizeregular.name
        color: "#ffffff"
        smooth: true
        x: 681
        y: 299.75
        opacity: 1
        visible: totallabel.visible
    }

    Text {
        id: downloadlabel
        text: "Download @"
        font.pixelSize: 10
        font.family: electrolizeregular.name
        color: "#ffffff"
        smooth: true
        x: 615
        y: 315.5
        opacity: 0.30196078431373
        visible: totallabel.visible
    }

    Text {
        id: download
        text: "2,300 MB"
        font.pixelSize: 13
        font.family: electrolizeregular.name
        color: "#ffffff"
        smooth: true
        x: 682
        y: 314.75
        opacity: 1
        visible: downloadlabel.visible
    }

    Button {
        id: minimize
        x: 930
        y: 33
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
        x: 957
        y: 33
        width: 24
        height: 24
        onClicked: Qt.quit();
    }

    FontLoader {
        id: engschriftdind
        source: "EngschriftDIND.ttf"
    }

    FontLoader {
        id: electrolizeregular
        source: "Electrolize-Regular.ttf"
    }

    FontLoader {
        id: opensanslight
        source: "OpenSans-Light.ttf"
    }
}
