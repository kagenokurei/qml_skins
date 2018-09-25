import Qt 4.7
Item {
    width:860
    height:510
    Image {
        id: background
        source: "background.png"
        x: 0
        y: 0
        opacity: 1
    }
    Image {
        id: playnowdisabled
        source: "playnowdisabled.png"
        x: 524
        y: 379
        opacity: 0.30196078431373
    }
    Image {
        id: playnow
        source: "playnow.png"
        x: 524
        y: 379
        opacity: 1
    }
    Image {
        id: playnowhover
        source: "playnowhover.png"
        x: 524
        y: 379
        opacity: 1
    }
    Image {
        id: minimize
        source: "minimize.png"
        x: 792
        y: 14
        opacity: 1
    }
    Image {
        id: close
        source: "close.png"
        x: 819
        y: 14
        opacity: 1
    }
    Image {
        id: minimizehover
        source: "minimizehover.png"
        x: 792
        y: 14
        opacity: 1
    }
    Image {
        id: closehover
        source: "closehover.png"
        x: 819
        y: 14
        opacity: 1
    }
    Image {
        id: streambar
        source: "streambar.png"
        x: 210
        y: 308
        opacity: 1
    }
    Image {
        id: preinstallbar
        source: "preinstallbar.png"
        x: 210
        y: 308
        opacity: 1
    }
    Image {
        id: progressholder
        source: "progressholder.png"
        x: 202
        y: 300
        opacity: 1
    }
    Image {
        id: playdisabled
        source: "playdisabled.png"
        x: 622
        y: 304
        opacity: 0.30196078431373
    }
    Image {
        id: play
        source: "play.png"
        x: 622
        y: 304
        opacity: 1
    }
    Image {
        id: playhover
        source: "playhover.png"
        x: 622
        y: 304
        opacity: 1
    }
    Image {
        id: pausedisabled
        source: "pausedisabled.png"
        x: 622
        y: 304
        opacity: 0.30196078431373
    }
    Image {
        id: pause
        source: "pause.png"
        x: 622
        y: 304
        opacity: 1
    }
    Image {
        id: pausehover
        source: "pausehover.png"
        x: 622
        y: 304
        opacity: 1
    }
    Image {
        id: preinstallsplit
        source: "preinstallsplit.png"
        x: 325
        y: 323
        opacity: 1
    }
    Text {
        id: logs
        text: "logs here logs here logs here logs here logs here logs here logs here logs here
logs here logs here logs here logs here logs here logs here logs here logs here
logs here logs here logs here logs here logs here logs here logs here logs here
logs here logs here logs here logs here logs here logs here logs here logs here
logs here logs here logs here logs here logs here logs here logs here logs here"
        font.pixelSize: 11
        font.family: "OpenSans-Light"
        color: "#b5b5b5"
        smooth: true
        x: 28
        y: 371
        opacity: 1
    }
    Text {
        id: preinstalllabel
        text: "Pre-Install @"
        font.pixelSize: 10
        font.family: "OpenSans-Light"
        color: "#ffffff"
        smooth: true
        x: 211
        y: 288.5
        opacity: 0.30196078431373
    }
    Text {
        id: preinstall
        text: "10 %"
        font.pixelSize: 13
        font.family: "OpenSans-Light"
        color: "#ffffff"
        smooth: true
        x: 279
        y: 288.75
        opacity: 1
    }
    Text {
        id: speedlabel
        text: "Speed @"
        font.pixelSize: 10
        font.family: "OpenSans-Light"
        color: "#ffffff"
        smooth: true
        x: 211
        y: 330.5
        opacity: 0.30196078431373
    }
    Text {
        id: speed
        text: "500 Kb/s"
        font.pixelSize: 13
        font.family: "OpenSans-Light"
        color: "#ffffff"
        smooth: true
        x: 279
        y: 330.75
        opacity: 1
    }
    Text {
        id: totallabel
        text: "Total Size"
        font.pixelSize: 10
        font.family: "OpenSans-Light"
        color: "#ffffff"
        smooth: true
        x: 468
        y: 289.5
        opacity: 0.30196078431373
    }
    Text {
        id: total
        text: "13,419.87 MB"
        font.pixelSize: 13
        font.family: "OpenSans-Light"
        color: "#ffffff"
        smooth: true
        x: 537
        y: 288.75
        opacity: 1
    }
    Text {
        id: downloadlabel
        text: "Download @"
        font.pixelSize: 10
        font.family: "OpenSans-Light"
        color: "#ffffff"
        smooth: true
        x: 495
        y: 330.5
        opacity: 0.30196078431373
    }
    Text {
        id: download
        text: "2,300 MB"
        font.pixelSize: 13
        font.family: "OpenSans-Light"
        color: "#ffffff"
        smooth: true
        x: 562
        y: 330.75
        opacity: 1
    }
}
