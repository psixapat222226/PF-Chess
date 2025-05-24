import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: settingsScreen

    property int selectedSaveIndex: -1
    property alias loadButtonInSettings: loadButtonInSettings

    signal doneClicked()
    signal loadSave(int index)
    signal deleteSave(int index)
    signal deleteAllSaves()

    function updateSavedGamesList(saves) {
        settingsSavedGamesList.model = null;
        Qt.callLater(function() {
            settingsSavedGamesList.model = saves;
        });

        loadButtonInSettings.enabled = saves.length > 0 && selectedSaveIndex >= 0;
        deleteButtonInSettings.enabled = saves.length > 0 && selectedSaveIndex >= 0;
        deleteAllButtonInSettings.enabled = saves.length > 0;
    }

    onSelectedSaveIndexChanged: {
        if (typeof loadButtonInSettings !== "undefined") {
            loadButtonInSettings.enabled = chessEngine.getSavedGames().length > 0 && selectedSaveIndex >= 0;
        }

        if (typeof deleteButtonInSettings !== "undefined") {
            deleteButtonInSettings.enabled = chessEngine.getSavedGames().length > 0 && selectedSaveIndex >= 0;
        }
    }

    onVisibleChanged: {
        if (visible) {
            var currentSaves = chessEngine.getSavedGames();
            updateSavedGamesList(currentSaves);
            selectedSaveIndex = -1;
        }
    }

    Image {
        anchors.fill: parent
        source: "qrc:/resources/images/fon2.png"
        fillMode: Image.PreserveAspectCrop
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20
        width: 500

        Text {
            text: "НАСТРОЙКИ"
            font.pixelSize: 32
            font.family: "Courier"
            font.bold: true
            color: "white"
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 60
        }

        Rectangle {
            Layout.fillWidth: true
            height: 200
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#35281E" }
                GradientStop { position: 1.0; color: "#241812" }
            }
            radius: 10
            border.width: 2
            border.color: "#886644"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 15

                Text {
                    text: "Сложность"
                    font.pixelSize: 22
                    font.family: "Courier"
                    font.bold: true
                    color: "#E0C9A6"
                    Layout.alignment: Qt.AlignHCenter
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 15

                    Rectangle {
                        id: easyButton
                        Layout.fillWidth: true
                        Layout.preferredHeight: 85
                        radius: 8
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: chessEngine.difficulty === 1 ? "#7DE07D" : "#9A9A9A" }
                            GradientStop { position: 1.0; color: chessEngine.difficulty === 1 ? "#4DB74D" : "#6D6D6D" }
                        }
                        border.color: chessEngine.difficulty === 1 ? "#50FF50" : "#777777"
                        border.width: chessEngine.difficulty === 1 ? 3 : 2

                        Column {
                            anchors.centerIn: parent
                            spacing: 5

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "♙"
                                font.pixelSize: 26
                                font.family: "Arial"
                                color: "white"
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "Легкий"
                                font.pixelSize: 16
                                font.family: "Courier"
                                font.bold: true
                                color: "white"
                            }
                        }

                        MouseArea {
                            id: easyMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: chessEngine.difficulty = 1

                            onEntered: {
                                if (chessEngine.difficulty !== 1) {
                                    parent.scale = 1.05;
                                }
                            }
                            onExited: {
                                if (chessEngine.difficulty !== 1) {
                                    parent.scale = 1.0;
                                }
                            }
                            onPressed: {
                                parent.scale = 0.95;
                            }
                            onReleased: {
                                parent.scale = containsMouse ? 1.05 : 1.0;
                            }
                        }

                        Behavior on scale {
                            NumberAnimation {
                                duration: 100
                                easing.type: Easing.OutQuad
                            }
                        }
                    }

                    Rectangle {
                        id: mediumButton
                        Layout.fillWidth: true
                        Layout.preferredHeight: 85
                        radius: 8
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: chessEngine.difficulty === 2 ? "#7D9BE0" : "#9A9A9A" }
                            GradientStop { position: 1.0; color: chessEngine.difficulty === 2 ? "#4D77B7" : "#6D6D6D" }
                        }
                        border.color: chessEngine.difficulty === 2 ? "#5080FF" : "#777777"
                        border.width: chessEngine.difficulty === 2 ? 3 : 2

                        Column {
                            anchors.centerIn: parent
                            spacing: 5

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "♘"
                                font.pixelSize: 26
                                font.family: "Arial"
                                color: "white"
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "Средний"
                                font.pixelSize: 16
                                font.family: "Courier"
                                font.bold: true
                                color: "white"
                            }
                        }

                        MouseArea {
                            id: mediumMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: chessEngine.difficulty = 2

                            onEntered: {
                                if (chessEngine.difficulty !== 2) {
                                    parent.scale = 1.05;
                                }
                            }
                            onExited: {
                                if (chessEngine.difficulty !== 2) {
                                    parent.scale = 1.0;
                                }
                            }
                            onPressed: {
                                parent.scale = 0.95;
                            }
                            onReleased: {
                                parent.scale = containsMouse ? 1.05 : 1.0;
                            }
                        }

                        Behavior on scale {
                            NumberAnimation {
                                duration: 100
                                easing.type: Easing.OutQuad
                            }
                        }
                    }

                    Rectangle {
                        id: hardButton
                        Layout.fillWidth: true
                        Layout.preferredHeight: 85
                        radius: 8
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: chessEngine.difficulty === 3 ? "#E07D7D" : "#9A9A9A" }
                            GradientStop { position: 1.0; color: chessEngine.difficulty === 3 ? "#B74D4D" : "#6D6D6D" }
                        }
                        border.color: chessEngine.difficulty === 3 ? "#FF5050" : "#777777"
                        border.width: chessEngine.difficulty === 3 ? 3 : 2

                        Column {
                            anchors.centerIn: parent
                            spacing: 5

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "♕"
                                font.pixelSize: 26
                                font.family: "Arial"
                                color: "white"
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "Сложный"
                                font.pixelSize: 16
                                font.family: "Courier"
                                font.bold: true
                                color: "white"
                            }
                        }

                        MouseArea {
                            id: hardMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: chessEngine.difficulty = 3

                            onEntered: {
                                if (chessEngine.difficulty !== 3) {
                                    parent.scale = 1.05;
                                }
                            }
                            onExited: {
                                if (chessEngine.difficulty !== 3) {
                                    parent.scale = 1.0;
                                }
                            }
                            onPressed: {
                                parent.scale = 0.95;
                            }
                            onReleased: {
                                parent.scale = containsMouse ? 1.05 : 1.0;
                            }
                        }

                        Behavior on scale {
                            NumberAnimation {
                                duration: 100
                                easing.type: Easing.OutQuad
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            id: savesSection
            Layout.fillWidth: true
            height: 300
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#35281E" }
                GradientStop { position: 1.0; color: "#241812" }
            }
            radius: 10
            border.color: "#886644"
            border.width: 2

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 15

                Text {
                    text: "Сохранения"
                    font.pixelSize: 22
                    font.family: "Courier"
                    font.bold: true
                    color: "#E0C9A6"
                    Layout.alignment: Qt.AlignHCenter
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#262626"
                    radius: 5

                    ListView {
                        id: settingsSavedGamesList
                        anchors.fill: parent
                        anchors.margins: 5
                        model: chessEngine.getSavedGames()
                        clip: true

                        onModelChanged: {
                            if (count === 0) {
                                settingsScreen.selectedSaveIndex = -1;
                                loadButtonInSettings.enabled = false;
                                deleteButtonInSettings.enabled = false;
                            }
                        }

                        ScrollBar.vertical: ScrollBar {
                            active: true
                            policy: ScrollBar.AsNeeded
                        }

                        delegate: Rectangle {
                            width: settingsSavedGamesList.width
                            height: 60
                            color: settingsScreen.selectedSaveIndex === index ? "#555555" : "#3D3D3D"
                            radius: 4
                            border.color: settingsScreen.selectedSaveIndex === index ? "#886644" : "#555555"
                            border.width: settingsScreen.selectedSaveIndex === index ? 2 : 1
                            property var gameData: modelData

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    settingsScreen.selectedSaveIndex = index
                                }
                            }

                            Column {
                                anchors.fill: parent
                                anchors.margins: 8
                                spacing: 2

                                Text {
                                    text: parent.parent.gameData && parent.parent.gameData.name ?
                                          parent.parent.gameData.name : "Без названия"
                                    font.pixelSize: 14
                                    font.family: "Courier"
                                    font.bold: true
                                    color: "white"
                                }

                                Text {
                                    text: {
                                        var gameData = parent.parent.gameData;
                                        if (!gameData) return "Режим: Неизвестно";

                                        var modeText = gameData.gameMode === "vsComputer" ?
                                                      "Против ИИ" : "Два игрока";

                                        if (gameData.gameMode === "vsComputer") {
                                            var diffText = "";
                                            if (gameData.difficulty === 1) diffText = "Легкий";
                                            else if (gameData.difficulty === 2) diffText = "Средний";
                                            else if (gameData.difficulty === 3) diffText = "Сложный";
                                            else diffText = gameData.difficulty;

                                            modeText += " | " + diffText;
                                        }

                                        return modeText;
                                    }
                                    font.pixelSize: 12
                                    font.family: "Courier"
                                    color: "#DDDDDD"
                                }

                                Text {
                                    text: "Дата: " + (parent.parent.gameData && parent.parent.gameData.date ?
                                                    parent.parent.gameData.date : "Неизвестно")
                                    font.pixelSize: 12
                                    font.family: "Courier"
                                    color: "#DDDDDD"
                                }
                            }
                        }

                        Text {
                            anchors.centerIn: parent
                            visible: settingsSavedGamesList.count === 0
                            text: "Нет сохранённых игр"
                            color: "#FFFFFF"
                            font.pixelSize: 16
                            font.family: "Courier"
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Rectangle {
                        id: loadButtonInSettings
                        objectName: "loadButtonInSettings"
                        Layout.fillWidth: true
                        height: 40
                        enabled: chessEngine.getSavedGames().length > 0 && settingsScreen.selectedSaveIndex >= 0
                        color: enabled ? (loadSettingsMouseArea.containsMouse ?
                                (loadSettingsMouseArea.pressed ? "#4D8F4D" : "#6DAF6D") : "#5D9F5D") : "#444444"
                        radius: 5
                        border.color: enabled ? "#8AFF8A" : "#555555"
                        border.width: 2

                        Text {
                            anchors.centerIn: parent
                            text: "Загрузить"
                            color: "white"
                            font.pixelSize: 14
                            font.family: "Courier"
                            font.bold: true
                        }

                        MouseArea {
                            id: loadSettingsMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                if (parent.enabled) {
                                    var index = settingsScreen.selectedSaveIndex;
                                    if (index >= 0) {
                                        loadSave(index);
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        id: deleteButtonInSettings
                        Layout.fillWidth: true
                        height: 40
                        enabled: chessEngine.getSavedGames().length > 0 && settingsScreen.selectedSaveIndex >= 0
                        color: enabled ? (deleteSettingsMouseArea.containsMouse ?
                                (deleteSettingsMouseArea.pressed ? "#8F4D4D" : "#AF6D6D") : "#9F5D5D") : "#444444"
                        radius: 5
                        border.color: enabled ? "#FF8A8A" : "#555555"
                        border.width: 2

                        Text {
                            anchors.centerIn: parent
                            text: "Удалить"
                            color: "white"
                            font.pixelSize: 14
                            font.family: "Courier"
                            font.bold: true
                        }

                        MouseArea {
                            id: deleteSettingsMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                if (parent.enabled) {
                                    var index = settingsScreen.selectedSaveIndex;
                                    if (index >= 0 && chessEngine.deleteGame(index)) {
                                        settingsScreen.selectedSaveIndex = -1;
                                        settingsSavedGamesList.model = null;
                                        settingsSavedGamesList.model = chessEngine.getSavedGames();
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    id: deleteAllButtonInSettings
                    objectName: "deleteAllSavesButton"
                    Layout.fillWidth: true
                    height: 40
                    enabled: chessEngine.getSavedGames().length > 0
                    color: enabled ? (deleteAllMouseArea.containsMouse ?
                            (deleteAllMouseArea.pressed ? "#8F4D4D" : "#D74D4D") : "#C74D4D") : "#444444"
                    radius: 5
                    border.color: enabled ? "#FF8A8A" : "#555555"
                    border.width: 2

                    Text {
                        anchors.centerIn: parent
                        text: "Удалить все сохранения"
                        color: "white"
                        font.pixelSize: 14
                        font.family: "Courier"
                        font.bold: true
                    }

                    MouseArea {
                        id: deleteAllMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            if (parent.enabled) {
                                confirmDeleteAllDialog.open();
                            }
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            Layout.bottomMargin: 60

            StyledButton {
                buttonText: "Готово"
                Layout.fillWidth: true
                onClicked: {
                    doneClicked()
                }
            }
        }
    }
}
