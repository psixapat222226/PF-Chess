import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Dialog {
    id: promotionDialog
    title: "Превращение пешки"
    modal: true
    closePolicy: Dialog.NoAutoClose
    width: 280
    height: 280

    background: Rectangle {
        color: "#828282"
        border.color: "#5A5A5A"
        border.width: 2
    }

    header: Rectangle {
        color: "#6D6D6D"
        height: 40

        Text {
            anchors.centerIn: parent
            text: promotionDialog.title
            font.pixelSize: 18
            font.family: "Courier"
            font.bold: true
            color: "white"
        }
    }

    property int fromX: -1
    property int fromY: -1
    property int toX: -1
    property int toY: -1

    anchors.centerIn: Overlay.overlay
    Grid {
        anchors.centerIn: parent
        rows: 2
        columns: 2
        spacing: 20

        Rectangle {
            width: 80
            height: 80
            color: "#6D6D6D"
            border.color: "#5A5A5A"
            border.width: 1

            Image {
                anchors.fill: parent
                anchors.margins: 5
                source: {
                    let side = promotionDialog.toY === 7 ? "white" : "black"
                    return resourceManager.getTexturePath(side + "Queen")
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    chessEngine.promotePawn(
                        promotionDialog.fromX,
                        promotionDialog.fromY,
                        promotionDialog.toX,
                        promotionDialog.toY,
                        "queen"
                    )
                    promotionDialog.close()
                }
            }
        }

        Rectangle {
            width: 80
            height: 80
            color: "#6D6D6D"
            border.color: "#5A5A5A"
            border.width: 1

            Image {
                anchors.fill: parent
                anchors.margins: 5
                source: {
                    let side = promotionDialog.toY === 7 ? "white" : "black"
                    return resourceManager.getTexturePath(side + "Rook")
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    chessEngine.promotePawn(
                        promotionDialog.fromX,
                        promotionDialog.fromY,
                        promotionDialog.toX,
                        promotionDialog.toY,
                        "rook"
                    )
                    promotionDialog.close()
                }
            }
        }

        Rectangle {
            width: 80
            height: 80
            color: "#6D6D6D"
            border.color: "#5A5A5A"
            border.width: 1

            Image {
                anchors.fill: parent
                anchors.margins: 5
                source: {
                    let side = promotionDialog.toY === 7 ? "white" : "black"
                    return resourceManager.getTexturePath(side + "Bishop")
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    chessEngine.promotePawn(
                        promotionDialog.fromX,
                        promotionDialog.fromY,
                        promotionDialog.toX,
                        promotionDialog.toY,
                        "bishop"
                    )
                    promotionDialog.close()
                }
            }
        }

        Rectangle {
            width: 80
            height: 80
            color: "#6D6D6D"
            border.color: "#5A5A5A"
            border.width: 1

            Image {
                anchors.fill: parent
                anchors.margins: 5
                source: {
                    let side = promotionDialog.toY === 7 ? "white" : "black"
                    return resourceManager.getTexturePath(side + "Knight")
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    chessEngine.promotePawn(
                        promotionDialog.fromX,
                        promotionDialog.fromY,
                        promotionDialog.toX,
                        promotionDialog.toY,
                        "knight"
                    )
                    promotionDialog.close()
                }
            }
        }
    }
}
