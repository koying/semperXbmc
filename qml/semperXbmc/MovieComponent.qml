import QtQuick 1.0
import com.nokia.symbian 1.0
import com.semperpax.qmlcomponents 1.0
import "components" as Cp;

import "js/Utils.js" as Utils
import "js/filter.js" as Filter

Item {
    ListView {
        id: movieList
        anchors.fill: parent
        clip: true

        model: movieProxyModel
        delegate: movieDelegate
    }

    ScrollDecorator {
        id: scrolldecorator
        flickableItem: movieList
    }

    Component {
        id: movieDelegate

        Cp.Delegate {
            filtered: {
                var ret = false;
                ret = ret | (!globals.showViewed && model.playcount > 0 );
                return ret;
            }

            title: model.name
            titleR: model.year
            subtitle: (model.genre != undefined ? model.genre : "")
            subtitleR:  Utils.sprintf("%.1f", model.rating)
//            subtitleR:  model.duration > 0 ? Utils.secToHours(model.duration) : (model.runtime != undefined ? model.runtime : "")
            image: model.posterThumb
            watched: model.playcount > 0

            onSelected:  {
                $().playlist.videoClear();
                xbmcEventClient.actionButton("Stop");
                $().playlist.addMovie(model.id);
                mainTabGroup.currentTab = remoteTab
            }
        }
    }
}
