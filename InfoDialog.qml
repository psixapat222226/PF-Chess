import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Dialog {
    id: infoDialog
    title: "Инструкция"
    modal: true
    width: Math.min(parent.width * 0.8, 600)
    height: Math.min(parent.height * 0.8, 700)
    anchors.centerIn: Overlay.overlay

    background: Rectangle {
        color: "#664433"
        border.color: "#886644"
        border.width: 2
    }

    header: Rectangle {
        color: "#775544"
        height: 50

        Text {
            text: "ИНСТРУКЦИЯ"
            font.pixelSize: 24
            font.family: "Courier"
            font.bold: true
            color: "#FFFFFF"
            anchors.centerIn: parent
        }
    }

    contentItem: ScrollView {
        clip: true

        Column {
            width: infoDialog.width - 40
            spacing: 20
            padding: 20

            Text {
                width: parent.width
                text: "Шахматы - Руководство по игре"
                font.pixelSize: 20
                font.family: "Courier"
                font.bold: true
                color: "#FFFFFF"
                wrapMode: Text.WordWrap
            }

            Text {
                width: parent.width
                text: "1. Главное меню"
                font.pixelSize: 18
                font.family: "Courier"
                font.bold: true
                color: "#FFFFFF"
                wrapMode: Text.WordWrap
            }

            Text {
                width: parent.width
                text: "• 'Одиночная игра' - игра против компьютера с выбранным уровнем сложности\n• 'Многопользовательский режим' - игра на одном устройстве, где 2 игрока ходят по очереди\n• 'Настройки' - изменение уровня сложности игры против компьютера и управление сохранениями\n• 'Выход из игры' - завершение работы приложения\n• Кнопка 'i' в правом верхнем углу - вызов данной инструкции"
                font.pixelSize: 16
                font.family: "Courier"
                color: "#EEEEEE"
                wrapMode: Text.WordWrap
            }

            Text {
                width: parent.width
                text: "2. Игровой процесс"
                font.pixelSize: 18
                font.family: "Courier"
                font.bold: true
                color: "#FFFFFF"
                wrapMode: Text.WordWrap
            }

            Text {
                width: parent.width
                text: "• Щелкните по своей фигуре, чтобы выбрать её\n• Зеленые индикаторы покажут возможные ходы для выбранной фигуры\n• Щелкните по зеленому индикатору, чтобы сделать ход\n• Для отмены выбора фигуры щелкните по ней повторно или по любой пустой клетке\n• Текущий статус игры (чей ход) отображается в верхней части экрана\n• В режиме против компьютера, он автоматически делает ответный ход после вашего"
                font.pixelSize: 16
                font.family: "Courier"
                color: "#EEEEEE"
                wrapMode: Text.WordWrap
            }

            Text {
                width: parent.width
                text: "3. Кнопки игрового интерфейса"
                font.pixelSize: 18
                font.family: "Courier"
                font.bold: true
                color: "#FFFFFF"
                wrapMode: Text.WordWrap
            }

            Text {
                width: parent.width
                text: "• 'Сохранить' - создает сохранение текущей партии (максимум 10 сохранений)\n• 'Новая игра' - начинает новую партию с текущими настройками\n• 'Отменить ход' - отменяет последний сделанный ход (в режиме против компьютера отменяются оба хода - ваш и компьютера)\n• 'Меню' - возврат в главное меню (текущая партия не будет автоматически сохранена)"
                font.pixelSize: 16
                font.family: "Courier"
                color: "#EEEEEE"
                wrapMode: Text.WordWrap
            }

            Text {
                width: parent.width
                text: "4. Настройки"
                font.pixelSize: 18
                font.family: "Courier"
                font.bold: true
                color: "#FFFFFF"
                wrapMode: Text.WordWrap
            }

            Text {
                width: parent.width
                text: "• Выбор сложности компьютера:\n  - 'Легкий' (♙) - подходит для начинающих игроков\n  - 'Средний' (♘) - сбалансированный уровень сложности\n  - 'Сложный' (♕) - серьезный вызов даже для опытных игроков\n• Раздел 'Сохранения' позволяет управлять сохраненными партиями:\n  - Выберите сохранение из списка, затем используйте кнопки 'Загрузить' или 'Удалить'\n  - Кнопка 'Удалить все сохранения' позволяет очистить весь список (требует подтверждения)\n• Кнопка 'Готово' закрывает настройки и возвращает в главное меню"
                font.pixelSize: 16
                font.family: "Courier"
                color: "#EEEEEE"
                wrapMode: Text.WordWrap
            }

            Text {
                width: parent.width
                text: "5. Сохранение и загрузка партий"
                font.pixelSize: 18
                font.family: "Courier"
                font.bold: true
                color: "#FFFFFF"
                wrapMode: Text.WordWrap
            }

            Text {
                width: parent.width
                text: "• При нажатии на кнопку 'Сохранить':\n  - Введите название для сохранения (обязательно)\n  - Нажмите кнопку 'Сохранить' или 'Отмена'\n  - Обратите внимание на счетчик доступных слотов (максимум 10 сохранений)\n• В настройках для работы с сохранениями:\n  - Выберите сохранение из списка (отображается название, режим игры, сложность и дата)\n  - Используйте кнопки 'Загрузить' или 'Удалить' для соответствующих действий"
                font.pixelSize: 16
                font.family: "Courier"
                color: "#EEEEEE"
                wrapMode: Text.WordWrap
            }

            Text {
                width: parent.width
                text: "6. Особые ходы шахматной игры"
                font.pixelSize: 18
                font.family: "Courier"
                font.bold: true
                color: "#FFFFFF"
                wrapMode: Text.WordWrap
            }

            Text {
                width: parent.width
                text: "• Превращение пешки:\n  - При достижении пешкой противоположного края доски появится диалоговое окно\n  - Выберите фигуру, в которую хотите превратить пешку (ферзь, ладья, слон или конь)\n• Рокировка:\n  - Выберите короля, затем нажмите на клетку, куда он должен переместиться при рокировке (на две клетки влево или вправо)\n  - Ладья автоматически переместится на соответствующую позицию\n• Взятие на проходе:\n  - Если пешка соперника сделала ход на две клетки вперед, проходя мимо вашей пешки\n  - Ваша пешка может взять её 'на проходе', перемещаясь по диагонали за пешкой соперника"
                font.pixelSize: 16
                font.family: "Courier"
                color: "#EEEEEE"
                wrapMode: Text.WordWrap
            }

            Text {
                width: parent.width
                text: "7. Завершение игры"
                font.pixelSize: 18
                font.family: "Courier"
                font.bold: true
                color: "#FFFFFF"
                wrapMode: Text.WordWrap
            }

            Text {
                width: parent.width
                text: "• Мат - король находится под шахом и нет ходов, чтобы его избежать (победа атакующей стороны)\n• Пат - король не под шахом, но нет легальных ходов (ничья)\n• Ничья по правилу 50 ходов - 50 ходов подряд без взятия фигур и без хода пешками\n• Недостаточный материал для мата - на доске недостаточно фигур для объявления мата\n• Троекратное повторение позиции - одна и та же позиция повторяется три раза\n• При завершении игры появится диалоговое окно с результатом"
                font.pixelSize: 16
                font.family: "Courier"
                color: "#EEEEEE"
                wrapMode: Text.WordWrap
            }
        }
    }

    footer: Rectangle {
        color: "#664433"
        height: 60

        Rectangle {
            id: closeInfoButton
            anchors.centerIn: parent
            width: 120
            height: 40
            color: closeInfoMouseArea.containsMouse ? "#886655" : "#775544"
            radius: 5
            border.color: "#886644"
            border.width: 2

            Text {
                anchors.centerIn: parent
                text: "Закрыть"
                color: "white"
                font.pixelSize: 16
                font.family: "Courier"
            }

            MouseArea {
                id: closeInfoMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    infoDialog.close()
                }
            }
        }
    }
}

