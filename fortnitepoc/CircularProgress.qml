import QtQuick 1.1
Item {
    id: circularProgress
    width:180
    height:180

    property real minimumValue: 0
    property real maximumValue: 100
    property real adjustedMin: 0
    property real adjustedMax: 100
    property real range: (adjustedMax === adjustedMin) ? 1 : (adjustedMax - adjustedMin)
    property double adjustedValue: 60
    property double value: 30
    property int borderWidth: 30    
    property string containerBackground : ""
    property string progressBackground : ""
    property bool displayLabel : true

    property color circleColor: "transparent" //inner circle
    property color progressColor: "#ff8800" //visible color
    property color backColor: "transparent" //container color

    onValueChanged: {
        if (value < minimumValue)
            adjustedValue = minimumValue;
        else if (value > maximumValue)
            adjustedValue = maximumValue;
        else
            adjustedValue = value;
    }

    onMinimumValueChanged: {
        if (minimumValue > adjustedMax)
            adjustedMin = adjustedMax
        else
            adjustedMin = minimumValue
    }

    onMaximumValueChanged: {
        if (maximumValue < adjustedMin)
            adjustedMax = adjustedMin
        else
            adjustedMax = maximumValue
    }


    Rectangle{
        width: circle.width-(borderWidth)
        height: circle.height-(borderWidth)
        radius: width/2
        x:borderWidth/2
        y:borderWidth/2
        color: circleColor
        border.color: backColor
        border.width: borderWidth
        smooth: true
        opacity: containerBackground != "" ? 0 : 1
    }

    Image {
        width: parent.width
        height: parent.height
        source: containerBackground
        opacity: 1
    }

    Row {
        id: circle
        anchors.fill: parent

        Item {
            width: parent.width/2
            height: parent.height
            transformOrigin: Item.Right
            rotation: ((adjustedValue/range) <= 0.5) ? 180 : (((adjustedValue/range) < 1) ? (adjustedValue/range) * 360 : 360);
//            Behavior on rotation { NumberAnimation { duration: 10 } }
            clip: true
            smooth: true

            Item {
                id: part1
                width: parent.width
                height: parent.height
                clip: true
                smooth: true
                rotation: 180 - (parent.rotation - 180)
//                Behavior on rotation { NumberAnimation { duration: 10 } }
                transformOrigin: Item.Right

                Rectangle{
                    width: circle.width-(borderWidth)
                    height: circle.height-(borderWidth)
                    radius: width/2
                    x: borderWidth/2
                    y: borderWidth/2
                    color: circleColor
                    border.width: borderWidth
                    smooth: true
                    opacity: progressBackground != "" ? 0 : 1
                }

                Image {
                    width: circle.width
                    height: circle.height
                    x: 0
                    y: 0
                    source: progressBackground
                }
            }
        }

        Item {
            width: parent.width/2
            height: parent.height
            rotation: ((adjustedValue/range) >= 0.5) ? 360 : 180 + ((adjustedValue/range) * 360);
//            Behavior on rotation { NumberAnimation { duration: 10 } }
            transformOrigin: Item.Left
            clip: true
            smooth: true

            Item{
                id: part2
                x: 0
                y: 0
                width: parent.width
                height: parent.height
                clip: true
                smooth: true
                rotation: 180 - (parent.rotation - 180)
//                Behavior on rotation { NumberAnimation { duration: 10 } }
                transformOrigin: Item.Left

                Rectangle {
                    width: circle.width-(borderWidth)
                    height: circle.height-(borderWidth)
                    radius: width/2
                    x: -width/2
                    y: borderWidth/2
                    color: circleColor
                    border.color: progressColor
                    border.width: borderWidth
                    smooth: true
                    opacity: progressBackground != "" ? 0 : 1
                }

                Image {
                    width: circle.width
                    height: circle.height
                    x: -width/2
                    y: 0
                    source: progressBackground
                }
            }
        }
    }

    Rectangle {
       anchors.centerIn: parent
       width:  20
       height: 20
       opacity: displayLabel ? 1 :0
       Text {
           anchors.centerIn: parent
           font.bold: true
           text: parseInt((adjustedValue/range)*100) + "%"
       }
   }
}
