import QtQuick 1.1

Item {
    id: item1
    width:768
    height:398

    property string stageProgress: "100%"
    property string speedText: "500Mbps"

    /*
    REQUIRED FUNCTIONS
    */
    function setStageText(textToSet) {

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
        //logs.addText(textToAppend);
    }

    function setPlayEnable(bEnable) {
        //playBtn.enabled = bEnable;
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

                downloadvalue.text = receivedMBytes.toFixed(2) + " MB";
                totalsize.text = totalMBytes.toFixed(2) + " MB";

                downloadvalue.visible = true;
                totalsize.visible = true;
            } else {

                downloadvalue.visible = false;
                totalsize.visible = false;
            }
        }
    }

    Image {
        id: background
        source: "background.png"
        opacity: 1
    }

    TitleBar {
        x: 0
        y: 0
        width: parent.width
        height: parent.height
    }

    Button {
        id: closeBtn
        x: 697
        width: 23
        height: 23
        anchors.right: parent.right
        anchors.rightMargin: 48
        anchors.top: parent.top
        anchors.topMargin: 33
        opacity: 1

        defaultImage: "close_hover.png"
        disabledImage: "close_hover.png"

        onClicked: Qt.quit();
    }

    Button {
        id: minimizeBtn
        x: 657
        width: 24
        height: 2
        anchors.right: parent.right
        anchors.rightMargin: 87
        anchors.top: parent.top
        anchors.topMargin: 53
        opacity: 1

        defaultImage: "minimize_hover.png"
        disabledImage: "minimize_hover.png"

        onClicked: cppWindow.minimizeWindow();

    }

    Text {
        id: downloadingtxt
        x: 233
        y: 176
        text: stageProgress;
        anchors.right: parent.right
        anchors.rightMargin: 502
        horizontalAlignment: Text.AlignRight
        font.pixelSize: 14
        font.family: digital.name
        font.bold: false
        color: "#000000"
        smooth: true
        opacity: 1
    }

    Text {
        id: speedtxt
        x: 211
        y: 267
        text: speedText;
        anchors.right: parent.right
        anchors.rightMargin: 502
        horizontalAlignment: Text.AlignRight
        font.pixelSize: 14
        font.family: digital.name
        font.bold: false
        color: "#000000"
        smooth: true
        opacity: 1
    }

    Text {
        id: downloadvalue
        y: 176
        horizontalAlignment: Text.AlignRight
        font.pixelSize: 14
        font.family: digital.name
        font.bold: false
        color: "#000000"
        anchors.left: parent.left
        anchors.leftMargin: 498
        smooth: true
        opacity: 1
    }

    Text {
        id: totalsize
        y: 264
        horizontalAlignment: Text.AlignRight
        font.pixelSize: 14
        font.family: digital.name
        font.bold: false
        color: "#000000"
        anchors.left: parent.left
        anchors.leftMargin: 498
        smooth: true
        opacity: 1
    }

    ProgressBar {
        id: progressBar
        x: 196
        y: 335
        width: 376
        height: 26
        barImage: "fillbar.png"
    }

    FontLoader {
        id: digital
        source: "Montserrat-Light.otf"
    }
}
