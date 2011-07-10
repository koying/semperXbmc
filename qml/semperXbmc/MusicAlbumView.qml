import QtQuick 1.0
import com.nokia.symbian 1.0
import "components" as Cp;

import "js/Utils.js" as Utils

Page {
    id: page
    property int artistId

    tools:  musicStack.depth > 1 ? pgTools : null

    ToolBarLayout {
        id: pgTools

        ToolButton {
            iconSource: "toolbar-back"
            onClicked: musicStack.pop()
            visible: musicStack.depth > 1
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
            id: content
            width: page.width;
            height: 200
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
