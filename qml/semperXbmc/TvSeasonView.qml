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
                $().playlist.onPlaylistChanged =
                        function(id) {
                            i++;
                            if (i<episodeProxyModel.count)
                                $().playlist.addEpisode(episodeProxyModel.property(i, "id"));
                            else {
                                $().playlist.onPlaylistChanged = null;
                                playlistView.back.player.playPause()
                            }
                        }
                $().playlist.addEpisode(episodeProxyModel.property(i, "id"));

                playlistView.showVideo()
                main.state = "playlist"
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
