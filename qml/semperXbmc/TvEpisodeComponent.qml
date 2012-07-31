import Qt 4.7
import com.nokia.symbian 1.1
import "components" as Cp;

import "js/Utils.js" as Utils

Item {
    property int seasonId: -99

    ListView {
        id: tvEpisodeList
        anchors.fill: parent
        clip: true

        model: episodeProxyModel
        delegate: episodeDelegate
    }

    ScrollDecorator {
        flickableItem: tvEpisodeList
    }

    ContextMenu {
        id: contextMenu
        property int index
        property bool seen

        MenuLayout {
            MenuItem {
                text: "Play episode"
                onClicked: {
                    var item = episodeProxyModel.properties(contextMenu.index)
                    if (item.resume && item.resume.position != 0) {
                        dialogPlaceholder.source = Qt.resolvedUrl("ResumeDialog.qml");
    //                    console.debug(model.resume.position + "/" + model.resume.total)
                        dialogPlaceholder.item.position = item.resume.position
                        dialogPlaceholder.item.total = item.resume.total
                        dialogPlaceholder.item.accepted.connect(
                                    function () {
                                        $().playlist.onPlaylistStarted =
                                                function(id) {
                                                    playlistTab.videoPlayer().seekPercentage(item.resume.position/item.resume.total*100);
                                                    $().playlist.onPlaylistStarted = null;
                                                }

                                        playEpisode(item.id);
                                    }
                                    );
                        dialogPlaceholder.item.rejected.connect(
                                    function () {
                                        playEpisode(item.id);
                                    }
                                    );
                        dialogPlaceholder.item.open();
                    } else {
                        playEpisode(item.id);
                    }
                }
            }
            MenuItem {
                text: "Append to queue"
                onClicked: {
                    var item = episodeProxyModel.properties(contextMenu.index)

                    var batch = "[";
                    var o = { jsonrpc: "2.0", method: "Playlist.Add", params: { playlistid: $().playlist.videoPlId, item: { episodeid: item.id } }};
                    batch += JSON.stringify(o)
                    batch += "]"

                    var doc = new globals.getJsonXMLHttpRequest();
                    doc.send(batch);

                    tvshowSuppModel.keyUpdate({"showtitle":contextMenu.showtitle, "lastplayed":new Date()});
                    if (tvshowProxyModel.sortRole == "lastplayed")
                        tvshowProxyModel.reSort();
                }
            }
            MenuItem {
                text: "Append season from here to queue"
                onClicked: {
                    var o
                    var batch = "[";
                    for (var i=contextMenu.index; i<episodeProxyModel.count; ++i) {
                        if (i > contextMenu.index)
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
                    var item = episodeProxyModel.properties(contextMenu.index)

                    var batch = "[";

                    var o = { jsonrpc: "2.0", method: "Playlist.Insert", params: { playlistid: $().playlist.videoPlId, item: { episodeid: item.id }, position: 0 }};
                    batch += JSON.stringify(o)

                    batch += "]"

                    var doc = new globals.getJsonXMLHttpRequest();
                    doc.send(batch);

                    tvshowSuppModel.keyUpdate({"showtitle":contextMenu.showtitle, "lastplayed":new Date()});
                    if (tvshowProxyModel.sortRole == "lastplayed")
                        tvshowProxyModel.reSort();
                }
            }
            MenuItem {
                text: "Mark as seen"
                visible: $().jsonRPCVer > 4 && !contextMenu.seen
                onClicked: {
                    var item = episodeProxyModel.properties(contextMenu.index)
                    $().library.markEpisodeAsSeen(item.id, true)
                }
            }
            MenuItem {
                text: "Mark as not seen"
                visible: $().jsonRPCVer > 4 && contextMenu.seen
                onClicked: {
                    var item = episodeProxyModel.properties(contextMenu.index)
                    $().library.markEpisodeAsSeen(item.id, false)
                }
            }
            MenuItem {
                text: "Remove"
                visible: $().jsonRPCVer > 4
                onClicked: {
                    dialogPlaceholder.source = Qt.resolvedUrl("DeleteDialog.qml");
                    dialogPlaceholder.item.accepted.connect(
                                function () {
                                    var item = episodeProxyModel.properties(contextMenu.index)
                                    $().library.removeEpisode(item.id, true)
                                }
                                );
                    dialogPlaceholder.item.rejected.connect(
                                function () {
                                    var item = episodeProxyModel.properties(contextMenu.index)
                                    $().library.removeEpisode(item.id, false)
                                }
                                );
                    dialogPlaceholder.item.open();
                }
            }
        }
    }

    function playEpisode(epId) {
        var batch = "[";
        var o = { jsonrpc: "2.0", method: "Player.Stop", params: { playerid:1 }};
        batch += JSON.stringify(o)
        o = { jsonrpc: "2.0", method: "Playlist.Clear", params: { playlistid:$().playlist.videoPlId }};
        batch += "," + JSON.stringify(o)

        o = { jsonrpc: "2.0", method: "Playlist.Add", params: { playlistid: $().playlist.videoPlId, item: { episodeid: epId } }, id: 1};
        batch += "," + JSON.stringify(o)

        batch += "]"

        var doc = new globals.getJsonXMLHttpRequest();
        doc.onreadystatechange = function() {
                    if (doc.readyState == XMLHttpRequest.DONE) {
                        //                        console.debug("lastplayed: "+ doc.responseText)
                        var oJSON = JSON.parse(doc.responseText);
                        var error = oJSON.error;
                        if (error) {
                            console.log(Utils.dumpObj(error, "playEpisode error", "", 0));
                            errorView.addError("error", error.message, error.code);
                            return;
                        }

                        $().playlist.play($().playlist.videoPlId, 0)

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

    Component {
        id: episodeDelegate

        Cp.Delegate {
            title: (model.number > 0 ? model.number + ". " : "") + model.name
            titleR: model.firstaired
            subtitle: (seasonId >= 0) ? (model.duration > 0 ? Utils.secToMinutes(model.duration) : "") : model.showtitle
            subtitleR: (seasonId >= 0) ? Utils.sprintf("%.1f", model.rating) : "S" + model.season
            image: model.poster != "" ? model.poster : "qrc:/defaultImages/tvshow"
            watched: model.playcount > 0

            style: globals.styleTvShowSeasons
            banner: false


            onSelected: {
                if (model.resume && model.resume.position != 0) {
                    dialogPlaceholder.source = Qt.resolvedUrl("ResumeDialog.qml");
//                    console.debug(model.resume.position + "/" + model.resume.total)
                    dialogPlaceholder.item.position = model.resume.position
                    dialogPlaceholder.item.total = model.resume.total
                    dialogPlaceholder.item.accepted.connect(
                                function () {
                                    $().playlist.onPlaylistStarted =
                                            function(id) {
                                                playlistTab.videoPlayer().seekPercentage(model.resume.position/model.resume.total*100);
                                                $().playlist.onPlaylistStarted = null;
                                            }

                                    playEpisode(model.id);
                                }
                                );
                    dialogPlaceholder.item.rejected.connect(
                                function () {
                                    playEpisode(model.id);
                                }
                                );
                    dialogPlaceholder.item.open();
                } else {
                    playEpisode(model.id);
                }
            }

            onContext: {
                contextMenu.index = index
                contextMenu.seen = (playcount > 0)
                contextMenu.open()
            }
        }

    }

    onSeasonIdChanged: {
        $().library.loadEpisodes(seasonId);
    }
}
