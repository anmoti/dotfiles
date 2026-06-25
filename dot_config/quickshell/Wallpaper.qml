pragma Singleton
import Quickshell
import QtQuick

Singleton {
    id: root

    property var files: ["01.jpeg", "02.png", "03.jpeg", "04.png"]
    property int index: 0

    Timer {
        interval: 1000 * 60
        running: true
        repeat: true
        onTriggered: root.index = (root.index + 1) % root.files.length
    }
}
