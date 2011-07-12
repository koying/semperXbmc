import Qt 4.7
import com.nokia.symbian 1.0
import "components" as Cp;

import "js/Utils.js" as Utils

Page {
    property int seasonId: -99

    tools:  tvshowStack.depth > 1 ? pgTools : null

    ToolBarLayout {
        id: pgTools

        ToolButton {
            iconSource: "toolbar-back"
            onClicked: tvshowStack.pop()
            visible: tvshowStack.depth > 1
        }
    }

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

        Cp.Row {
            id: content
            width: ListView.view.width;
            height: 80

            text: (model.number > 0 ? model.number + ". " : "") + model.name
            subtitle: (model.duration > 0 ? Utils.secToMinutes(model.duration) : "")
            source: model.thumb
            watched: model.playcount > 0

            onSelected: {
//                console.log("episode clicked" + id);
                $().playlist.videoClear();
                xbmcEventClient.actionButton("Stop");
                $().playlist.addEpisode(id);
            }
        }
    }

    onSeasonIdChanged: {
        episodeModel.clear();
        $().library.loadEpisodes(seasonId);
    }
}
