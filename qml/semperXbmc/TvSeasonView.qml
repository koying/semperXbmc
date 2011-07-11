import Qt 4.7
import com.nokia.symbian 1.0
import "components" as Cp;

import "js/Utils.js" as Utils

Page {
    property int serieId

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
        id: tvSeasonList
        anchors.fill: parent
        clip: true

        model: seasonModel
        delegate: seasonDelegate
    }

    ScrollDecorator {
        id: scrolldecorator
        flickableItem: tvSeasonList
    }

    Component {
        id: seasonDelegate

        Cp.Row {
            id: content
            width: parent.width;
            height: 200

            text: model.name
            subtitle: model.episodes + " episodes"
            source: model.thumb
            watched: model.playcount > 0

            onSelected: {
                tvshowStack.push(Qt.resolvedUrl("TvEpisodeView.qml"), {seasonId: id})
            }
        }
    }

    onSerieIdChanged: {
        seasonModel.clear();
        $().library.loadSeasons(serieId);
    }
}
