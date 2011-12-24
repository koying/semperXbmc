import QtQuick 1.0
import com.nokia.symbian 1.0
import com.semperpax.qmlcomponents 1.0

ListItem {
    id: liDownload

    property variant downloadObject

    Item  {
        anchors.fill: liDownload.paddingItem

        ListItemText {
            id: txItemTitle

            mode: liDownload.mode
            role: "Title"
            text: downloadObject.filename
        }

        ProgressBar {
            id: pb1
            anchors { top: txItemTitle.bottom; right: parent.right; left: parent.left }
            minimumValue: 0
            maximumValue: 100
            value: downloadObject.progress
        }
    }

    Connections {
        target: downloadObject
        onProgressChanged: {
            pb1.value = downloadObject.progress
        }
    }
}
