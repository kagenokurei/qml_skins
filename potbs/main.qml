import QtQuick 1.1

Item {
    id: mainRect
    width:420
    height:620

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

    function setRepairEnable(bEnabled) {
        repairBtn.enabled = bEnabled;
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
        source: "animation.gif"
        x: 10
        y: 10
        opacity: 1
    }

    TitleBar {
        anchors.fill: parent
    }

    Image {
        id: parchment
        source: "parchment.png"
        x: 3
        y: 224
        opacity: 1
    }
    Image {
        id: brlogo
        source: "brlogo.png"
        x: 323
        y: 580
        opacity: 0.8
    }
    Text {
        id: copyright
        text: "Copyright ©  2014 Portalus Games LLC . All rights reserved. "
        font.pixelSize: 8
        font.family: opensans.name
        color: "#ffffff"
        smooth: true
        x: 24
        y: 585.94854259491
        opacity: 0.6
    }

    StatusBox {
        id: logs
        fontPxSize: 11
        textFont: opensanssemibold.name
        fontColor: "#a17217"
        smooth: true
        x: 29
        y: 305
        width: 365
        height: 74
        opacity: 1
    }

    Image {
        id: pirates_logo_med
        source: "pirates_logo_med.png"
        x: 71
        y: 53
        opacity: 1
    }
    Image {
        id: skull1
        source: "skull1.png"
        x: 173
        y: 204
        opacity: 1
    }

    Button {
        id: minimize
        defaultImage: "minimize.png"
        hoverImage: "minimizehover.png"
        x: 372
        y: 17
        width: 14
        height: 14
        onClicked: cppWindow.minimizeWindow();
    }

    Button {
        id: close
        defaultImage: "close.png"
        hoverImage: "closehover.png"
        x: 387
        y: 17
        width: 14
        height: 14
        onClicked: Qt.quit();
    }

    Button {
        id: playBtn
        x: 116
        y: 531
        width: 191
        height: 41
        onClicked: brCmd.brPlay("");
        opacity: enabled ? 1 : 0.3
        enabled: false
        defaultImage: "playnow.png"
        hoverImage: "playnowhover.png"
    }

    ProgressBar {
        id: progressbar1
        barImage: "streambar.png"
        x: 33
        y: 422
        width: 331
        height: 13
        opacity: 1
        barValue: 50
    }

    ProgressBar {
        id: progressbar2
        barImage: "preinstallbar.png"
        x: 33
        y: 422
        width: 331
        height: 13
        opacity: 1
        barValue: 20
    }

    Image {
        id: barholder
        source: "barholder.png"
        x: 135
        y: 426
        opacity: 1
    }

    MultiButton {
        id: pauseBtn
        x: 375
        y: 413
        width: 31
        height: 31
        opacity: enabled ? 1 : 0.3

        onClicked: {
            isPaused = brCmd.brTogglePause();
            refreshImage();
        }
        property bool isPaused: false

        defaultImage: isPaused ? "play.png" : "pause.png"
        hoverImage: isPaused ? "playhover.png" : "pausehover.png"
    }

    Image {
        id: skull2
        source: "skull2.png"
        x: 170
        y: 456
        opacity: 1
    }
    Text {
        id: preinstalllabel
        text: "Pre-Install @"
        font.pixelSize: 10
        font.family: electrolize.name
        color: "#ac842f"
        smooth: true
        x: 31
        y: 478.5
        opacity: 1
    }
    Text {
        id: preinstall
        text: "10 %"
        anchors.right: skull2.left
        anchors.rightMargin: 2
        horizontalAlignment: Text.AlignRight
        font.pixelSize: 12
        font.family: electrolize.name
        color: "#f19c1d"
        smooth: true
        y: 477.75
        opacity: 1
    }
    Text {
        id: speedlabel
        text: "Speed @"
        font.pixelSize: 10
        font.family: electrolize.name
        color: "#ad852f"
        smooth: true
        x: 31
        y: 493.5
        opacity: 1
        visible: mainRect.speedText.trim().length > 0
    }
    Text {
        id: speed
        text: mainRect.speedText
        anchors.right: skull2.left
        anchors.rightMargin: 0
        horizontalAlignment: Text.AlignRight
        font.pixelSize: 12
        font.family: electrolize.name
        color: "#f0971d"
        smooth: true
        y: 493
        opacity: 1
        visible: speedlabel.visible
    }
    Text {
        id: totallabel
        text: "Total Size"
        font.pixelSize: 10
        font.family: electrolize.name
        color: "#ad852f"
        smooth: true
        x: 248
        y: 478.5
        opacity: 1
    }
    Text {
        id: total
        text: "13,419.87 MB"
        anchors.right: parent.right
        anchors.rightMargin: 32
        horizontalAlignment: Text.AlignRight
        font.pixelSize: 12
        font.family: electrolize.name
        color: "#f0971d"
        smooth: true
        y: 477.75
        opacity: 1
        visible: totallabel.visible
    }
    Text {
        id: downloadlabel
        text: "Download @"
        font.pixelSize: 10
        font.family: electrolize.name
        color: "#ad852f"
        smooth: true
        x: 250
        y: 493.5
        opacity: 1
        visible: totallabel.visible
    }
    Text {
        id: download
        text: "2,300 MB"
        anchors.right: parent.right
        anchors.rightMargin: 32
        horizontalAlignment: Text.AlignRight
        font.pixelSize: 12
        font.family: electrolize.name
        color: "#f0971d"
        smooth: true
        y: 492.75
        opacity: 1
        visible: downloadlabel.visible
    }
    Image {
        id: preinstallmarker
        source: "preinstallmarker.png"
        property real preinstallPct: 0.15
        x: progressbar1.width * preinstallPct + progressbar1.x - 11
        y: 393
        opacity: 1
    }

    Button {
        id: repairBtn
        defaultImage: "repairoptionbutton.png"
        hoverImage: "repairoptionbuttonhover.png"
        x: 355
        y: 17
        width: 15
        height: 15
        opacity: enabled ? 1 : 0.3
        onClicked: {
            modalRect.visible = true;
            radioGroup1.selected = radioBtn1
        }
    }

    Rectangle {
        id: modalRect
        color: "transparent"
        anchors.fill: mainRect
        visible: false
        MouseArea {
            anchors.fill: modalRect
            enabled: true
            hoverEnabled: true
        }

        Image {
            id: repairoverlay
            source: "repairoverlay.png"
            x: 1
            y: 1
            opacity: 1
        }

        Button {
            id: repairOkBtn
            defaultImage: "ok.png"
            hoverImage: "okhover.png"
            x: 172
            y: 364
            width: 100
            height: 35
            onClicked: {
                /* action here */
                modalRect.visible = false;
                if(radioGroup1.selected == radioBtn1)
                {
                    brCmd.brReauditPackage(5) //5 is Speed Audit
                }
                else if (radioGroup1.selected == radioBtn2)
                {
                    brCmd.brReauditPackage(4) //4 is Full Audit
                }
            }
        }

        Text {
            id: repairoptionslabel
            text: "Repair Options"
            font.pixelSize: 17
            font.family: pertibd.name
            font.bold: true
            color: "#000000"
            smooth: true
            x: 53
            y: 223.552083492279
            opacity: 1
        }

        Button {
            id: repairCancelBtn
            defaultImage: "cancel.png"
            hoverImage: "canceloverlay.png"
            x: 267
            y: 364
            width: 100
            height: 35
            onClicked: {
                modalRect.visible = false;
            }
        }

        Text {
            id: quickrepairlabel
            text: "Quick Repair"
            font.pixelSize: 11
            font.family: opensans.name
            color: "#000000"
            smooth: true
            x: 146
            y: 277.052709102631
            opacity: 1
        }
        Text {
            id: fullrepairlabel
            text: "Full Repair (Might take longer)"
            font.pixelSize: 11
            font.family: opensans.name
            color: "#000000"
            smooth: true
            x: 147
            y: 305.052709102631
            opacity: 1
        }

        RadioGroup {
            id: radioGroup1
        }
        RadioButton {
            id: radioBtn1
            x: 115
            y: 273
            radioGroup: radioGroup1
            width: 22
            height: 22
            normalImage: "unchecked.png"
            checkedImage: "checked.png"
        }

        RadioButton {
            id: radioBtn2
            x: 115
            y: 301
            radioGroup: radioGroup1
            width: 22
            height: 22
            normalImage: "unchecked.png"
            checkedImage: "checked.png"
        }
    }

    FontLoader {
        id: pertibd
        source: "PERTIBD.TTF"
    }

    FontLoader {
        id: electrolize
        source: "Electrolize-Regular.ttf"
    }
    FontLoader {
        id: opensans
        source: "OpenSans-Regular.ttf"
    }
    FontLoader {
        id: opensanssemibold
        source: "OpenSans-Semibold.ttf"
    }
}
