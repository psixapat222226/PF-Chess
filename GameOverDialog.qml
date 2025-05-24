import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: gameOverDialog
    anchors.fill: parent
    visible: false
    z: 1000

    property string resultText: ""
    function show(result) {
        resultText = result
        visible = true
        gameOverOverlay.opacity = 0.7
        gameOverContainer.scale = 1.0
        gameOverContainer.opacity = 1.0
    }

    function hide() {
        gameOverOverlay.opacity = 0
        gameOverContainer.scale = 0.5
        gameOverContainer.opacity = 0
        gameOverHideTimer.start()
    }

    Rectangle {
        id: gameOverOverlay
        anchors.fill: parent
        color: "#000000"
        opacity: 0

        Behavior on opacity {
            NumberAnimation { duration: 300 }
        }
    }

    Rectangle {
        id: gameOverContainer
        width: Math.min(parent.width * 0.8, 500)
        height: gameOverContent.height + 80
        anchors.centerIn: parent
        radius: 10
        scale: 0.5
        opacity: 0

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#35281E" }
            GradientStop { position: 1.0; color: "#241812" }
        }

        border {
            width: 3
            color: "#886644"
        }

        Behavior on scale {
            NumberAnimation { duration: 300; easing.type: Easing.OutBack }
        }
        Behavior on opacity {
            NumberAnimation { duration: 300 }
        }

        Image {
            source: "qrc:/resources/images/chessmen/white/king.png"
            width: 60
            height: 60
            opacity: 0.15
            anchors {
                right: parent.right
                bottom: parent.bottom
                margins: 10
            }
        }

        Image {
            source: "qrc:/resources/images/chessmen/black/knight.png"
            width: 60
            height: 60
            opacity: 0.15
            anchors {
                left: parent.left
                top: parent.top
                margins: 10
            }
        }

        Column {
            id: gameOverContent
            width: parent.width - 40
            anchors.centerIn: parent
            spacing: 20

            Text {
                width: parent.width
                text: "ПАРТИЯ ЗАВЕРШЕНА"
                horizontalAlignment: Text.AlignHCenter
                font {
                    pixelSize: 28
                    family: "Courier"
                    bold: true
                }
                color: "#E0C9A6"
            }

            Rectangle {
                width: parent.width * 0.8
                height: 2
                color: "#886644"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                width: parent.width
                text: gameOverDialog.resultText
                horizontalAlignment: Text.AlignHCenter
                font {
                    pixelSize: 36
                    family: "Courier"
                    bold: true
                }
                color: {
                    if (gameOverDialog.resultText.includes("Белые")) return "#FFFFFF";
                    if (gameOverDialog.resultText.includes("Чёрные")) return "#000000";
                    return "#E0C9A6";
                }
                style: Text.Outline
                styleColor: "#886644"
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 15

                Rectangle {
                    width: 150
                    height: 50
                    radius: 5
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: newGameArea.pressed ? "#4D8F4D" : "#6DAF6D" }
                        GradientStop { position: 1.0; color: newGameArea.pressed ? "#3D7F3D" : "#5D9F5D" }
                    }
                    border.color: "#8AFF8A"
                    border.width: 2

                    Text {
                        anchors.centerIn: parent
                        text: "Новая игра"
                        color: "white"
                        font {
                            pixelSize: 16
                            family: "Courier"
                            bold: true
                        }
                    }

                    MouseArea {
                        id: newGameArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            hideGameOverDialog()
                            chessEngine.startNewGame()
                        }
                    }
                }

                Rectangle {
                    width: 150
                    height: 50
                    radius: 5
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: mainMenuArea.pressed ? "#8F4D4D" : "#AF6D6D" }
                        GradientStop { position: 1.0; color: mainMenuArea.pressed ? "#7F3D3D" : "#9F5D5D" }
                    }
                    border.color: "#FF8A8A"
                    border.width: 2

                    Text {
                        anchors.centerIn: parent
                        text: "В меню"
                        color: "white"
                        font {
                            pixelSize: 16
                            family: "Courier"
                            bold: true
                        }
                    }

                    MouseArea {
                        id: mainMenuArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            hideGameOverDialog()
                            inMenu = true
                        }
                    }
                }
            }
        }
    }

    Timer {
        id: gameOverHideTimer
        interval: 300
        onTriggered: {
            if (gameOverOverlay.opacity === 0) {
                gameOverDialog.visible = false
            }
        }
    }
}

