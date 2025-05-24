import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Window {
    id: root
    width: 800
    height: 650
    visible: true
    title: "Шахматный Движок"

    property bool inMenu: true
    property bool inSettings: false


    function findAllLoadButtons() {
        var buttons = [];
        if (typeof settingsScreen.loadButtonInSettings !== "undefined") {
            buttons.push(settingsScreen.loadButtonInSettings);
        }
        return buttons;
    }

    function showGameOverDialog(result) {
        gameOverDialog.show(result);
    }

    function hideGameOverDialog() {
        gameOverDialog.hide();
    }

    MenuScreen {
        id: menuScreen
        anchors.fill: parent
        visible: inMenu && !inSettings

        onGameStarted: function(gameMode) {
            chessEngine.setGameMode(gameMode)
            chessEngine.startNewGame()
            inMenu = false
        }

        onSettingsRequested: {
            inSettings = true
        }

        onInfoRequested: {
            infoDialog.open()
        }

        onQuitRequested: {
            Qt.quit()
        }
    }

    SettingsScreen {
        id: settingsScreen
        anchors.fill: parent
        visible: inSettings

        onDoneClicked: {
            inSettings = false
        }

        onLoadSave: function(index) {
            if (chessEngine.loadGame(index)) {
                inSettings = false
                inMenu = false
            }
        }
    }

    GameScreen {
        id: gameScreen
        anchors.fill: parent
        visible: !inMenu && !inSettings

        onMenuRequested: {
            inMenu = true
        }

        onSaveRequested: {
            saveGameDialog.resetNameInput()
            saveGameDialog.open()
        }
    }

    ConfirmDeleteAllDialog {
        id: confirmDeleteAllDialog
    }

    InfoDialog {
        id: infoDialog
    }

    PromotionDialog {
        id: promotionDialog
    }

    SaveGameDialog {
        id: saveGameDialog
    }

    LoadGameDialog {
        id: loadGameDialog
    }

    GameOverDialog {
        id: gameOverDialog
    }

    Connections {
        target: chessEngine

        function onGameEnded(result) {
            showGameOverDialog(result)
        }

        function onPawnPromotion(fromX, fromY, toX, toY) {
            promotionDialog.fromX = fromX
            promotionDialog.fromY = fromY
            promotionDialog.toX = toX
            promotionDialog.toY = toY
            promotionDialog.open()
        }

        function onSavedGamesChanged() {
            var updatedSaves = chessEngine.getSavedGames();

            // Обновление для экрана настроек
            if (inSettings) {
                settingsScreen.updateSavedGamesList(updatedSaves);
            }

            // Обновление для GameScreen
            gameScreen.saveButton.enabled = updatedSaves.length < 10;

            // Обновление для диалога загрузки
            if (typeof loadGameDialog !== "undefined" && loadGameDialog.visible) {
                loadGameDialog.updateSavedGamesList(updatedSaves);
            }
        }
    }
}
