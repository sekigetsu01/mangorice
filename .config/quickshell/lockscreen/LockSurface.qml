import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion

// What the lock screen shows: the wallpaper, the time and date, and the password box.
Rectangle {
    id: root
    required property LockContext context

    color: "black"
    readonly property string wallpaperPath: context.look[0] || ""
    readonly property var theme: ({
            clock: context.look[1] || "#4B0082",
            locked: context.look[2] || "#7675C4",
            verticalOffset: isNaN(parseInt(context.look[3])) ? -75 : parseInt(context.look[3])
        })

    Image {
        anchors.fill: parent
        source: root.wallpaperPath ? "file://" + root.wallpaperPath.split("/").map(encodeURIComponent).join("/") : ""
        fillMode: Image.PreserveAspectCrop
    }

    ColumnLayout {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: root.theme.verticalOffset
        spacing: 2

        Item {
            Layout.alignment: Qt.AlignHCenter
            implicitWidth: clockText.implicitWidth
            implicitHeight: clockText.implicitHeight

            Repeater {
                model: [[-2, -2], [2, -2], [-2, 2], [2, 2], [-3, 0], [3, 0], [0, -3], [0, 3]]
                Text {
                    font.pointSize: 75
                    font.weight: Font.Black
                    color: "#000000"
                    x: modelData[0]
                    y: modelData[1]
                    text: clockText.text
                }
            }

            Text {
                id: clockText
                font.pointSize: 75
                font.weight: Font.Black
                color: root.theme.clock
                text: Qt.formatTime(root.context.now, "hh:mm")
            }
        }

        Item {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: -8
            implicitWidth: dateText.implicitWidth
            implicitHeight: dateText.implicitHeight

            Repeater {
                model: [[-1, -1], [1, -1], [-1, 1], [1, 1]]
                Text {
                    font.pointSize: 14
                    font.weight: Font.Bold
                    color: "#000000"
                    x: modelData[0]
                    y: modelData[1]
                    text: dateText.text
                }
            }

            Text {
                id: dateText
                font.pointSize: 14
                font.weight: Font.Bold
                color: root.theme.locked
                text: Qt.formatDate(root.context.now, "dddd, d MMMM yyyy")
            }
        }

        Rectangle {
            id: passwordBox
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 6
            implicitWidth: 340
            implicitHeight: 44
            color: "#262525"
            radius: 4
            border.width: (root.context.showSuccess || root.context.showFailure) ? 1.5 : 0
            border.color: root.context.showSuccess ? "#00c44f" : root.context.showFailure ? "#e53935" : "transparent"

            property real shake: 1
            transform: Translate {
                x: 10 * Math.sin(passwordBox.shake * Math.PI * 6) * (1 - passwordBox.shake)
            }
            NumberAnimation {
                id: shakeAnim
                target: passwordBox
                property: "shake"
                from: 0
                to: 1
                duration: 300
            }

            TextField {
                id: field
                anchors {
                    fill: parent
                    leftMargin: 12
                    rightMargin: 12
                }
                background: null
                color: "#ffffff"
                placeholderText: root.context.unlockInProgress ? "verifying…" : "password"
                placeholderTextColor: Qt.tint("#262525", "#80ffffff")
                font.pointSize: 13

                focus: true
                enabled: !root.context.unlockInProgress
                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhSensitiveData

                onTextChanged: root.context.currentText = text
                onAccepted: root.context.tryUnlock()

                Connections {
                    target: root.context
                    function onCurrentTextChanged() {
                        if (field.text !== root.context.currentText)
                            field.text = root.context.currentText;
                    }
                    function onShowFailureChanged() {
                        if (root.context.showFailure)
                            shakeAnim.start();
                    }
                }
            }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 2
            font.pointSize: 13
            font.weight: Font.Bold
            color: root.theme.locked
            text: root.context.formatLocked(root.context.secondsLocked)
        }
    }
}
