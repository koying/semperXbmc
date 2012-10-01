import QtQuick 1.0
import com.nokia.symbian 1.1
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
            subtitleR: tvshowProxyModel.sortRole == "lastplayed" ? model.lastplayed : ""
            image: model.poster != "" ? (globals.cacheThumbnails ? model.posterThumb : model.poster) : "qrc:/defaultImages/tvshow"
            watched: model.playcount>0

            banner: globals.showBanners
            style: globals.styleTvShows

            subComponentSource: ctxHasBrowser ? Qt.resolvedUrl("WebDetails.qml") : ""
            function gotoUrl(url) {
                if (url != "") {
                    subComponent.item.bookmark = url
                    subComponent.item.url = url
                } else
                    subComponent.item.url = "http://en.m.wikipedia.org/wiki?search="+ model.originaltitle.replace(" ", "+") + "&go=Go"
            }
            Connections {
                target: subComponent

                onLoaded: {
                    toolBar.tools = subComponent.item.tools
                    gotoUrl(tvshowSuppModel.getValue(model.id, "url", ""));
                }
                onDestruction: toolBar.tools = page.tools
            }

            Connections {
                target:  subComponent.item

                onBookmarkChanged: {
                    if (subComponent.item.bookmark != "") {
                        tvshowSuppModel.setValue(model.id, "url", subComponent.item.bookmark);
                    } else {
                        tvshowSuppModel.removeValue(model.id, "url");
                    }
                }
            }

            onSelected:  {
                if (style == globals.styleTvShows) {
                    tvshowStack.push(Qt.resolvedUrl("TvSeasonView.qml"), {serieId: model.id})
                } else
                    style = globals.styleTvShows
            }

            onContext: {
                if (style == globals.styleTvShows) {
                    style = "full"
                } else
                    style = globals.styleTvShows
            }
        }
    }
}
