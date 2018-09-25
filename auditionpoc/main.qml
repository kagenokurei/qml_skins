import QtQuick 1.1

Item {
    id: item1
    width:360
    height:386

    property string stageDesc: "Downloading"
    property string stageProgress: "100%"
    property string speedText: "500Mbps"

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

    Image {
        id: background
        source: "background.png"
        x: 1
        y: 104
        opacity: 1
    }

    TitleBar {
        x: 0
        y: 0
        width: parent.width
        height: parent.height
    }

    Image {
        id: logo
        source: "logo.png"
        x: 0
        y: 0
        opacity: 1
    }

    Button {
        id: closeBtn
        width: 15
        height: 15
        anchors.right: parent.right
        anchors.rightMargin: 17
        anchors.top: parent.top
        anchors.topMargin: 17
        opacity: 1

        defaultImage: "close.png"
        disabledImage: "close.png"

        onClicked: Qt.quit();
    }

    Button {
        id: playBtn
        x: 226
        y: 333
        width: 107
        height: 29
        opacity: 1

        onClicked: brCmd.brPlay("");

        defaultImage: "playenabled.png"
        disabledImage: "playdisabled.png"
    }

    StatusBox {
        id: logs
        fontPxSize: 10
        textFont: digital.name
        fontBold: false
        fontColor: "#ffffff"
        x: 50
        y: 182
        width: parent.width - 100
        height: 60
        opacity: 1
    }

    Text {
        id: downloadingtxt
        text: (speedText.length == 0) ? (stageProgress + " " + stageDesc) : (stageProgress + " " + stageDesc + " @" + speedText);
        anchors.right: progressBar.right
        anchors.rightMargin: 0
        anchors.top: progressBar.bottom
        anchors.topMargin: 2
        horizontalAlignment: Text.AlignRight
        font.pixelSize: 10
        font.family: digital.name
        font.bold: false
        color: "#ffffff"
        smooth: true
        opacity: 1
    }

    ProgressBar {
        id: progressBar
        x: 30
        y: 337
        width: 188
        height: 7
        barImage: "progress.png"
    }

    FontLoader {
        id: digital
        source: "QuartzMS.TTF"
    }
}
