import QtQuick 1.0
import com.nokia.symbian 1.0
import "components" as Cp;

import "js/Utils.js" as Utils

Page {
    id: page

    tools:

    ToolBarLayout {
        id: pgTools

        ToolButton {
            iconSource: "toolbar-back"
            onClicked: musicStack.pop()
            visible: musicStack.depth > 1
        }

        ToolButton {
            id: btFilter
            checkable: true
            iconSource: "img/filter.svg"
        }

        ToolButton {
            iconSource: "toolbar-menu"
            onClicked: pgMenu.open()
        }
    }

    Menu {
        id: pgMenu
        content: MenuLayout {

            MenuItem {
                text:  "View"
                platformSubItemIndicator: true
                onClicked: viewMenu.open()
            }

            MenuItem {
                text:  "Style"
                platformSubItemIndicator: true
                onClicked: styleMenu.open()
            }
            MenuItem {
                text:  "Refresh"
                onClicked: refresh()
            }
        }
    }

    ContextMenu {
        id: viewMenu
        MenuLayout {
            MenuItem {
                text:  "Artists"
                onClicked: {
                    globals.initialMusicView = "MusicArtistView.qml"
                    if (musicStack.depth < 1) {
                        musicStack.replace(Qt.resolvedUrl(globals.initialMusicView))
                    } else {
                        musicStack.clear();
                        musicStack.push(Qt.resolvedUrl(globals.initialMusicView))
                    }
                }
            }
            MenuItem {
                text:  "Recent Albums"
            }
            MenuItem {
                text:  "All Albums"
                onClicked: {
                    albumModel.clear();
                    globals.initialMusicView = "MusicAlbumView.qml"
                    musicStack.replace(Qt.resolvedUrl(globals.initialMusicView), {artistId: -1})
                }
            }
        }
    }

    ContextMenu {
        id: styleMenu
        MenuLayout {
            MenuItem {
                text:  "Small Horizontal"
                onClicked: {
                    globals.styleMusicAlbums = "smallHorizontal"
                }
            }
            MenuItem {
                text:  "Big Horizontal"
                onClicked: {
                    globals.styleMusicAlbums = "bigHorizontal"
                }
            }
            MenuItem {
                text:  "Vertical"
                onClicked: {
                    globals.styleMusicAlbums = "vertical"
                }
            }
        }
    }

    ListView {
        id: musicAlbumList
        anchors.fill: parent
        clip: true
        highlightMoveDuration: 300

        model: albumProxyModel
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
            image: globals.cacheThumbnails ? model.coverThumb : model.cover

            style: globals.styleMusicAlbums
            banner: globals.showBanners
            type: "header"

            subComponentSource: "MusicAlbumDetail.qml"

            Connections {
                target: subComponent
                onLoaded: {
                    subComponent.item.albumId = model.idalbum
                    subComponent.item.albumArtist = model.artist
                    subComponent.item.albumName = model.name
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
        visible: btFilter.checked

        onApply: {
            albumProxyModel.filterRole = "name"
            albumProxyModel.filterRegExp = searchDlg.text
        }
        onCancel: {
            albumProxyModel.filterRole = ""
            albumProxyModel.filterRegExp = ""
        }
    }

    function refresh() {
        $().library.recentAlbums();
    }

    Component.onCompleted: {
        $().library.recentAlbums();
    }
}
