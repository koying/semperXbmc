import QtQuick 1.0
import com.nokia.android 1.1
import "components/" as Cp;
import "menus/" as Menus

import "js/Utils.js" as Utils

Page {
    id: page
    property int artistId: -99
    focus: true

    tools:  menuLayout

    Menus.MusicToolbarLayout {
        id: menuLayout
    }

    Keys.onBackPressed: {
        musicStack.pop()
        event.accepted = true
    }

    Menus.MusicViewMenu {
        id: viewMenu
        currentType: "All Albums"
    }

    Menus.MusicStyleMenu {
        id: styleMenu
    }

    ListView {
        id: musicAlbumList
        anchors.fill: parent
        clip: true
        highlightMoveDuration: 300

        model: albumProxyModel
        delegate: albumDelegate

        cacheBuffer: 800
    }

    ScrollDecorator {
        flickableItem: musicAlbumList
    }

    Component {
        id: albumDelegate

        Cp.Delegate {
            title: model.name
            subtitle: model.artist
            image: model.cover != "" ? (globals.cacheThumbnails ? model.coverThumb : model.cover) : "qrc:/defaultImages/album"

            style: globals.styleMusicAlbums
            banner: globals.showBanners
            type: "header"

            subComponentSource: "MusicAlbumDetail.qml"

            Connections {
                target: subComponent
                onLoaded: {
                    subComponent.item.albumId = model.idalbum
                }
            }

            onSelected:  {
                if (style == globals.styleMusicAlbums)
                    style = "full"
                else
                    style = globals.styleMusicAlbums
            }

            onContext: albumMenu.open()

            ContextMenu {
                id: albumMenu
                MenuLayout {
                    MenuItem {
                        text: "Append"
                        onClicked: $().playlist.addAlbum(model.idalbum)
                    }
                    MenuItem {
                        text: "Insert"
                        visible: $().jsonRPCVer > 2
                        onClicked: $().playlist.insertAlbum(model.idalbum)
                    }
                    MenuItem {
                        text: "Replace"
                        onClicked: {
                            $().playlist.audioClear();
                            $().playlist.addAlbum(model.idalbum)
                        }
                    }
                    MenuItem {
                        text: "Download"
                        visible: $().jsonRPCVer > 2
                        onClicked: $().library.downloadAlbum(model.idalbum)
                    }
                }
            }
        }
    }

    Cp.SearchDialog {
        id: searchDlg
        visible: menuLayout.filterEnabled

        onApply: {
            albumProxyModel.filterRole = "name"
            albumProxyModel.filterRegExp = searchDlg.text
        }
        onCancel: {
            albumProxyModel.filterRole = ""
            albumProxyModel.filterRegExp = ""
        }
    }

    onArtistIdChanged: {
        albumModel.clear();
        if (artistId < 0)
            $().library.loadAllAlbums();
        else
            $().library.loadAlbums(artistId);
    }

    function refresh() {
        $().library.loadAllAlbums();
    }

    Component.onCompleted: {
        if (musicStack.depth < 1) {
            $().library.loadAllAlbums();
        }

        globals.initialMusicView = "MusicAlbumView.qml"
    }
}
