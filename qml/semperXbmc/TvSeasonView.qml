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

    Menus.TvSortMenu {
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

                $().playlist.clear($().playlist.videoPlId);
                var i=0
                var batch = "[";
                var o = { jsonrpc: "2.0", method: "Player.Stop", params: { playerid:1 }};
                batch += JSON.stringify(o)
                o = { jsonrpc: "2.0", method: "Playlist.Clear", params: { playlistid:$().playlist.videoPlId }};
                batch += "," + JSON.stringify(o)

                for (var i=0; i<episodeProxyModel.count; ++i) {
                    o = { jsonrpc: "2.0", method: "Playlist.Add", params: { playlistid: $().playlist.videoPlId, item: { episodeid: episodeProxyModel.property(i, "id") } }};
                    batch += "," + JSON.stringify(o)
                }

                o = { jsonrpc: "2.0", method: "Player.Open", params: { item: { playlistid: $().playlist.videoPlId } }, id: 1};
                batch += "," + JSON.stringify(o)

                batch += "]"

                var doc = new globals.getJsonXMLHttpRequest();
                doc.onreadystatechange = function() {
                    if (doc.readyState == XMLHttpRequest.DONE) {
                        var oJSON = JSON.parse(doc.responseText);
                        var error = oJSON.error;
                        if (error) {
                            console.log(Utils.dumpObj(error, "playSeason error", "", 0));
                            errorView.addError("error", error.message, error.code);
                            return;
                        }

                        tvshowSuppModel.keyUpdate({"showtitle":model.showtitle, "lastplayed":new Date()});
                        if (tvshowProxyModel.sortRole == "lastplayed")
                            tvshowProxyModel.reSort();
                    }
                }
                console.debug(batch)
                doc.send(batch);

                main.state = "playlist"
                playlistTab.showVideo()
                mainTabGroup.currentTab = playlistTab
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
