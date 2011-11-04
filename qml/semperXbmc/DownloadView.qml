import QtQuick 1.0
import "components" as Cp;

Rectangle {
    id: container

    property int count: downloadsModel.count
    property int activeCount: 0
    property alias model: downloadsModel

    ListModel {
        id: downloadsModel
    }

    ListView {
        id: downloadsView
        anchors.fill: parent
        //            anchors.margins: 10
        clip: true

        model: downloadsModel
        delegate: downloadsDelegate
    }

    Component {
        id: downloadsDelegate

        Cp.DownloadComponent {
            inputPath: model.inputPath
            outputPath: model.outputPath

            onIsActiveChanged: {
                if (isActive)
                    container.activeCount = container.activeCount + 1;
                else
                    container.activeCount = container.activeCount - 1;
            }
        }
    }

    function checkQueue() {
        if (container.activeCount == 0) {
            for (var i=0; i<downloadsModel.count(); ++i) {
                if (!downloadsModel.get(i).isActive && !downloadsModel.get(i).isFinished) {
                }
            }
        }
    }
}

