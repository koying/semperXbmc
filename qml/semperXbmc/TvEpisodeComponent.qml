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

    Component {
        id: episodeDelegate

        Cp.Delegate {
            title: (model.number > 0 ? model.number + ". " : "") + model.name
            subtitle: (seasonId >= 0) ? (model.duration > 0 ? Utils.secToMinutes(model.duration) : "") : model.showtitle
            subtitleR: (seasonId >= 0) ? Utils.sprintf("%.1f", model.rating) : "S" + model.season
            image: model.poster != "" ? model.poster : "qrc:/defaultImages/tvshow"
            watched: model.playcount > 0

            style: globals.styleTvShowSeasons
            banner: globals.showBanners

            function playEpisode() {
                var batch = "[";
                var o = { jsonrpc: "2.0", method: "Player.Stop", params: { playerid:1 }};
                batch += JSON.stringify(o)
                o = { jsonrpc: "2.0", method: "Playlist.Clear", params: { playlistid:$().playlist.videoPlId }};
                batch += "," + JSON.stringify(o)

                o = { jsonrpc: "2.0", method: "Playlist.Add", params: { playlistid: $().playlist.videoPlId, item: { episodeid: model.id } }, id: 1};
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

            function addEpisode() {
                var batch = "[";

                var o = { jsonrpc: "2.0", method: "Playlist.Add", params: { playlistid: $().playlist.videoPlId, item: { episodeid: model.id } }, id: 1};
                batch += JSON.stringify(o)

                batch += "]"

                var doc = new globals.getJsonXMLHttpRequest();
                doc.onreadystatechange = function() {
                    if (doc.readyState == XMLHttpRequest.DONE) {
                        var oJSON = JSON.parse(doc.responseText);
                        var error = oJSON.error;
                        if (error) {
                            console.log(Utils.dumpObj(error, "playEpisode error", "", 0));
                            errorView.addError("error", error.message, error.code);
                            return;
                        }

                        tvshowSuppModel.keyUpdate({"id":model.tvshowId, "lastplayed":new Date()});
                        if (tvshowProxyModel.sortRole == "lastplayed")
                            tvshowProxyModel.reSort();
                    }
                }
//                console.debug(batch)
                doc.send(batch);

                main.state = "playlist"
                playlistTab.showVideo()
                mainTabGroup.currentTab = playlistTab
            }

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

                                    playEpisode();
                                }
                                );
                    dialogPlaceholder.item.rejected.connect(
                                function () {
                                    playEpisode();
                                }
                                );
                    dialogPlaceholder.item.open();
                } else {
                    playEpisode();
                }
            }

            onContext: {
                addEpisode();
            }
        }

    }

    onSeasonIdChanged: {
        $().library.loadEpisodes(seasonId);
    }
}
