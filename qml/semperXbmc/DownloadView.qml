import QtQuick 1.0
import "components" as Cp;

Item {
    id: container

    property int count: downloadsModel.count
    property int activeCount: 0

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
            activate: model.activate

            onIsActiveChanged: {
                if (isActive)
                    container.activeCount = container.activeCount + 1;
                else
                    container.activeCount = container.activeCount - 1;
                checkQueue();
            }

            ListView.onAdd: { checkQueue(); }
            ListView.onRemove: { checkQueue(); }
        }
    }

    function checkQueue() {
        if (container.activeCount == 0) {
            var i=0;
            for (; i<downloadsModel.count; ++i) {
                if (!downloadsModel.get(i).isActive && !downloadsModel.get(i).isFinished) {
                    downloadsModel.get(i).activate = true;
                    console.debug("activated: " + i);
                    break;
                }
            }
            if (i == downloadsModel.count)
                console.debug("nothing activated: " + i);
        }
    }
}

