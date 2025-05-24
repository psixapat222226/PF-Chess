import QtQuick 2.15
import QtQuick.Controls 2.15


Item {
    id: buttonContainer
    width: 300
    height: 50

    property string buttonText: "Button"
    property bool isSmall: false
    property int fontSize: isSmall ? 14 : 16
    property bool enabled: true
    property color shadowColor: "#333333"
    property int shadowSize: 4
    property string objectName: ""

    signal clicked()

    Rectangle {
        id: shadow
        width: parent.width
        height: shadowSize
        color: shadowColor
        opacity: 0.5
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
    }

    Rectangle {
        id: styleButton
        width: parent.width
        height: parent.height - shadowSize
        color: "#828282"
        border.color: "#5A5A5A"
        border.width: 2
        anchors.top: parent.top

        Rectangle {
            width: parent.width - 4
            height: parent.height - 4
            x: 2
            y: 2
            color: mouseArea.pressed && buttonContainer.enabled ? "#5A5A5A" : "#6D6D6D"
            opacity: buttonContainer.enabled ? 1.0 : 0.5

            Text {
                anchors.centerIn: parent
                text: buttonContainer.buttonText
                color: "white"
                font.pixelSize: buttonContainer.fontSize
                font.family: "Courier"
                font.bold: true
            }
        }
    }

    states: State {
        name: "pressed"
        when: mouseArea.pressed && buttonContainer.enabled
        PropertyChanges {
            target: styleButton
            y: shadowSize / 2
        }
        PropertyChanges {
            target: shadow
            height: shadowSize / 2
        }
    }

    transitions: Transition {
        PropertyAnimation {
            properties: "y, height"
            duration: 50
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            if (buttonContainer.enabled) {
                buttonContainer.clicked()
            }
        }
    }
}

