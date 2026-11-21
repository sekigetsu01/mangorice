import QtQuick
import Quickshell
import Quickshell.Wayland
import "./lockscreen"

Scope {
    id: lockscreen

    function lock() {
        _checkLost();
        ctx.lock();
        _checkLost();
    }
    function _checkLost() {
        if (ctx.locked && !sessionLock.locked)
            ctx.lockLost();
    }

    LockContext {
        id: ctx
    }

    WlSessionLock {
        id: sessionLock
        locked: ctx.locked
        onSecureChanged: if (!sessionLock.secure) Qt.callLater(lockscreen._checkLost)
        onLockedChanged: Qt.callLater(lockscreen._checkLost)

        WlSessionLockSurface {
            LockSurface {
                anchors.fill: parent
                context: ctx
            }
        }
    }
}
