import QtQuick 2.15

Image {
    id: piece

    property int pieceX: 0  // Логическая X координата (0-7)
    property int pieceY: 0  // Логическая Y координата (0-7)
    property bool highlighted: false
    property bool isAnimating: xAnimation.running || yAnimation.running
    property bool dragEnabled: false  // Включить/выключить перетаскивание
    property int cellSize: width  // Добавляем явное свойство для размера ячейки

    // Функция для преобразования логических координат в визуальные
    property var logicalToVisualPos: function(x, y) {
        return {
            x: x * cellSize,
            y: (7 - y) * cellSize
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "yellow"
        opacity: piece.highlighted ? 0.3 : 0
        z: -1
    }

    Component.onCompleted: {
        updatePosition();
    }

    function updatePosition() {
        let pos = logicalToVisualPos(pieceX, pieceY);
        x = pos.x;
        y = pos.y;
    }

    onCellSizeChanged: updatePosition()
    onPieceXChanged: updatePosition()
    onPieceYChanged: updatePosition()

    PropertyAnimation {
        id: xAnimation
        target: piece
        property: "x"
        duration: 200
        easing.type: Easing.OutQuad
    }

    PropertyAnimation {
        id: yAnimation
        target: piece
        property: "y"
        duration: 200
        easing.type: Easing.OutQuad
    }

    PropertyAnimation {
        id: bounceAnimation
        target: piece
        property: "scale"
        from: 1.0
        to: 1.15
        duration: 100
        onStopped: bounceEndAnimation.start()
    }

    PropertyAnimation {
        id: bounceEndAnimation
        target: piece
        property: "scale"
        to: 1.0
        duration: 100
    }

    function animateMove(newX, newY) {
        bounceAnimation.start()

        let newPos = logicalToVisualPos(newX, newY)
        xAnimation.to = newPos.x
        yAnimation.to = newPos.y
        xAnimation.start()
        yAnimation.start()

        pieceX = newX
        pieceY = newY
    }

    signal pieceClicked(var piece)
    signal pieceMoved(int fromX, int fromY, int toX, int toY)
    signal dragStarted(var piece)

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        drag.target: dragEnabled ? parent : undefined
        property bool dragging: false

        onPressed: {
            if (dragEnabled) {
                piece.z = 10
                dragging = true
                dragStarted(piece)
            }
        }

        onClicked: {
            if (!dragging) {
                pieceClicked(piece)
            }
            dragging = false
        }

        onReleased: {
            if (dragEnabled && dragging) {
                dragging = false
                let newX = Math.floor((piece.x + piece.width / 2) / cellSize)
                let newY = 7 - Math.floor((piece.y + piece.height / 2) / cellSize) // Преобразование в логические координаты
                newX = Math.max(0, Math.min(7, newX))
                newY = Math.max(0, Math.min(7, newY))

                if (newX !== pieceX || newY !== pieceY) {
                    pieceMoved(pieceX, pieceY, newX, newY)
                } else {
                    updatePosition();
                }

                piece.z = 1
            }
        }
    }
}
