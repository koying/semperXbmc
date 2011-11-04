import QtQuick 1.0
import com.nokia.symbian 1.0
import com.semperpax.qmlcomponents 1.0

ListItem {
    id: liDownload

    property string inputPath
    property string outputPath
    property alias isActive: download.isActive
    property alias isFinished: download.isFinished

    Item  {
        anchors.fill: liDownload.paddingItem

        ListItemText {
            id: txItemTitle

            mode: liDownload.mode
            role: "Title"
            text: download.title
        }

        ProgressBar {
            id: pb1
            minimumValue: 0
            maximumValue: 100
            value: 0
        }

        Download {
            id: download
            inputPath: liDownload.inputPath
            outputPath: liDownload.outputPath

            onFinished: {
            }
            onProgressChanged: {
                pb1.value = download.progress
            }
        }
    }

    function go() {
        download.go();
    }
}
