import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: gameScreen

    property alias saveButton: saveButton2

    signal menuRequested()
    signal saveRequested()

    // Функции для преобразования координат
    function logicalToVisualPos(x, y) {
        return {
            x: x * chessBoard.cellSize,
            y: (7 - y) * chessBoard.cellSize
        }
    }

    function visualToLogicalPos(x, y) {
        return {
            x: Math.floor(x / chessBoard.cellSize),
            y: 7 - Math.floor(y / chessBoard.cellSize)
        }
    }

    function clearAllSelections() {
        chessBoard.clearSelections()
    }

    function animateCapture(x, y) {
        chessBoard.animateCapture(x, y)
    }

    Image {
        anchors.fill: parent
        source: "qrc:/resources/images/fon2.png"
        fillMode: Image.PreserveAspectCrop
    }

    Text {
        id: statusText
        text: chessEngine.status
        font.pixelSize: 20
        font.family: "Courier"
        font.bold: true
        color: "white"
        anchors {
            top: parent.top
            topMargin: 10
            horizontalCenter: parent.horizontalCenter
        }
    }

    // Шахматная доска
    ChessBoard {
        id: chessBoard
        width: Math.min(parent.width, parent.height - 50) - (2 * 20)
        height: width
        anchors {
            centerIn: parent
            verticalCenterOffset: -10
        }

        onPieceMoved: function(fromX, fromY, toX, toY) {

            let animationTimer = Qt.createQmlObject('import QtQuick 2.0; Timer {interval: 250; repeat: false; running: true;}',
                                                   gameScreen, "AnimationTimer");

            animationTimer.triggered.connect(function() {
                chessEngine.processMove(fromX, fromY, toX, toY);
                animationTimer.destroy();
            });
        }
    }

    // Нижние кнопки управления
    Row {
        spacing: 30
        anchors {
            bottom: parent.bottom
            bottomMargin: 4
            horizontalCenter: parent.horizontalCenter
        }

        StyledButton {
            id: saveButton2
            width: 150
            height: 45
            buttonText: "Сохранить"
            isSmall: true
            enabled: chessEngine.getSavedGames().length < 10
            shadowColor: "#224422"
            onClicked: {
                saveRequested()
            }
        }

        StyledButton {
            id: newGameButton
            width: 150
            height: 45
            buttonText: "Новая игра"
            isSmall: true
            onClicked: {
                chessEngine.startNewGame()
                clearAllSelections()
            }
        }

        StyledButton {
            id: undoButton
            width: 150
            height: 45
            buttonText: "Отменить ход"
            isSmall: true
            enabled: chessEngine.canUndo
            onClicked: {
                chessEngine.undoLastMove()
                if (chessEngine.vsComputer) {
                    chessEngine.undoLastMove()
                }
            }
        }

        StyledButton {
            buttonText: "Меню"
            isSmall: true
            width: 150
            height: 45
            onClicked: {
                menuRequested()
            }
        }
    }

    Connections {
        target: chessEngine

        function onPiecesChanged() {
            clearAllSelections()
            chessBoard.updatePieces()
        }

        function onStatusChanged() {
            clearAllSelections()
        }
    }
}
