import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Dialog {
    id: saveGameDialog
    title: "Сохранить игру"
    modal: true
    width: 400
    height: 300

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
            text: saveGameDialog.title
            font.pixelSize: 20
            font.family: "Courier"
            font.bold: true
            color: "#FFFFFF"
        }
    }

    anchors.centerIn: Overlay.overlay
    property int availableSlots: Math.max(0, 10 - chessEngine.getSavedGames().length)
    property bool canSave: gameNameInput.text.trim().length > 0 && availableSlots > 0

    onOpened: {
        availableSlots = Math.max(0, 10 - chessEngine.getSavedGames().length);
        saveButton.enabled = gameNameInput.text.trim().length > 0 && availableSlots > 0;
    }

    function resetNameInput() {
        gameNameInput.text = "";
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        Rectangle {
            Layout.fillWidth: true
            height: 40
            color: "#664433"
            radius: 5

            Text {
                anchors.centerIn: parent
                text: "Введите название сохранения:"
                font.pixelSize: 16
                font.family: "Courier"
                font.bold: true
                color: "#FFFFFF"
            }
        }

        TextField {
            id: gameNameInput
            Layout.fillWidth: true
            height: 45
            placeholderText: "Название партии"
            placeholderTextColor: "#BBBBBB"

            background: Rectangle {
                color: "#262626"
                radius: 5
                border.color: "#886644"
                border.width: 2
            }

            color: "#FFFFFF"
            selectByMouse: true
            font.pixelSize: 16
            font.family: "Courier"
            leftPadding: 10

            onTextChanged: {
                saveButton.enabled = text.trim().length > 0 && saveGameDialog.availableSlots > 0;
            }
        }

        Text {
            id: slotsInfoText
            text: "Максимум 10 сохранений. Доступно слотов: " + saveGameDialog.availableSlots
            font.pixelSize: 14
            font.family: "Courier"
            font.bold: true
            color: saveGameDialog.availableSlots > 0 ? "#FFDD99" : "#FF6666"
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            visible: saveGameDialog.availableSlots <= 0
            text: "Достигнут лимит сохранений! Удалите старые записи."
            font.pixelSize: 14
            font.family: "Courier"
            font.bold: true
            color: "#FF6666"
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }

        Item { Layout.fillHeight: true }

        RowLayout {
            Layout.fillWidth: true
            spacing: 20

            Rectangle {
                id: saveButton
                Layout.fillWidth: true
                height: 45
                enabled: gameNameInput.text.trim().length > 0 && saveGameDialog.availableSlots > 0
                color: enabled ? (saveMouseArea.containsMouse ?
                       (saveMouseArea.pressed ? "#4D8F4D" : "#6DAF6D") : "#5D9F5D") : "#444444"
                radius: 6
                border.color: enabled ? "#8AFF8A" : "#555555"
                border.width: 2

                Text {
                    anchors.centerIn: parent
                    text: "Сохранить"
                    color: "white"
                    font.pixelSize: 16
                    font.family: "Courier"
                    font.bold: true
                }

                MouseArea {
                    id: saveMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        if (parent.enabled) {
                            if (chessEngine.saveGame(gameNameInput.text.trim())) {
                                saveGameDialog.availableSlots = Math.max(0, 10 - chessEngine.getSavedGames().length);
                                var updatedSaves = chessEngine.getSavedGames();
                                if (typeof settingsSavedGamesList !== "undefined") {
                                    settingsSavedGamesList.model = null;
                                    settingsSavedGamesList.model = updatedSaves;
                                }
                                var loadButtonsInSettings = findAllLoadButtons();
                                for (var i = 0; i < loadButtonsInSettings.length; i++) {
                                    if (loadButtonsInSettings[i]) {
                                        loadButtonsInSettings[i].enabled = updatedSaves.length > 0;
                                    }
                                }
                                saveGameDialog.close();
                            }
                        }
                    }
                }
            }

            Rectangle {
                id: cancelSaveButton
                Layout.fillWidth: true
                height: 45
                color: cancelSaveMouseArea.containsMouse ?
                       (cancelSaveMouseArea.pressed ? "#8F4D4D" : "#AF6D6D") : "#9F5D5D"
                radius: 6
                border.color: "#FF8A8A"
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
                    id: cancelSaveMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        saveGameDialog.close()
                    }
                }
            }
        }
    }
}

