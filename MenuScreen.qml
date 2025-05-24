import QtQuick 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: menuScreen

    signal gameStarted(string gameMode)
    signal settingsRequested()
    signal infoRequested()
    signal quitRequested()

    Image {
        anchors.fill: parent
        source: "qrc:/resources/images/fon.png"
        fillMode: Image.PreserveAspectCrop
    }

    ColumnLayout {
        anchors {
            bottom: parent.bottom
            bottomMargin: 100
            horizontalCenter: parent.horizontalCenter
        }
        spacing: 20
        width: 300

        StyledButton {
            Layout.fillWidth: true
            buttonText: "Одиночная игра"
            onClicked: gameStarted("vsComputer")
        }

        StyledButton {
            Layout.fillWidth: true
            buttonText: "Многопользовательский режим"
            onClicked: gameStarted("twoPlayers")
        }

        StyledButton {
            Layout.fillWidth: true
            buttonText: "Настройки"
            onClicked: settingsRequested()
        }

        StyledButton {
            buttonText: "Выход из игры"
            Layout.fillWidth: true
            Layout.topMargin: 20
            onClicked: quitRequested()
        }
    }

    Rectangle {
        id: infoButton
        width: 40
        height: 40
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 20
        radius: 20
        color: infoMouseArea.containsMouse ? "#775544" : "#664433"
        border.color: "#886644"
        border.width: 2

        Text {
            anchors.centerIn: parent
            text: "i"
            color: "white"
            font.pixelSize: 24
            font.family: "Courier"
            font.bold: true
        }

        MouseArea {
            id: infoMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: infoRequested()
        }
    }
}
