pragma Singleton
import Quickshell

// Shared settings: the terminal panels open things in (kitty), and the bar's height.
Singleton {
    readonly property string terminal: "kitty"
    property int barH: 22
}
