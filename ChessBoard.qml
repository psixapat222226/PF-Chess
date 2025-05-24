import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: board
    color: "#FFFFFF"

    property int cellSize: width / 8
    property var selectedPiece: null
    property var moveIndicators: moveIndicatorsItem

    function logicalToVisualPos(x, y) {
        return {
            x: x * cellSize,
            y: (7 - y) * cellSize
        }
    }

    function visualToLogicalPos(x, y) {
        return {
            x: Math.floor(x / cellSize),
            y: 7 - Math.floor(y / cellSize)
        }
    }

    signal pieceMoved(int fromX, int fromY, int toX, int toY)

    function clearSelections() {
        moveIndicatorsItem.visible = false
        if (selectedPiece !== null) {
            selectedPiece.highlighted = false
        }
        selectedPiece = null
    }

    function updatePieces() {
        piecesRepeater.model = chessEngine.getPieces()
    }

    function animateCapture(x, y) {
        for (let i = 0; i < piecesRepeater.count; i++) {
            let piece = piecesRepeater.itemAt(i);
            if (piece && piece.pieceX === x && piece.pieceY === y) {
                let opacityAnimation = Qt.createQmlObject('
                    import QtQuick 2.0;
                    PropertyAnimation {
                        target: capturedPiece
                        property: "opacity"
                        from: 1.0
                        to: 0.0
                        duration: 200
                    }', piece, "OpacityAnimation");

                opacityAnimation.capturedPiece = piece;
                opacityAnimation.start();

                let scaleAnimation = Qt.createQmlObject('
                    import QtQuick 2.0;
                    PropertyAnimation {
                        target: capturedPiece
                        properties: "scale"
                        from: 1.0
                        to: 1.3
                        duration: 200
                    }', piece, "ScaleAnimation");

                scaleAnimation.capturedPiece = piece;
                scaleAnimation.start();
                break;
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        z: -1
        onClicked: {
            clearSelections()
        }
    }


    Grid {
        anchors.fill: parent
        rows: 8
        columns: 8

        Repeater {
            model: 64

            Rectangle {
                width: cellSize
                height: cellSize
                color: {
                    let row = Math.floor(index / 8)
                    let col = index % 8
                    return (row + col) % 2 === 0 ? "#F1D9B5" : "#B98863"
                }
            }
        }
    }

    Repeater {
        id: piecesRepeater
        model: chessEngine.getPieces()

        ChessPiece {
            width: cellSize
            height: cellSize
            source: resourceManager.getTexturePath(modelData.type)
            pieceX: modelData.x
            pieceY: modelData.y
            cellSize: board.cellSize
            logicalToVisualPos: board.logicalToVisualPos

            onPieceClicked: function(clickedPiece) {
                if (selectedPiece === clickedPiece) {
                    clearSelections()
                    return
                }

                clearSelections()
                let legalMoves = chessEngine.getLegalMovesForPiece(clickedPiece.pieceX, clickedPiece.pieceY)

                if (legalMoves.length > 0) {
                    moveIndicatorsItem.fromX = clickedPiece.pieceX
                    moveIndicatorsItem.fromY = clickedPiece.pieceY
                    moveIndicatorsItem.legalMoves = legalMoves
                    moveIndicatorsItem.visible = true

                    clickedPiece.highlighted = true
                    selectedPiece = clickedPiece
                }
            }

            onPieceMoved: function(fromX, fromY, toX, toY) {
                board.pieceMoved(fromX, fromY, toX, toY)
            }
        }
    }

    Item {
        id: moveIndicatorsItem
        anchors.fill: parent
        visible: false

        property var legalMoves: []
        property int fromX: -1
        property int fromY: -1

        Repeater {
            id: movesRepeater
            model: moveIndicatorsItem.legalMoves

            Rectangle {
                property var visualPos: board.logicalToVisualPos(modelData.x, modelData.y)

                x: visualPos.x
                y: visualPos.y
                width: cellSize
                height: cellSize
                color: "transparent"
                border.width: 3
                border.color: "#32CD32"
                radius: cellSize / 2
                opacity: 0.7

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        let fromX = moveIndicatorsItem.fromX;
                        let fromY = moveIndicatorsItem.fromY;
                        let toX = modelData.x;
                        let toY = modelData.y;

                        moveIndicatorsItem.visible = false;
                        let movingPiece = selectedPiece;
                        if (movingPiece) {
                            movingPiece.highlighted = false;
                            movingPiece.animateMove(toX, toY);
                            board.pieceMoved(fromX, fromY, toX, toY)
                        }
                    }
                }
            }
        }
    }
}
