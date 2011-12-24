import QtQuick 1.0
import com.nokia.symbian 1.0
import "components" as Cp;

Item {
    id: container

    property int count: downloadsModel.count
    property int activeCount: 0

    ToolBar {
        id: buttons
        anchors { top: parent.top; left: parent.left; right: parent.right; }

        tools: Row {
            anchors.centerIn: parent
            spacing: platformStyle.paddingMedium

            ToolButton {
                id: tbClearFinished
                text: "Clear Finished"
                onClicked: clearFinished()
            }

            ToolButton {
                id: tbClearAll
                text: "Clear All"
                onClicked: clearAll()
            }

        }
    }

    ListView {
        id: downloadsView
        anchors { top: buttons.bottom; bottom: parent.bottom; left: parent.left; right: parent.right }
        //            anchors.margins: 10
        clip: true

        model: downloadsModel
        delegate: downloadsDelegate
    }

    Component {
        id: downloadsDelegate

        Cp.DownloadComponent {
            downloadObject: model.downloadObject
        }
    }

    onCountChanged: checkQueue()

    function checkQueue() {
        var i=0;
        for (; i<downloadsModel.count; ++i) {
            var o = downloadsModel.get(i).downloadObject
            if (o.isActive)
                break
            else if (!o.isFinished) {
                o.go()
                console.debug("activated: " + i);
                break;
            }
        }
    }

    function clearFinished() {
        var i=0;
        for (; i<downloadsModel.count; ++i) {
            var o = downloadsModel.get(i).downloadObject
            if (o.isFinished) {
                downloadsModel.remove(i);
                i--;
            }
        }
    }

    function clearAll() {
        downloadsModel.clear()
    }
}

