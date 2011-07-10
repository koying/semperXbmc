import QtQuick 1.0
import com.nokia.symbian 1.0
import "components" as Cp;

import "js/Utils.js" as Utils

Page {
    id: page
    property int artistId
    property int albumId

    tools:  musicStack.depth > 1 ? pgTools : null

    ToolBarLayout {
        id: pgTools

        ToolButton {
            iconSource: "toolbar-back"
            onClicked: musicStack.pop()
            visible: musicStack.depth > 1
        }

        ToolButton {
            id: tbAdd
            iconSource: "img/add.svg"
            visible: false
            onClicked: $().playlist.addAlbum(page.albumId)
        }

        ToolButton {
            id: tbReplace
            iconSource: "img/switch_windows.svg"
            visible: false
            onClicked: {
                $().playlist.audioClear();
                $().playlist.addAlbum(page.albumId)
            }
        }

        ToolButton {
            visible: false
        }
    }

    GridView {
        id: albumView
        cellWidth: page.width
        cellHeight: 250
        width: parent.width
        height: parent.height
        model: albumModel
        delegate: albumDelegate
        clip:  true
    }

    Component {
        id: albumDelegate

        MusicAlbumItem {
            id: albumItem
            width: page.width;
            height: 200

            onTracksExpanded: {
                tbAdd.visible = true
                tbReplace.visible = true
                page.albumId = id
            }

            onTracksCollapsed: {
                tbAdd.visible = false
                tbReplace.visible = false
            }

        }
    }

    onArtistIdChanged: {
        albumModel.clear();
        if (artistId == -1)
            $().library.loadAllAlbums();
        else
            $().library.loadAlbums(artistId);
    }
}
