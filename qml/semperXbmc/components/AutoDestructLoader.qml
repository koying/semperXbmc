import QtQuick 1.0

Item {
    property alias source: ldr.source

    Loader {
        id: ldr
        anchors.fill:  parent

        onLoaded: {
            item.state = "show"
        }
    }
    Connections {
        target: ldr.item
        onHidden: {
            ldr.source = ""
        }
    }
}
