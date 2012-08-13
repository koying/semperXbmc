import QtQuick 1.0
import com.nokia.symbian 1.1
import "components/" as Cp;
import "menus/" as Menus

import "js/Utils.js" as Utils

Page {
    id: page
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
        currentType: "Artists"
    }

    Menus.MusicStyleMenu {
        id: styleMenu
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
        flickableItem: musicArtistList
    }

    Component {
        id: artistDelegate

        Cp.Delegate {
            title: model.name
            image: model.poster != "" ? (globals.cacheThumbnails ? model.posterThumb : model.poster) : "qrc:/defaultImages/artist"

            style: globals.styleMusicArtists
            banner: globals.showBanners

            subComponentSource: ctxHasBrowser ? Qt.resolvedUrl("WebDetails.qml") : ""
            function gotoUrl(url) {
                if (url != "") {
                    subComponent.item.bookmark = url
                    subComponent.item.url = url
                } else
                    subComponent.item.url = "http://en.m.wikipedia.org/wiki?search="+ model.name.replace(" ", "+") + "&go=Go"
            }

            Component.onCompleted: {
                if (model.poster == "") {
                    $().library.getArtistThumbnail(model.id)
                }
            }

            Connections {
                target: subComponent

                onLoaded: {
                    toolBar.tools = subComponent.item.tools
                    gotoUrl(artistSuppModel.getValue(model.id, "url", ""));
                }
                onDestruction: toolBar.tools = page.tools
            }

            Connections {
                target:  subComponent.item

                onBookmarkChanged: {
                    if (subComponent.item.bookmark != "") {
                        artistSuppModel.setValue(model.id, "url", subComponent.item.bookmark);
                    } else {
                        artistSuppModel.removeValue(model.id, "url");
                    }
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
        visible: menuLayout.filterEnabled

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

        globals.initialMusicView = "MusicArtistView.qml"
    }

}
