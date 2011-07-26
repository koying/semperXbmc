import QtQuick 1.0
import com.nokia.symbian 1.0
import com.semperpax.qmlcomponents 1.0
import "components" as Cp;

import "js/Utils.js" as Utils

Item {
    ListView {
        id: tvshowList
        anchors.fill: parent
        clip: true

        model: tvshowProxyModel
        delegate: tvshowDelegate

        cacheBuffer: 800
    }

    ScrollDecorator {
        flickableItem: tvshowList
    }

    Component {
        id: tvshowDelegate

        Cp.Delegate {
            title: model.name
            subtitle: (model.genre != undefined ? model.genre : "")
            subtitleR: tvshowProxyModel.sortRole == "lastplayed" ? (model.lastplayed ? Utils.dateToString(model.lastplayed) : "") : ""
            image: model.posterThumb
            watched: model.playcount>0

            banner: globals.showBanners
            style: globals.styleTvShows

            onSelected:  {
                tvshowStack.push(Qt.resolvedUrl("TvSeasonView.qml"), {serieId: model.id})
            }
        }
    }
}
