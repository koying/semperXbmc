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
                playlistView.back.player.stop()
                $().playlist.videoClear();
                $().playlist.onPlaylistChanged =
                        function(id) {
                            playlistView.back.player.playPause()
                            $().playlist.onPlaylistChanged = null;
                        }
                $().playlist.addEpisode(id);

                tvshowSuppModel.keyUpdate({"id":model.tvshowId, "lastplayed":new Date()});
                if (tvshowProxyModel.sortRole == "lastplayed")
                    tvshowProxyModel.reSort();
                playlistView.showVideo()
                main.state = "playlist"
                mainTabGroup.currentTab = playlistTab
            }

            onSelected: {
                if (model.resume && model.resume.position != 0) {
                    dialogPlaceholder.source = Qt.resolvedUrl("ResumeDialog.qml");
                    dialogPlaceholder.item.position = model.resume.position
                    dialogPlaceholder.item.total = model.resume.total
                    dialogPlaceholder.item.accepted.connect(
                                function () {
                                    $().playlist.onPlaylistStarted =
                                            function(id) {
                                                $().videoplayer.seekPercentage(model.resume.position/model.resume.total*100);
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
                if (seasonId >= 0) {
                }
            }
        }

    }

    onSeasonIdChanged: {
        $().library.loadEpisodes(seasonId);
    }
}
