import QtQuick 1.0
import com.nokia.symbian 1.1
import com.semperpax.qmlcomponents 1.0
import "components/" as Cp;
import "menus/" as Menus

import "js/Utils.js" as Utils

Page {
    id: page
    property string curDir

    focus: true

    tools:  layout
    ToolBarLayout {
        id: layout

        ToolButton {
            iconSource: "toolbar-back"
            onClicked: fileStack.pop()
            visible: fileStack.depth > 1
        }

        ToolButton {
            Menus.MainTools {
                id: mainTools
            }

            iconSource: "toolbar-menu"
            onClicked: mainTools.menu.open()
        }
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

    function playfile(path) {
        var batch = "[";
        var o = { jsonrpc: "2.0", method: "Player.Stop", params: { playerid:1 }};
        batch += JSON.stringify(o)
        o = { jsonrpc: "2.0", method: "Playlist.Clear", params: { playlistid:$().playlist.videoPlId }};
        batch += "," + JSON.stringify(o)

        o = { jsonrpc: "2.0", method: "Playlist.Add", params: { playlistid: $().playlist.videoPlId, item: { file: path } }};
        batch += "," + JSON.stringify(o)

        o = { jsonrpc: "2.0", method: "Player.Open", params: { item: { playlistid: $().playlist.videoPlId } }};
        batch += "," + JSON.stringify(o)

        batch += "]"

        var doc = new globals.getJsonXMLHttpRequest();
        doc.send(batch);

        main.state = "playlist"
        playlistTab.showVideo()
        mainTabGroup.currentTab = playlistTab
    }

    ContextMenu {
        id: contextMenu
        property int index

        MenuLayout {
            MenuItem {
                text: "Play file"
                onClicked: {
                    var item = fileProxyModel.properties(contextMenu.index)
                    playFile(item.path)
                }
            }
            MenuItem {
                text: "Append file to queue"
                onClicked: {
                    var item = fileProxyModel.properties(contextMenu.index)

                    var batch = "[";
                    var o = { jsonrpc: "2.0", method: "Playlist.Add", params: { playlistid: $().playlist.videoPlId, item: { file: item.path } }};
                    batch += JSON.stringify(o)
                    batch += "]"

                    var doc = new globals.getJsonXMLHttpRequest();
                    doc.send(batch);
                }
            }
            MenuItem {
                text: "Insert into queue"
                onClicked: {
                    var item = fileProxyModel.properties(contextMenu.index)

                    var batch = "[";
                    var o = { jsonrpc: "2.0", method: "Playlist.Insert", params: { playlistid: $().playlist.videoPlId, item: { file: item.path }, position: 0 }};
                    batch += JSON.stringify(o)
                    batch += "]"

                    var doc = new globals.getJsonXMLHttpRequest();
                    doc.send(batch);
                }
            }
        }
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
                    playfile(model.path)
                }
            }

            onContext: {
                contextMenu.index = index
                contextMenu.open()
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
