import QtQuick 1.0

Item {
    property url sourceUrl

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

    onSourceUrlChanged: {
        if (sourceUrl && sourceUrl != "") {
            ldr.source = sourceUrl;
        } else {
            ldr.item.state = ""
        }
    }
}
