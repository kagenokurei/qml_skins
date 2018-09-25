import QtQuick 1.1

Item {
    id: mainRect
    width:1124
    height:570

    property string stageDesc: "Downloading"
    property string stageProgress: "100%"
    property string speedText: "500Mbps"
    property bool bPlayAfterLogin: false

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

        streampatchprogress.barValue = progress;
        preinstalllabel.text = mainRect.stageDesc
        preinstallvalue.text = mainRect.stageProgress
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

    function readLoginCreds() {
        //read login creds off file
        var fileName = brCmd.brGetInstallPath();
        fileName += "Client/LoginData.json"
        var textString = brCmd.brReadTextFileContents(fileName);
        if(textString.length > 0) {
            var jsonObject;
            var bHasError = false;
            try {
                jsonObject = eval('(' + textString + ')');
            } catch (e) {
                console.log("Unable to evaluate json:\n" + textString + "\nerror: " + e.message);
                bHasError = true;
            } finally {
                if(!loginDialog.visible && bHasError) {
                    unameBox.text = "";
                    pwordBox.text = "";
                    loginDialog.visible = true;
                    return;
                }
            }

            if(typeof(jsonObject.username) != "undefined")
                unameBox.text = jsonObject.username
            if(typeof(jsonObject.password) != "undefined")
                pwordBox.text = jsonObject.password
        }
    }

    function writeLoginCreds() {
        if((pwordBox.text.length > 0) && (unameBox.text.length > 0)) {
            //write login creds to file
            var fileName = brCmd.brGetInstallPath();
            fileName += "Client/LoginData.json"
            var textToWrite = "{\"username\":\"" + unameBox.text + "\",\"password\":\"" + pwordBox.text + "\",\"star_network\":{\"hostname\":\"service-public1.universe.robertsspaceindustries.com\",\"port\":8000}}";

            console.log("Writing " + textToWrite + " to " + fileName);
            brCmd.brWriteTextFile(textToWrite, fileName);
        }
    }

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

                downloadvalue.text = receivedMBytes.toFixed(2) + " MB / "  + totalMBytes.toFixed(2) + " MB";
                preinstalllabel.text = mainRect.stageDesc;
                preinstallvalue.text = mainRect.stageProgress;

                //xferred bar
                var pctXferred = brQuery.getGenericUalt2(5/*XFER*/) / 100;
                var pctPendingXfer = brQuery.getSpecUval2(5/*XFER*/) / totalBytes * 100;
                if(preinstallprogress.barValue == 0)
                    streampatchprogress.barValue = pctXferred + pctPendingXfer;
                else if((pctXferred + pctPendingXfer) > streampatchprogress.barValue)
                    streampatchprogress.barValue = pctXferred + pctPendingXfer;

                //unpacked bar
                preinstallprogress.barValue = pctRecvd;

                preinstallindicator.preinstallPct = preInstallPct;
                preinstallindicator.visible = true;
                downloadlabel.visible = true;
                downloading.visible = true;

                if(!loginCreds.enabled)
                    loginCreds.enabled = true;

                if(!loginDialog.visible) {
                    //login dialog is hidden; check if we have login creds present
                    if((unameBox.text.length == 0) || (pwordBox.text.length == 0)) {
                        //try reading login creds
                        readLoginCreds();

                        //check if our creds is still incomplete
                        if((unameBox.text.length == 0) || (pwordBox.text.length == 0)) {
                            //still incomplete; show login dialog
                            loginDialog.visible = true;
                        }
                    }
                }
            } else {
                downloadlabel.visible = false;
                downloading.visible = false;
                preinstallindicator.visible = false;
                preinstallprogress.barValue = 0;
                loginCreds.enabled = false;
            }
        }
    }

    Image {
        id: backgroundlayer1
        source: "backgroundlayer1.png"
        x: 0
        y: 0
        opacity: 1
    }

    AnimatedImage {
        id: backgroundlayer2
        source: "snow2.gif"
        width: 1100
        height: 546
        x: 12
        y: 12
        opacity: 0.30196078431373
    }

    Image {
        id: backgroundlayer3
        source: "backgroundlayer3.png"
        x: -1
        y: 0
        opacity: 1
    }

    TitleBar {
        width: 1100
        height: 546
        x: 12
        y: 12
    }

    Button {
        id: closebutton
        defaultImage: "closebutton.png"
        disabledImage: "closebutton.png"
        x: 1065
        y: 17
        width: 40
        height: 40
        onClicked: {
            if((unameBox.text.length > 0) && (pwordBox.text.length > 0)) {
                writeLoginCreds();
            }
            Qt.quit();
        }
    }

    Button {
        id: minimizebutton
        defaultImage: "minimizebutton.png"
        disabledImage: "minimizebutton.png"
        x: 1035
        y: 24
        width: 39
        height: 33
        onClicked: cppWindow.minimizeWindow();
    }

    Rectangle {
        id: downloadbarcontainer
        x: 194
        y: 454
        width: 579
        height: 18
        color: "transparent"

        Image {
            source: "downloadbarcontainer.png"
        }

        Image {
            source: "nullbar.png"
            y: 7
        }

        Rectangle {
            id: streampatchprogress
            clip: true
            color: "transparent"
            y: 7
            width: downloadbarcontainer.width * barValue / 100
            height: 4
            property int barValue: 45

            Image {
                source: "streampatchprogress.png"
            }
        }

        Rectangle {
            id: preinstallprogress
            clip: true
            color: "transparent"
            y: 7
            width: downloadbarcontainer.width * barValue / 100
            height: 4
            property int barValue: 20

            Image {
                source: "preinstallprogress.png"
            }
        }

        Image {
            property real preinstallPct: 0.25
            id: preinstallindicator
            source: "preinstallindicator.png"
            x: downloadbarcontainer.width * preinstallPct - 4
            opacity: 1
            visible: preinstallPct > 0
        }
    }

    Text {
        id: speedlabel
        text: "speed @"
        font.pixelSize: 11
        font.family: electrolize.name
        color: "#6d9fbb"
        smooth: true
        x: 194
        y: 476.25
        opacity: 0.50196078431373
        visible: speedvalue.text.length > 0
    }
    Text {
        id: speedvalue
        text: speedText.trim()
        font.pixelSize: 13
        font.family: opensans.name
        color: "#a2d8f2"
        smooth: true
        x: 240
        y: 475
        opacity: 1
        visible: speedlabel.visible
    }
    Text {
        id: preinstalllabel
        text: "Preinstall @"
        font.pixelSize: 11
        font.family: electrolize.name
        color: "#6d9fbb"
        smooth: true
        anchors.left: downloadbarcontainer.left
        anchors.leftMargin: 1
        y: 437.25
        opacity: 0.50196078431373
    }
    Text {
        id: preinstallvalue
        text: "70%"
        font.pixelSize: 13
        font.family: opensans.name
        color: "#a0daf4"
        smooth: true
        anchors.left: preinstalllabel.right
        anchors.leftMargin: 6
        y: 437
        opacity: 1
    }
    Text {
        id: downloadlabel
        text: "Download  @"
        horizontalAlignment: Text.AlignRight
        font.pixelSize: 11
        font.family: electrolize.name
        color: "#6d9fbb"
        smooth: true
        anchors.right: downloadvalue.left
        anchors.rightMargin: 6
        y: 476
        opacity: 0.50196078431373
    }
    Text {
        id: downloadvalue
        text: "23%"
        horizontalAlignment: Text.AlignRight
        font.pixelSize: 13
        font.family: opensans.name
        color: "#9fdbf4"
        smooth: true
        anchors.right: downloadbarcontainer.right
        anchors.rightMargin: 0
        y: 474
        opacity: 1
        visible: downloadlabel.visible
    }
    Text {
        id: statuslabel
        text: "Status"
        horizontalAlignment: Text.AlignRight
        font.pixelSize: 11
        font.family: electrolize.name
        color: "#6d9fbb"
        smooth: true
        x: 685
        y: 437
        opacity: 0.50196078431373
        visible: playBtn.enabled
    }
    Text {
        id: statusvalue
        text: "Playable"
        horizontalAlignment: Text.AlignRight
        font.pixelSize: 13
        font.family: opensans.name
        color: "#a3d8f1"
        smooth: true
        x: 722
        y: 437
        opacity: 1
        visible: statuslabel.visible
    }

    MultiButton {
        id: pauseBtn
        x: 786
        y: 454
        width: 15
        height: 18

        onClicked: {
            isPaused = brCmd.brTogglePause();
            refreshImage();
        }
        property bool isPaused: false

        defaultImage: isPaused ? "resume.png" : "pause.png"
        disabledImage: isPaused ? "resume.png" : "pause.png"
        hoverImage: isPaused ? "resumehover.png" : "pausehover.png"
    }

    StatusBox {
        id: logs
        fontPxSize: 10
        textFont: electrolize.name
        fontColor: "#ffffff"
        smooth: true
        x: 206
        y: 321.5
        width: 389
        height: 65
        visible: !loginDialog.visible
    }

    Image {
        id: logscontainer
        source: "logscontainer.png"
        x: 194
        y: 309
        opacity: 1
        visible: logs.visible
    }

//    Image {
//        id: blinker
//        source: "blinker.png"
//        x: 318
//        y: 406
//        opacity: 1
//        SequentialAnimation on opacity {
//            loops: Animation.Infinite
//            NumberAnimation {
//                easing.type: Easing.InOutSine
//                to: 0
//                duration: 250
//            }
//            NumberAnimation {
//                easing.type: Easing.InOutSine
//                to: 1
//                duration: 250
//            }
//        }

//        visible: downloading.visible
//    }

    MouseArea {
        id: playBtn
        x: 826
        y: 436
        width: 266
        height: 52
        enabled: false
        onClicked: {
            if((unameBox.text.length == 0) || (pwordBox.text.length == 0)) {
                mainRect.bPlayAfterLogin = true;
                loginDialog.visible = true;
            } else {
                writeLoginCreds();
                brCmd.brPlay("");
            }
        }
        hoverEnabled: true
        Component.onCompleted: cppWindow.setItemCursor(playBtn, 13);
        onEntered: {
            if(!enabled)
                return;
            if(leaveAnimation.running)
                leaveAnimation.stop();
            hoverAnimation.start();
        }
        onExited: {
            if(!enabled)
                return;
            if(hoverAnimation.running)
                hoverAnimation.stop();
            leaveAnimation.start();
        }

        SequentialAnimation {
            id: hoverAnimation
            ParallelAnimation {
                PropertyAnimation {
                    easing.type: Easing.OutSine
                    target: buttonbottomright
                    property: "x"
                    to: 13
                    duration: 150
                }
                PropertyAnimation {
                    easing.type: Easing.OutSine
                    target: buttonbottomright
                    property: "y"
                    to: 0
                    duration: 150
                }
            }
            PropertyAnimation {
                easing.type: Easing.OutSine
                target: buttontopleft
                property: "x"
                to: 13
                duration: 150
            }
            ScriptAction {
                script: buttonlabelplaynow.color = "white"
            }
        }

        ParallelAnimation {
            id: leaveAnimation
            PropertyAnimation {
                easing.type: Easing.OutSine
                target: buttonbottomright
                property: "x"
                to: 5
                duration: 150
            }
            PropertyAnimation {
                easing.type: Easing.OutSine
                target: buttonbottomright
                property: "y"
                to: 8
                duration: 150
            }
            PropertyAnimation {
                easing.type: Easing.OutSine
                target: buttontopleft
                property: "x"
                to: 0
                duration: 150
            }
            ScriptAction {
                script: buttonlabelplaynow.color = "#00d7ff"
            }
        }

        Image {
            id: buttontopleft
            source: playBtn.enabled ? "buttontopleft.png" : "buttontopleftdisable.png"
            opacity: playBtn.enabled ? 1 : 0.3
        }

        Text {
            id: buttonlabelplaynow
            text: "Play Now"
            font.pixelSize: 17
            font.family: electrolize.name
            color: playBtn.enabled ? "#00d7ff" : "#434343"
            smooth: true
            anchors.left: buttontopleft.left
            anchors.leftMargin: 87
            y: 10.75
        }

        Image {
            id: buttonbottomright
            source: playBtn.enabled ? "buttonbottomright.png" : "buttonbottomrightdisable.png"
            opacity: playBtn.enabled ? 1 : 0.3
            x: 5
            y: 8
        }

        onEnabledChanged: {
            if(enabled) {
                buttonlabelplaynow.color = "#00d7ff";
            } else {
                buttonlabelplaynow.color = "#434343";
            }
        }
    }

    Text {
        id: copyright
        text: "© 2014 Cloud Imperium Games"
        font.pixelSize: 12
        font.family: opensanslight.name
        color: "#87afd7"
        smooth: true
        x: 775
        y: 519
        opacity: 1
    }

    MouseArea {
        id: linkwebsite
        width: 55
        height: 16
        x: 48
        y: 218.75
        onClicked: Qt.openUrlExternally("https://robertsspaceindustries.com")

        Text {
            text: "WEBSITE"
            font.pixelSize: 13
            font.family: electrolize.name
            color: "#ffffff"
            smooth: true
            opacity: 1
        }

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(linkwebsite, 13);
        }
    }

    MouseArea {
        id: linkcommunity
        width: 80
        height: 16
        x: 49
        y: 247.75
        onClicked: Qt.openUrlExternally("https://forums.robertsspaceindustries.com/")

        Text {
            text: "COMMUNITY"
            font.pixelSize: 13
            font.family: electrolize.name
            color: "#ffffff"
            smooth: true
            opacity: 1
        }

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(linkcommunity, 13);
        }
    }

    MouseArea {
        id: linkfaq
        width: 26
        height: 16
        x: 49
        y: 277.75
        onClicked: Qt.openUrlExternally("https://robertsspaceindustries.com/faq")

        Text {
            text: "FAQ"
            font.pixelSize: 13
            font.family: electrolize.name
            color: "#ffffff"
            smooth: true
            opacity: 1
        }

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(linkfaq, 13);
        }
    }

    MouseArea {
        id: linksupport
        width: 60
        height: 16
        x: 48
        y: 305.75
        onClicked: Qt.openUrlExternally("https://robertsspaceindustries.com/contact")

        Text {
            text: "SUPPORT"
            font.pixelSize: 13
            font.family: electrolize.name
            color: "#ffffff"
            smooth: true
            opacity: 1
        }

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(linksupport, 13);
        }
    }

    MouseArea {
        id: loginCreds
        width: 50
        height: 16
        x: 48
        y: 334.75
        onClicked: {
            loginDialog.visible = true
        }
        enabled: false

        Text {
            text: "SIGN-IN"
            font.pixelSize: 13
            font.family: electrolize.name
            color: "#ffffff"
            smooth: true
            opacity: loginCreds.enabled ? 1 : 0.3
        }

        Rectangle {
            anchors.fill: parent
            color: "#01000000"
            Component.onCompleted: cppWindow.setItemCursor(loginCreds, 13);
        }
    }


    Text {
        id: downloading
        text: "DOWNLOADING"
        font.pixelSize: 18
        font.family: electrolize.name
        color: "#00d7ff"
        smooth: true
        x: 195
        y: 415.5
        opacity: 1
    }

    Image {
        id: loginDialog
        source: "credsoverlay.png"
        x: -1
        y: 0
        opacity: 1
        visible: false
        onVisibleChanged: {
            if(visible) {
                readLoginCreds();
            } else {
                if(mainRect.bPlayAfterLogin) {
                    mainRect.bPlayAfterLogin = false;
                    if((unameBox.text.length > 0) && (pwordBox.text.length > 0)) {
                        writeLoginCreds();
                        brCmd.brPlay(""); //only allow play when both fields are populated
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
        }

        Button {
            defaultImage: "closebutton.png"
            disabledImage: "closebutton.png"
            x: 743
            y: 166
            width: 40
            height: 40
            onClicked: loginDialog.visible = false
        }

        MouseArea {
            x: 353
            y: 323
            width: 80
            height: 29
            id: btnArea
            hoverEnabled: true
            onClicked: {
                writeLoginCreds();
                loginDialog.visible = false;
            }

            Rectangle {
                anchors.fill: parent
                color: "#01000000"
            }

            property string defaultImage: "signin.png"
            property string hoverImage: "signinhover.png"
            property string downImage: defaultImage
            property string disabledImage: defaultImage

            //hover code
            onEntered: {
                btnImg.source = hoverImage;
            }

            //hover exit
            onExited: {
                btnImg.source = defaultImage;
            }

            //released code
            onReleased: {
                btnImg.source = defaultImage;
            }

            //pressed code
            onPressed: {
                btnImg.source = downImage;
            }

            onEnabledChanged: {
                if(btnArea.enabled)
                    btnImg.source = defaultImage;
                else
                    btnImg.source = disabledImage;
            }

            Component.onCompleted: {
                if(btnArea.enabled)
                    btnImg.source = defaultImage;
                else
                    btnImg.source = disabledImage;
            }

            Image {
                id: btnImg
                width: 29
                height: 29
                source: defaultImage
                sourceSize.width: width
                sourceSize.height: height
                scale: btnArea.pressed ? 0.97 : 1.0
                smooth: btnArea.pressed
                Component.onCompleted: cppWindow.setItemCursor(btnArea, 13);
            }
        }

        Text {
            id: signinword
            text: "SAVE"
            font.pixelSize: 13
            font.family: electrolize.name
            color: "#ffffff"
            smooth: true
            x: 391
            y: 329.75
            opacity: 1
        }

        Image {
            id: passwordbg
            source: "passwordbg.png"
            x: 354
            y: 268
            opacity: 1

            TextInput {
                id: pwordBox
                width: passwordbg.width - password.width - 24
                x: password.width + 20
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -3
                echoMode: TextInput.Password
                horizontalAlignment: TextInput.AlignHCenter
                font.pixelSize: 14
                font.family: electrolize.name
                color: "white"
                selectionColor: "#339dff"
                KeyNavigation.backtab: unameBox
                KeyNavigation.tab: unameBox
                onAccepted: {
                    if((pwordBox.text.length > 0) && (unameBox.text.length > 0)) {
                        writeLoginCreds();
                        loginDialog.visible = false;
                    }
                }
            }
        }

        Text {
            id: password
            text: "Password"
            font.pixelSize: 14
            font.family: electrolize.name
            color: "#ffffff"
            smooth: true
            x: 370
            y: 275.5
            opacity: 1
        }

        Image {
            id: usernamebg
            source: "passwordbg.png"
            x: 354
            y: 222
            opacity: 1

            TextInput {
                id: unameBox
                width: usernamebg.width - username.width - 24
                x: username.width + 20
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -2
                horizontalAlignment: TextInput.AlignHCenter
                font.pixelSize: 14
                font.family: electrolize.name
                color: "white"
                selectionColor: "#339dff"
                KeyNavigation.backtab: pwordBox
                KeyNavigation.tab: pwordBox
                onAccepted: {
                    if((pwordBox.text.length > 0) && (unameBox.text.length > 0)) {
                        writeLoginCreds();
                        loginDialog.visible = false;
                    }
                }
            }
        }

        Text {
            id: username
            text: "Username"
            font.pixelSize: 14
            font.family: electrolize.name
            color: "#ffffff"
            smooth: true
            x: 370
            y: 230.5
            opacity: 1
        }

        Text {
            id: pleaseword
            text: "Please sign-in using your RSI credentials"
            font.pixelSize: 12
            font.family: electrolize.name
            color: "#ffffff"
            smooth: true
            x: 353
            y: 194
            opacity: 0.50196078431373
        }
        Image {
            id: accessword
            source: "accessword.png"
            x: 352
            y: 167
            opacity: 1
        }
    }

    FontLoader {
        id: electrolize
        source: "Electrolize-Regular.ttf"
    }

    FontLoader {
        id: opensanslight
        source: "OpenSans-Light.ttf"
    }

    FontLoader {
        id: opensans
        source: "OpenSans-Regular.ttf"
    }
}
