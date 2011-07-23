import Qt 4.7
import com.nokia.symbian 1.0
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
        id: scrolldecorator
        flickableItem: tvEpisodeList
    }

    Component {
        id: episodeDelegate

        Cp.Delegate {
            title: (model.number > 0 ? model.number + ". " : "") + model.name
            subtitle: (model.duration > 0 ? Utils.secToMinutes(model.duration) : "")
            subtitleR: Utils.sprintf("%.1f", model.rating)
            image: model.poster
            watched: model.playcount > 0

            style: globals.styleTvShowSeasons
            banner: globals.showBanners

            onSelected: {
//                console.log("episode clicked" + id);
                $().playlist.videoClear();
                xbmcEventClient.actionButton("Stop");
                $().playlist.addEpisode(id);
                tvshowLastplayedModel.keyUpdate({"id":model.tvshowId, "lastplayed":new Date()});
                if (tvshowProxyModel.sortRole == "lastplayed")
                    tvshowProxyModel.reSort();
                mainTabGroup.currentTab = remoteTab
            }
        }

    }

    onSeasonIdChanged: {
        episodeModel.clear();
        $().library.loadEpisodes(seasonId);
    }
}
