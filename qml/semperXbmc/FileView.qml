import QtQuick 1.0
import com.nokia.android 1.1
import com.semperpax.qmlcomponents 1.0
import "components/" as Cp;
import "menus/" as Menus

import "js/Utils.js" as Utils

Page {
    id: page
    property string curDir

    focus: true

    tools: ToolBarLayout {
        Menus.MainTools {}
    }

    Keys.onBackPressed: {
        fileStack.pop()
        event.accepted = true
    }

    ListView {
        id: fileList
        anchors.fill: parent
        clip: true
        highlightMoveDuration: 300

        model: fileProxyModel
        delegate: fileDelegate

        cacheBuffer: 800
    }

    ScrollDecorator {
        flickableItem: fileList
    }

    Component {
        id: fileDelegate

        Cp.Delegate {
            title: model.name
            image: model.filetype == "directory" ? "img/folder.png" : (model.poster != "" ? (globals.cacheThumbnails ? model.posterThumb : model.poster) : "")
            watched: model.playcount > 0

            style: globals.styleFiles

            onSelected:  {
                if (model.filetype == "directory")
                    fileStack.push(Qt.resolvedUrl("FileView.qml"), {curDir: model.path})
                else {
                    $().videoplayer.playFile(model.path);
                    mainTabGroup.currentTab = remoteTab
                }
            }
        }
    }

    SortFilterModel {
        id: fileProxyModel

        sourceModel: fileModel
        sortRole: "sortname"
        boolFilterRole: globals.showViewed ? "" : "playcount"
    }

    VariantModel {
        id: fileModel
        fields: [ "name", "sortname", "path", "filetype", "playcount", "poster", "posterThumb" ]
        key: "path"
        thumbDir: ctxFatFile
    }

    onCurDirChanged: {
        if (curDir != "/")
            $().library.loadFiles(fileProxyModel, curDir);
        else
            $().library.loadSources(fileProxyModel);
    }
}
