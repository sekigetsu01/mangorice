import QtQuick
import Quickshell
import Quickshell.Io

Scope {
    id: root

    required property var panel

    Component.onCompleted: CalStore.rev

    LazyLoader {
        active: !!(root.panel.item && root.panel.item.visible) && Quickshell.screens.length > 0

        CalendarWidget {
            screen: Quickshell.screens[0]
        }
    }

    IpcHandler {
        target: "calendar"
        function toggle(): void {
            root.panel.toggle();
        }
        function changed(): void {
            CalStore.changed();
        }
    }
}
