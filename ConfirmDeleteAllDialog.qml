import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Dialog {
    id: confirmDeleteAllDialog
    title: "Удаление всех сохранений"
    modal: true
    width: 350
    height: 170

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
            text: confirmDeleteAllDialog.title
            font.pixelSize: 18
            font.family: "Courier"
            font.bold: true
            color: "white"
        }
    }

    anchors.centerIn: Overlay.overlay
    contentItem: Item {
        anchors.fill: parent

        Text {
            id: warningText
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                bottom: buttonsRow.top
                bottomMargin: 20
                topMargin: 50
            }
            text: "Вы уверены, что хотите удалить\nВСЕ сохранения?\nЭто действие нельзя отменить."
            font.pixelSize: 16
            font.family: "Courier"
            font.bold: true
            color: "#FF6666"
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
        }

        RowLayout {
            id: buttonsRow
            width: parent.width
            spacing: 20
            anchors {
                bottom: parent.bottom
                bottomMargin: 10
                horizontalCenter: parent.horizontalCenter
            }

            Item { Layout.fillWidth: true }

            Rectangle {
                width: 80
                height: 40
                color: confirmYesMouseArea.containsMouse ?
                       (confirmYesMouseArea.pressed ? "#8F4D4D" : "#AF6D6D") : "#9F5D5D"
                radius: 6
                border.color: "#FF8A8A"
                border.width: 2

                Text {
                    anchors.centerIn: parent
                    text: "Да"
                    color: "white"
                    font.pixelSize: 16
                    font.family: "Courier"
                    font.bold: true
                }

                MouseArea {
                    id: confirmYesMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        if (typeof chessEngine.deleteAllGames === "function") {
                            chessEngine.deleteAllGames();
                        } else {
                            var games = chessEngine.getSavedGames();
                            if (games && games.length) {
                                for (var i = 0; i < games.length; i++) {
                                    chessEngine.deleteGame(0);
                                }
                            }
                        }

                        Qt.callLater(function() {
                            if (typeof settingsSavedGamesList !== "undefined") {
                                settingsSavedGamesList.model = chessEngine.getSavedGames();
                            }

                            if (typeof settingsScreen !== "undefined") {
                                settingsScreen.selectedSaveIndex = -1;
                            }

                            confirmDeleteAllDialog.close();
                        });
                    }
                }
            }

            Rectangle {
                width: 80
                height: 40
                color: confirmNoMouseArea.containsMouse ?
                       (confirmNoMouseArea.pressed ? "#4D4D6F" : "#5D5D7D") : "#6D6D8D"
                radius: 6
                border.color: "#8A8AFF"
                border.width: 2

                Text {
                    anchors.centerIn: parent
                    text: "Нет"
                    color: "white"
                    font.pixelSize: 16
                    font.family: "Courier"
                    font.bold: true
                }

                MouseArea {
                    id: confirmNoMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        confirmDeleteAllDialog.close();
                    }
                }
            }

            Item { Layout.fillWidth: true }
        }
    }
}
