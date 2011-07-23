import QtQuick 1.0
import com.nokia.symbian 1.0
import "components" as Cp;

import "js/Utils.js" as Utils

Page {
    id: page

    tools:  ToolBarLayout {

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
        }
    }

    ContextMenu {
        id: viewMenu
        MenuLayout {
            MenuItem {
                text:  "Artists"
            }
            MenuItem {
                text:  "Albums"
                onClicked: {
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
                    globals.styleMusicArtists = "smallHorizontal"
                }
            }
            MenuItem {
                text:  "Big Horizontal"
                onClicked: {
                    globals.styleMusicArtists = "bigHorizontal"
                }
            }
            MenuItem {
                text:  "Vertical"
                onClicked: {
                    globals.styleMusicArtists = "vertical"
                }
            }
        }
    }

    ListView {
        id: musicArtistList
        anchors.fill: parent
        clip: true
        highlightMoveDuration: 300

        model: artistProxyModel
        delegate: artistDelegate

        cacheBuffer: 800
    }

    ScrollDecorator {
        id: scrolldecorator
        flickableItem: musicArtistList
    }

    Component {
        id: artistDelegate

        Cp.Delegate {
            title: model.name
            image: globals.cacheThumbnails ? model.posterThumb : model.poster

            style: globals.styleMusicArtists
            banner: globals.showBanners

            onSelected: {
                musicStack.push(Qt.resolvedUrl("MusicAlbumView.qml"), {artistId: model.id})
            }
        }
    }

    Cp.SearchDialog {
        id: searchDlg
        visible: btFilter.checked

        onApply: {
            artistProxyModel.filterRole = "name"
            artistProxyModel.filterRegExp = searchDlg.text
        }
        onCancel: {
            artistProxyModel.filterRole = ""
            artistProxyModel.filterRegExp = ""
        }
    }

    Component.onCompleted: {
        if (artistModel.count == 0)
            $().library.loadArtists();
    }

}
