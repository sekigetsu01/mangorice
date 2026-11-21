import QtQuick
import Quickshell

QtObject {
    required property string command
    required property string text
    property int keybind: 0
    property string icon: ""
    property list<string> args: []

    function exec() {
        Quickshell.execDetached(["sh", "-c", command, "sh", ...args]);
    }
}
