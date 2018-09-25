import QtQuick 1.1
Item {
    id: mainRect
    width:900
    height:589

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
        source: "bg.png"
        x: 0
        y: 0
        opacity: 1
    }

    ListModel {
        id: characterModel
        ListElement {
            source: "bg1.png"
        }
        ListElement {
            source: "bg2.png"
        }
        ListElement {
            source: "bg3.png"
        }

    }

    Rectangle {
        id: characterflip
        x: 0
        y: 0
        width: 900
        height: 589
        color: "transparent"
        property int modelIndex: 0

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
        id: ouroboros
        source: "ouroboros.png"
        x: 375
        y: 59
        opacity: 0.52156862745098
    }
    Image {
        id: footer
        source: "footer.png"
        x: 35
        y: 497
        opacity: 1
    }
    Text {
        id: accountlink
        text: "Account"
        font.pixelSize: 15
        font.family: robotobold.name
        font.bold: true
        color: "#ababab"
        smooth: true
        x: 82
        y: 514.249142408371
        opacity: 1

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(parent, 13);

            MouseArea {
                hoverEnabled: true
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("http://account.elderscrollsonline.com/login")
                onEntered: parent.parent.color = "white"
                onExited: parent.parent.color = "#ababab"
            }
        }
    }
    Text {
        id: storelink
        text: "Store"
        font.pixelSize: 15
        font.family: robotobold.name
        font.bold: true
        color: "#ababab"
        smooth: true
        x: 175
        y: 514.249142408371
        opacity: 1

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(parent, 13);

            MouseArea {
                hoverEnabled: true
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("http://store.elderscrollsonline.com")
                onEntered: parent.parent.color = "white"
                onExited: parent.parent.color = "#ababab"
            }
        }
    }

    Text {
        id: supportlink
        text: "Support"
        font.pixelSize: 15
        font.family: robotobold.name
        font.bold: true
        color: "#ababab"
        smooth: true
        x: 251
        y: 514.249142408371
        opacity: 1

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(parent, 13);

            MouseArea {
                hoverEnabled: true
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("https://help.elderscrollsonline.com")
                onEntered: parent.parent.color = "white"
                onExited: parent.parent.color = "#ababab"
            }
        }
    }

    Text {
        id: patchnotelink
        text: "Patch Note"
        font.pixelSize: 15
        font.family: robotobold.name
        font.bold: true
        color: "#ababab"
        smooth: true
        x: 341
        y: 513.249142408371
        opacity: 1

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(parent, 13);

            MouseArea {
                hoverEnabled: true
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("https://forums.elderscrollsonline.com/categories/patch-notes")
                onEntered: parent.parent.color = "white"
                onExited: parent.parent.color = "#ababab"
            }
        }
    }

    Image {
        id: slash
        source: "slash.png"
        x: 150
        y: 518
        opacity: 1
    }
    Image {
        id: logscontainer
        source: "logscontainer.png"
        x: 322
        y: 199
        opacity: 1
    }

    StatusBox {
        id: logs
        width: 310
        height: 75
        fontPxSize: 11
        textFont: roboto.name
        fontColor: "#b4b4b4"
        smooth: true
        x: 456
        y: 233
    }

    Image {
        id: progressbarcontainer
        source: "progressbarcontainer.png"
        x: 20
        y: 385
        opacity: 1
    }

    ProgressBar {
        id: progressbar1
        x: 113
        y: 407
        width: 480
        height: 40
        barImage: "streambar.png"
        barValue: 50
    }

    ProgressBar {
        id: progressbar2
        x: 113
        y: 407
        width: 480
        height: 40
        barImage: "preinstallbar.png"
        barValue: 20
    }

    Image {
        id: preinstallmarker
        source: "preinstallmarker.png"
        property real preinstallPct: 0.2
        x: ((progressbar1.width - 58) * preinstallPct) + progressbar1.x + 38
        y: 408
        opacity: 1
    }

    MultiButton {
        id: pauseBtn
        x: 601
        y: 412
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

    Image {
        id: g1
        source: "g1.png"
        x: 39
        y: 357
        opacity: 1
    }

    AnimatedImage {
        id: orbo
        source: "orb-oq.gif"
        x: 56
        y: 331
        opacity: 0.8
    }

    Image {
        id: logo
        source: "logo.png"
        x: 53
        y: 373
        opacity: 1

        transform: Rotation {
            id: mainrotationTransform
            origin.x: 60
            origin.y: 51
            axis.x: 0
            axis.y: 0
            axis.z: 1
            angle: 270
        }

        SequentialAnimation {
            running: true
            loops: Animation.Infinite
            RotationAnimation {
                direction: RotationAnimation.Clockwise
                duration: 60000
                target: mainrotationTransform
                property: "angle"
                from: 0
                to: 180
            }
            RotationAnimation {
                direction: RotationAnimation.Clockwise
                duration: 60000
                target: mainrotationTransform
                property: "angle"
                from: 180
                to: 360
            }
            ScriptAction {
                script: mainrotationTransform.angle = 0
            }
        }
    }
    Text {
        id: preinstalllabel
        text: "Pre-Install @"
        font.pixelSize: 10
        font.family: roboto.name
        color: "#ffffff"
        smooth: true
        x: 180
        y: 389.5
        opacity: 0.5
    }
    Text {
        id: preinstall
        text: "10 %"
        font.pixelSize: 13
        font.family: roboto.name
        color: "#ffffff"
        smooth: true
        x: 248
        y: 389.75
        opacity: 1
    }
    Text {
        id: speedlabel
        text: "Speed @"
        font.pixelSize: 10
        font.family: roboto.name
        color: "#ffffff"
        smooth: true
        x: 180
        y: 447.5
        opacity: 0.5
        visible: mainRect.speedText.trim().length > 0
    }
    Text {
        id: speed
        text: mainRect.speedText
        font.pixelSize: 13
        font.family: roboto.name
        color: "#ffffff"
        smooth: true
        x: 248
        y: 448.75
        opacity: 1
        visible: speedlabel.visible
    }
    Text {
        id: totallabel
        text: "Total Size"
        font.pixelSize: 10
        font.family: roboto.name
        color: "#ffffff"
        smooth: true
        x: 425
        y: 389.5
        opacity: 0.5
    }
    Text {
        id: total
        text: "13,419.87 MB"
        font.pixelSize: 13
        font.family: roboto.name
        color: "#ffffff"
        smooth: true
        x: 480
        y: 389.75
        opacity: 1
        visible: totallabel.visible
    }
    Text {
        id: downloadlabel
        text: "Download @"
        font.pixelSize: 10
        font.family: roboto.name
        color: "#ffffff"
        smooth: true
        x: 437
        y: 447.5
        opacity: 0.5
        visible: totallabel.visible
    }
    Text {
        id: download
        text: "2,300 MB"
        font.pixelSize: 13
        font.family: roboto.name
        color: "#ffffff"
        smooth: true
        x: 504
        y: 448.75
        opacity: 1
        visible: downloadlabel.visible
    }

    Button {
        id: playBtn
        x: 649
        y: 400
        width: 185
        height: 58
        onClicked: brCmd.brPlay("");
        enabled: false

        defaultImage: "play.png"
        disabledImage: "playdisabled.png"
        hoverImage: "playhover.png"
    }

    Button {
        id: minimize
        x: 768
        y: 46
        width: 16
        height: 16
        defaultImage: "minimize.png"
        hoverImage: "minimizehover.png"
        onClicked: cppWindow.minimizeWindow();
    }

    Button {
        id: close
        defaultImage: "close.png"
        hoverImage: "closehover.png"
        x: 786
        y: 46
        width: 16
        height: 16
        onClicked: Qt.quit();
    }

    Image {
        id: logo__1
        source: "logo__1.png"
        x: 388
        y: 82
        opacity: 1
    }
    FontLoader {
        id: roboto
        source: "RobotoCondensed-Regular.ttf"
    }
    FontLoader {
        id: robotobold
        source: "RobotoCondensed-Bold.ttf"
    }

}
