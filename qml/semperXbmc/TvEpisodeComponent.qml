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

        model: episodeModel
        delegate: episodeDelegate
    }

    ScrollDecorator {
        id: scrolldecorator
        flickableItem: tvEpisodeList
    }

    Component {
        id: episodeDelegate

        Cp.Delegate {
            filtered: {
                          var ret = false;
                          ret = ret | (!globals.showViewed && model.playcount > 0 );
                          return ret;
                      }

            title: (model.number > 0 ? model.number + ". " : "") + model.name
            subtitle: (model.duration > 0 ? Utils.secToMinutes(model.duration) : "")
            subtitleR: model.rating
            image: model.thumb
            watched: model.playcount > 0

            style: globals.styleTvShowSeasons
            banner: globals.showBanners

            onSelected: {
//                console.log("episode clicked" + id);
                $().playlist.videoClear();
                xbmcEventClient.actionButton("Stop");
                $().playlist.addEpisode(id);
                mainTabGroup.currentTab = remoteTab
            }
        }

    }

    onSeasonIdChanged: {
        episodeModel.clear();
        $().library.loadEpisodes(seasonId);
    }
}
