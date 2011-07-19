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

//        ToolButton {
//            id: btFilter
//            checkable: true
//            iconSource: "img/filter.svg"
//        }

        ToolButton {
            visible: false
        }
    }

    ListView {
        id: musicAlbumList
        anchors.fill: parent
        clip: true
        highlightMoveDuration: 300

        model: albumModel
        delegate: albumDelegate
    }

    ScrollDecorator {
        id: scrolldecorator
        flickableItem: musicAlbumList
    }

    Component {
        id: albumDelegate

        Cp.Delegate {
            title: model.name
            subtitle: model.artist
            image: model.thumb

            style: "bigHorizontal"
            type: "header"

            subComponentSource: "MusicAlbumDetail.qml"

            Connections {
                target: subComponent
                onLoaded: subComponent.item.albumId = model.idalbum
            }

            onSelected:  {
//                tvshowStack.push(Qt.resolvedUrl("TvEpisodeView.qml"), {seasonId: id})
                if (style == "bigHorizontal")
                    style = "full"
                else
                    style = "bigHorizontal"
            }
        }
    }

//    Cp.SearchDialog {
//        id: searchDlg
//        visible: btFilter.checked

//        onApply: {
//            artistProxyModel.filterRole = "name"
//            artistProxyModel.filterRegExp = searchDlg.text
//        }
//        onCancel: {
//            artistProxyModel.filterRole = ""
//            artistProxyModel.filterRegExp = ""
//        }
//    }

    onArtistIdChanged: {
        albumModel.clear();
        if (artistId == -1)
            $().library.loadAllAlbums();
        else
            $().library.loadAlbums(artistId);
    }
}
