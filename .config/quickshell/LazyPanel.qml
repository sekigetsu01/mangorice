import QtQuick
import Quickshell
import Quickshell.Io

LazyLoader {
    id: root

    property string ipc: ""

    signal opening
    signal loaded

    function toggle() {
        opening();
        if (item)
            item.toggle();
        else
            loading = true;
    }

    onItemChanged: {
        if (item) {
            item.toggle();
            loaded();
        }
    }

    property IpcHandler handler: IpcHandler {
        target: root.ipc
        enabled: root.ipc !== ""
        function toggle(): void {
            root.toggle();
        }
        function isOpen(): bool {
            const w = root.item;
            return !!w && (typeof w.visible === "boolean" ? w.visible : !!w.active);
        }
        function close(): bool {
            if (!isOpen())
                return false;
            root.item.toggle();
            return true;
        }
    }
}
