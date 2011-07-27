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

            subComponentSource: Qt.resolvedUrl("WebDetails.qml")
            Connections {
                target: subComponent

                onLoaded: {
                    var url = movieSuppModel.getValue(model.id, "url", "");
                    if (url != "")
                        subComponent.item.url = url
                    else {
                        var imdb = model.imdbnumber
                        if (imdb) {
                            if (imdb.indexOf("tt") != 0) {
                                imdb = "tt" + Utils.sprintf("%.7d", model.imdbnumber);
                            }

                            subComponent.item.url = "http://m.imdb.com/title/" + imdb;
                        } else {
                            subComponent.item.url = "http://m.imdb.com/find?s=tt&q=" + model.originaltitle.replace(" ", "+");
                        }
                    }

        //            url = "http://en.m.wikipedia.org/wiki?search=film+"+ model.originaltitle.replace(" ", "+") + "&go=Go"
                }
            }

            Connections {
                target:  subComponent.item

                onUrlModified: {
                    movieSuppModel.setValue(model.id, "url", subComponent.item.url);
                }
            }

            onSelected:  {
                if (style == globals.styleMovies) {
                    $().playlist.videoClear();
                    xbmcEventClient.actionButton("Stop");
                    $().playlist.addMovie(model.id);
                    mainTabGroup.currentTab = remoteTab
                } else
                    style = globals.styleMovies
            }

            onContext: {
                if (style == globals.styleMovies)
                    style = "full"
                else
                    style = globals.styleMovies
            }
        }
    }
}
