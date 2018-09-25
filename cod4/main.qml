import QtQuick 1.1

Rectangle {
    id: mainRect
    width: 738
    height: 641
    color: "#00000000"

    property string stageDesc: "Downloading"
    property string stageProgress: "100%"
    property string speedText: "500Mbps"

    /*
    REQUIRED FUNCTIONS
    */
    function setStageText(textToSet) {
        mainRect.stageDesc = textToSet;
//        stageDesc = stageDesc.replace(":", " @");
    }

    function setSubStageText(textToSet) {

    }

    function setMainProgress(progress) {
        progressRect1.width = 219 * (progress / 100);
        setMainProgressText(Math.round(progress) + "%");
    }

    function setMainProgressText(textToSet) {
        mainRect.stageProgress = textToSet;
    }

    function setSubProgress(progress) {
        progressRect2.width = 219 * (progress / 100);
        progressText2.text = Math.round(progress) + "%";
    }

    function setSubProgressText(textToSet) {

    }

    function setXferSpeedText(textToSet) {
        mainRect.speedText = textToSet;
    }

    function appendStatusText(textToAppend) {
        logs.addText(textToAppend);
    }

    function setPlayEnable(bEnable) {
//        playBtn.enabled = bEnable;
    }

    function setPauseState(bIsPaused) {
//        pauseBtn.isPaused = bIsPaused;
    }

    function setPauseEnable(bIsEnabled) {
//        pauseBtn.enabled = bIsEnabled;
    }

    /*
    END REQUIRED FUNCTIONS
    */

//    Component.onCompleted: mainTimer.start();

    Image {
        id: backgroundImg
        source: "COD4Back.png"
    }

    TitleBar {
        anchors.fill: parent
    }

    StatusBox {
        id: logs
        x: 38
        y: 404
        width: 301
        height: 197
        fontPxSize: 13

    }

//    Timer {
//        id: mainTimer
//        interval: 250
//        repeat: true
//        onTriggered: {
//            //refresh UI data here

//            //retrieve current stage
//            var stage = brQuery.getStage();
//            switch(stage) {
//            case 101: { //STAGE_REQUIREDASSETS
//                stageDesc.text = qsTr("Downloading required assets");
//                break;
//            }
//            case 100: { //STAGE_ALLOCATINGSPACE
//                stageDesc.text = qsTr("Allocating Space");
//                break;
//            }
//            case 102: { //STAGE_REMAININGASSETS
//                stageDesc.text = qsTr("Downloading remaining assets");
//                break;
//            }
//            case 103: { //STAGE_INITIALIZING
//                stageDesc.text = qsTr("Initializing");
//                break;
//            }
//            case 104: { //STAGE_UNINITIALIZING
//                stageDesc.text = qsTr("Uninitializing");
//                break;
//            }
//            default: {
//                stageDesc.text = qsTr("Error - Stage unknown")
//                break;
//            }
//            }

//            //retrieve progress
//            var progress = brQuery.getProgress();
//            progressRect1.width = 219 * (progress / 100);
//            progressText1.text = progress + "%";

//            //retrieve sub-progress
//            progress = brQuery.getSubProgress();
//            progressRect2.width = 219 * (progress / 100);
//            progressText2.text = progress + "%";

//            //retrieve xfer rate
//            var xferRate = brQuery.getTransferRate();
//            var affix = 0;
//            while(xferRate >= 1024) {
//                xferRate = xferRate / 1024;
//                affix++;
//            }

//            switch(affix){
//            case 0: affix = "KB/s"; break;
//            case 1: affix = "MB/s"; break;
//            case 2: affix = "GB/s"; break;
//            default: affix = "TB/s"; break;
//            }
//            speedText.text = xferRate + affix;
//        }
//    }

    Text {
        id: progressText1
        x: 617
        y: 420
        color: "#ffffff"
        text: mainRect.stageProgress
        font.pixelSize: 12
    }

    Rectangle {
        id: progressRect1
        x: 394
        y: 422
        width: 219
        height: 10
        color: "#00000000"
        clip: true

        Image {
            id: progressBar1
            width: 219
            height: 10
            source: "bar_prg_0.png"
        }
    }

    Rectangle {
        id: progressRect2
        x: 394
        y: 469
        width: 219
        height: 10
        color: "#00000000"
        clip: true

        Image {
            id: progressBar2
            width: 219
            height: 10
            source: "bar_prg_0.png"
        }
    }

    Image {
        id: closeImg
        x: 662
        y: 355
        anchors.top: parent.top
        anchors.topMargin: 355
        anchors.right: parent.right
        anchors.rightMargin: 49
        source: "COD_close_up.png"

        MouseArea {
            id: closeBtn
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.source = "COD_close_ov.png"
            onExited: parent.source = "COD_close_up.png"
            onPressed: parent.source = "COD_close_dn.png"
            onReleased: parent.source = "COD_close_up.png"
            onClicked: Qt.quit();
        }
    }

    Text {
        id: stageDesc
        x: 392
        y: 404
        width: 63
        height: 18
        color: "#ffffff"
        text: mainRect.stageDesc
        font.pixelSize: 12
    }

    Text {
        id: progressText2
        x: 617
        y: 467
        color: "#ffffff"
        text: ""
        font.pixelSize: 12
    }

    Text {
        id: speedText
        color: "#ffffff"
        text: mainRect.speedText
        anchors.bottom: progressRect2.top
        anchors.bottomMargin: 3
        anchors.right: progressRect2.left
        anchors.rightMargin: -219
        horizontalAlignment: Text.AlignRight
        font.pixelSize: 12
    }

}
