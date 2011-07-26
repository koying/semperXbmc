import QtQuick 1.0
import com.nokia.symbian 1.0
import com.semperpax.qmlcomponents 1.0
import "components" as Cp;

import "js/Utils.js" as Utils

Item {
    ListView {
        id: movieList
        anchors.fill: parent
        clip: true

        model: movieProxyModel
        delegate: movieDelegate

        cacheBuffer: 800
    }

    ScrollDecorator {
        flickableItem: movieList
    }

    Component {
        id: movieDelegate

        Cp.Delegate {
            title: model.name
            titleR: model.year ? model.year : ""
            subtitle: (model.genre != undefined ? model.genre : "")
            subtitleR:  Utils.sprintf("%.1f", model.rating)
//            subtitleR:  model.duration > 0 ? Utils.secToHours(model.duration) : (model.runtime != undefined ? model.runtime : "")
            image: globals.cacheThumbnails ? model.posterThumb : model.poster
            watched: model.playcount > 0

            style: globals.styleMovies
            banner: globals.showBanners

            subComponentSource: Qt.resolvedUrl("MovieDetails.qml")

            onSelected:  {
                if (style == globals.styleMovies)
                    style = "full"
                else
                    style = globals.styleMovies
            }
        }
    }
}
