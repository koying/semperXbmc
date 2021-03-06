import Qt 4.7
import com.nokia.symbian 1.1
import "components/" as Cp;
import "menus/" as Menus

import "js/Utils.js" as Utils

Page {
    id: page
    focus: true

    property int serieId
    property bool allFull: false

    tools:  menuLayout

    Menus.TvToolbarLayout {
        id: menuLayout
    }

    Keys.onBackPressed: {
        tvshowStack.pop()
        event.accepted = true
    }

    Menus.TvEpisodeSortMenu {
        id: sortMenu
    }

    Menus.TvViewMenu {
        id: viewMenu
        currentType: "All"
    }

    Menus.TvSeasonStyleMenu {
        id: styleMenu
    }

    ListView {
        id: tvSeasonList
        anchors.fill: parent
        clip: true

        model: seasonProxyModel
        delegate: seasonDelegate
    }

    ScrollDecorator {
        flickableItem: tvSeasonList
    }

    ContextMenu {
        id: contextMenu
        property string showtitle

        MenuLayout {
            MenuItem {
                text: "Play season"
                onClicked: {
                    var batch = "[";
                    var o = { jsonrpc: "2.0", method: "Player.Stop", params: { playerid:1 }};
                    batch += JSON.stringify(o)
                    o = { jsonrpc: "2.0", method: "Playlist.Clear", params: { playlistid:$().playlist.videoPlId }};
                    batch += "," + JSON.stringify(o)

                    for (var i=0; i<episodeProxyModel.count; ++i) {
                        o = { jsonrpc: "2.0", method: "Playlist.Add", params: { playlistid: $().playlist.videoPlId, item: { episodeid: episodeProxyModel.property(i, "id") } }};
                        batch += "," + JSON.stringify(o)
                    }

                    o = { jsonrpc: "2.0", method: "Player.Open", params: { item: { playlistid: $().playlist.videoPlId } }};
                    batch += "," + JSON.stringify(o)

                    batch += "]"

                    var doc = new globals.getJsonXMLHttpRequest();
                    doc.send(batch);

                    tvshowSuppModel.keyUpdate({"showtitle":contextMenu.showtitle, "lastplayed":new Date()});
                    if (tvshowProxyModel.sortRole == "lastplayed")
                        tvshowProxyModel.reSort();

                    main.state = "playlist"
                    playlistTab.showVideo()
                    mainTabGroup.currentTab = playlistTab
                }
            }
            MenuItem {
                text: "Append to queue"
                onClicked: {
                    var o
                    var batch = "[";
                    for (var i=0; i<episodeProxyModel.count; ++i) {
                        if (i > 0)
                            batch += ","
                        o = { jsonrpc: "2.0", method: "Playlist.Add", params: { playlistid: $().playlist.videoPlId, item: { episodeid: episodeProxyModel.property(i, "id") } }};
                        batch += JSON.stringify(o)
                    }
                    batch += "]"

                    var doc = new globals.getJsonXMLHttpRequest();
                    doc.send(batch);

                    tvshowSuppModel.keyUpdate({"showtitle":contextMenu.showtitle, "lastplayed":new Date()});
                    if (tvshowProxyModel.sortRole == "lastplayed")
                        tvshowProxyModel.reSort();
                }
            }
            MenuItem {
                text: "Insert into queue"
                onClicked: {
                    var o
                    var batch = "[";
                    for (var i=0; i<episodeProxyModel.count; ++i) {
                        if (i > 0)
                            batch += ","
                        o = { jsonrpc: "2.0", method: "Playlist.Insert", params: { playlistid: $().playlist.videoPlId, item: { episodeid: episodeProxyModel.property(i, "id") }, position: i }};
                        batch += JSON.stringify(o)
                    }
                    batch += "]"

                    var doc = new globals.getJsonXMLHttpRequest();
                    doc.send(batch);

                    tvshowSuppModel.keyUpdate({"showtitle":contextMenu.showtitle, "lastplayed":new Date()});
                    if (tvshowProxyModel.sortRole == "lastplayed")
                        tvshowProxyModel.reSort();
                }
            }
        }
    }

    Component {
        id: seasonDelegate

        Cp.Delegate {
            title: model.name
            subtitle:  model.showtitle
            subtitleR: model.episodes + " ep"
            image: model.poster != "" ? model.poster : "qrc:/defaultImages/tvshow"
            watched: model.playcount > 0

            style: page.allFull ? "full" : globals.styleTvShowSeasons
            banner: globals.showBanners
            type: "header"

            subComponentSource: "TvEpisodeComponent.qml"

            Connections {
                target: subComponent
                onLoaded: subComponent.item.seasonId = model.id
            }

            onSelected:  {
//                tvshowStack.push(Qt.resolvedUrl("TvEpisodeView.qml"), {seasonId: id})
                if (style == globals.styleTvShowSeasons)
                    style = "full"
                else
                    style = globals.styleTvShowSeasons
            }

            onContext: {
                if (episodeProxyModel.count == 0)
                    return

                contextMenu.showtitle = model.showtitle
                contextMenu.open()
            }
        }
    }

    function refresh() {
        episodeModel.clear();
        $().library.onDone =
                function() {
                    if (seasonProxyModel.count == 1) {
                        page.allFull = true
                    }

                    $().library.onDone = null
                }

        $().library.loadSeasons(serieId);
    }

    onSerieIdChanged: {
        refresh()
    }
}
