import QtQuick 1.1

Item {
    id: item1
    width:996
    height:653

    property string stageDesc: "Downloading"
    property string stageProgress: "100%"
    property string speedText: "500Mbps"
    property real downloadedBytes: 1234
    property real totalBytes: 2345

    /*
    REQUIRED FUNCTIONS
    */
    function setStageText(textToSet) {
        stageDesc = textToSet;
        stageDesc = stageDesc.replace(":", "");
    }

    function setSubStageText(textToSet) {

    }

    function setMainProgress(progress) {
        progressBar.barValue = progress;
        setMainProgressText(Math.round(progress) + "%");
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

                item1.downloadedBytes = receivedMBytes;
                item1.totalBytes = totalMBytes;

                bytestxt.visible = true;
            } else {
                bytestxt.visible = false;
            }
        }
    }

    Image {
        id: border
        source: "border.png"
    }

    Browser {
        x: 8
        y: 7
        width: 980
        height: 640
    }

//    Image {
//        id: background
//        x: 8
//        y: 7
//        source: "background.png"
//        opacity: 1
//    }

//    Image {
//        x: 8
//        y: 7
//        source: "template.png"
//        opacity: 0.25
//    }

//    Image {
//        id: go_logo
//        x: 787
//        y: -10
//        source: "go_logo.png"
//    }

//    Image {
//        id: logo
//        source: "logo.png"
//        x: 11
//        y: 19
//        opacity: 1
//    }

//    Image {
//        id: bg
//        x: 345
//        y: 51
//        source: "bg.png"
//    }

    Image {
        id: footer
        x: 8
        y: 557
        source: "footer.png"
    }

    Image {
        id: progress_bg
        x: 22
        y: 589
        opacity: 1
        source: "progress_bg.png"
    }

    TitleBar {
        x: 0
        y: 0
        width: parent.width
        height: 100
    }


    Button {
        id: closeBtn
        width: 15
        height: 15
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.top: parent.top
        anchors.topMargin: 11
        opacity: 1

        defaultImage: "close.png"
        disabledImage: "close.png"

        onClicked: Qt.quit();
    }

    Button {
        id: playBtn
        x: 744
        y: 566
        width: 232
        height: 80
        opacity: 1
        enabled: false

        onClicked: brCmd.brPlay("");

        defaultImage: "playenabled.png"
        disabledImage: "playdisabled.png"
        hoverImage: "playhover.png"
    }

    StatusBox {
        id: logs
        width: 410
        fontPxSize: 14
        textFont: digital.name
        fontBold: false
        fontColor: "#ffffff"
        height: 20
        anchors.top: progressBar.bottom
        anchors.topMargin: -12
        anchors.left: downloadingtxt.left
        anchors.leftMargin: 0
        opacity: 1
    }

    Text {
        id: downloadingtxt
        x: 33
        y: 576
        text: stageDesc.toUpperCase()
        font.pointSize: 11//(speedText.length == 0) ? (stageProgress + " " + stageDesc) : (stageProgress + " " + stageDesc + " @" + speedText);
        horizontalAlignment: Text.AlignRight
        font.family: digital.name
        font.bold: false
        color: "#ffffff"
        smooth: true
        opacity: 1
    }

    Text {
        id: progresstxt
        x: 524
        y: 576
        text: stageProgress.toUpperCase()
        font.pointSize: 11
        horizontalAlignment: Text.AlignRight
        font.family: digital.name
        font.bold: false
        color: "#ffffff"
        smooth: true
        opacity: 1
    }

    Text {
        id: bytestxt
        x: 353
        y: 576
        text: item1.downloadedBytes.toFixed(2) + "MB / " + item1.totalBytes.toFixed(2) + "MB"
        anchors.right: parent.right
        anchors.rightMargin: 502
        font.pointSize: 10
        horizontalAlignment: Text.AlignRight
        font.family: digital.name
        font.bold: false
        color: "#009bcc"
        smooth: true
        opacity: 1
        visible: false
    }

    Text {
        id: speedTxt
        x: 505
        y: 619
        text: item1.speedText
        anchors.right: parent.right
        anchors.rightMargin: 436
        font.pointSize: 10
        horizontalAlignment: Text.AlignRight
        font.family: digital.name
        font.bold: false
        color: "#ff00a0ce"
        smooth: true
        opacity: 1
        visible: item1.speedText.trim().length > 0
    }


    ProgressBar {
        id: progressBar
        x: 21
        y: 589
        width: 563
        height: 41
        barImage: "progress.png"
    }

    FontLoader {
        id: digital
        source: "segoeui.TTF"
    }

}
