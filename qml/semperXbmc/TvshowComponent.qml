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

            subComponentSource: Qt.resolvedUrl("WebDetails.qml")
            Connections {
                target: subComponent

                onLoaded: {
//                    subComponent.item.url = "http://m.imdb.com/find?s=tt&q=" + model.originaltitle.replace(" ", "+");
                    var url = tvshowSuppModel.getValue(model.id, "url", "");
                    if (url != "")
                        subComponent.item.url = url
                    else
                        subComponent.item.url = "http://en.m.wikipedia.org/wiki?search="+ model.originaltitle.replace(" ", "+") + "&go=Go"
                }
            }

            Connections {
                target:  subComponent.item

                onUrlChanged: {
                    tvshowSuppModel.setValue(model.id, "url", subComponent.item.url);
                }
            }

            onSelected:  {
                if (style == globals.styleTvShows) {
                    tvshowStack.push(Qt.resolvedUrl("TvSeasonView.qml"), {serieId: model.id})
                } else
                    style = globals.styleTvShows
            }

            onContext: {
                if (style == globals.styleTvShows)
                    style = "full"
                else
                    style = globals.styleTvShows
            }
        }
    }
}
