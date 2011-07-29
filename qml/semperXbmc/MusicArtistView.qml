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
            }
            MenuItem {
                text:  "Recent Albums"
                onClicked: {
                    globals.initialMusicView = "MusicRecentAlbumView.qml"
                    musicStack.replace(Qt.resolvedUrl(globals.initialMusicView))
                }
            }
            MenuItem {
                text:  "All Albums"
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

            subComponentSource: Qt.resolvedUrl("WebDetails.qml")
            Connections {
                target: subComponent

                onLoaded: {
//                    subComponent.item.url = "http://m.imdb.com/find?s=tt&q=" + model.originaltitle.replace(" ", "+");
                    var url = artistSuppModel.getValue(model.id, "url", "");
                    if (url != "")
                        subComponent.item.url = url
                    else
                        subComponent.item.url = "http://en.m.wikipedia.org/wiki?search="+ model.name.replace(" ", "+") + "&go=Go"
                }
            }

            Connections {
                target:  subComponent.item

                onUrlModified: {
                    artistSuppModel.setValue(model.id, "url", subComponent.item.url);
                }
            }

            onSelected:  {
                if (style == globals.styleMusicArtists) {
                    musicStack.push(Qt.resolvedUrl("MusicAlbumView.qml"), {artistId: model.id})
                } else
                    style = globals.styleMusicArtists
            }

            onContext: {
                if (style == globals.styleMusicArtists)
                    style = "full"
                else
                    style = globals.styleMusicArtists
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

    function refresh() {
        $().library.loadArtists();
    }

    Component.onCompleted: {
        if (artistModel.count == 0)
            $().library.loadArtists();
    }

}
