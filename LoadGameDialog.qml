import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Dialog {
    id: loadGameDialog
    title: "Загрузить сохранённую партию"
    modal: true
    width: 400
    height: 500
    property int selectedGameIndex: -1

    background: Rectangle {
        color: "#3D3D3D"
        border.color: "#5A5A5A"
        border.width: 2
        radius: 6
    }

    header: Rectangle {
        color: "#553322"
        height: 45
        radius: 4

        Text {
            anchors.centerIn: parent
            text: loadGameDialog.title
            font.pixelSize: 20
            font.family: "Courier"
            font.bold: true
            color: "#FFFFFF"
        }
    }

    anchors.centerIn: Overlay.overlay

    onOpened: {
        savedGamesList.model = null;
        savedGamesList.model = chessEngine.getSavedGames();
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 10
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#262626"
            radius: 5
            border.color: "#444444"
            border.width: 1

            ListView {
                id: savedGamesList
                anchors.fill: parent
                anchors.margins: 5
                model: chessEngine.getSavedGames()
                clip: true

                ScrollBar.vertical: ScrollBar {
                    active: true
                }

                delegate: Rectangle {
                    width: savedGamesList.width - 10
                    height: 80
                    color: loadGameDialog.selectedGameIndex === index ? "#555555" : "#3D3D3D"
                    radius: 5
                    border.color: loadGameDialog.selectedGameIndex === index ? "#886644" : "#555555"
                    border.width: loadGameDialog.selectedGameIndex === index ? 2 : 1

                    property var gameData: modelData

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            loadGameDialog.selectedGameIndex = index
                        }
                    }
                    Column {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 5

                        Text {
                            text: parent.parent.gameData && parent.parent.gameData.name ?
                                  parent.parent.gameData.name : "Без названия"
                            font.pixelSize: 16
                            font.family: "Courier"
                            font.bold: true
                            color: "white"
                        }

                        Text {
                            text: {
                                var gameData = parent.parent.gameData;
                                if (!gameData) return "Режим: Неизвестно";

                                var modeText = "Режим: ";
                                modeText += gameData.gameMode === "vsComputer" ? "Против ИИ" : "Два игрока";

                                if (gameData.gameMode === "vsComputer") {
                                    var diffText = "";
                                    if (gameData.difficulty === 1) diffText = "Легкий";
                                    else if (gameData.difficulty === 2) diffText = "Средний";
                                    else if (gameData.difficulty === 3) diffText = "Сложный";
                                    else diffText = gameData.difficulty;

                                    modeText += " | Сложность: " + diffText;
                                }

                                return modeText;
                            }
                            font.pixelSize: 14
                            font.family: "Courier"
                            color: "white"
                        }

                        Text {
                            text: "Дата: " + (parent.parent.gameData && parent.parent.gameData.date ?
                                            parent.parent.gameData.date : "Неизвестно")
                            font.pixelSize: 14
                            font.family: "Courier"
                            color: "white"
                        }
                    }
                }

                Text {
                    anchors.centerIn: parent
                    visible: savedGamesList.count === 0
                    text: "Нет сохранённых игр"
                    color: "#FFFFFF"
                    font.pixelSize: 16
                    font.family: "Courier"
                }
            }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "Выберите сохраненную партию"
            font.pixelSize: 16
            font.family: "Courier"
            color: "white"
            visible: loadGameDialog.selectedGameIndex === -1 && savedGamesList.count > 0
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Rectangle {
                id: loadButton
                Layout.fillWidth: true
                height: 45
                enabled: loadGameDialog.selectedGameIndex >= 0
                color: enabled ? (loadMouseArea.containsMouse ?
                        (loadMouseArea.pressed ? "#4D8F4D" : "#6DAF6D") : "#5D9F5D") : "#444444"
                radius: 6
                border.color: enabled ? "#8AFF8A" : "#555555"
                border.width: 2

                Text {
                    anchors.centerIn: parent
                    text: "Загрузить"
                    color: "white"
                    font.pixelSize: 16
                    font.family: "Courier"
                    font.bold: true
                }

                MouseArea {
                    id: loadMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        if (parent.enabled && chessEngine.loadGame(loadGameDialog.selectedGameIndex)) {
                            loadGameDialog.close()
                            inMenu = false
                            inSettings = false
                        }
                    }
                }
            }

            Rectangle {
                id: deleteButton
                Layout.fillWidth: true
                height: 45
                enabled: loadGameDialog.selectedGameIndex >= 0
                color: enabled ? (deleteMouseArea.containsMouse ?
                        (deleteMouseArea.pressed ? "#8F4D4D" : "#AF6D6D") : "#9F5D5D") : "#444444"
                radius: 6
                border.color: enabled ? "#FF8A8A" : "#555555"
                border.width: 2

                Text {
                    anchors.centerIn: parent
                    text: "Удалить"
                    color: "white"
                    font.pixelSize: 16
                    font.family: "Courier"
                    font.bold: true
                }

                MouseArea {
                    id: deleteMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        if (parent.enabled && chessEngine.deleteGame(loadGameDialog.selectedGameIndex)) {
                            loadGameDialog.selectedGameIndex = -1
                            savedGamesList.model = null;
                            savedGamesList.model = chessEngine.getSavedGames();

                            if (inSettings && typeof settingsSavedGamesList !== "undefined") {
                                settingsSavedGamesList.model = null;
                                settingsSavedGamesList.model = chessEngine.getSavedGames();
                            }
                        }
                    }
                }
            }

            Rectangle {
                id: cancelLoadButton
                Layout.fillWidth: true
                height: 45
                color: cancelLoadMouseArea.containsMouse ?
                       (cancelLoadMouseArea.pressed ? "#4D4D6F" : "#5D5D7D") : "#6D6D8D"
                radius: 6
                border.color: "#8A8AFF"
                border.width: 2

                Text {
                    anchors.centerIn: parent
                    text: "Отмена"
                    color: "white"
                    font.pixelSize: 16
                    font.family: "Courier"
                    font.bold: true
                }

                MouseArea {
                    id: cancelLoadMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        loadGameDialog.selectedGameIndex = -1
                        loadGameDialog.close()
                    }
                }
            }
        }
    }
}
