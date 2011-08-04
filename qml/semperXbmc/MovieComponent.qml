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
            function gotoUrl(url) {
                if (url != "") {
                    subComponent.item.bookmark = url
                    subComponent.item.url = url
                } else {
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

            Connections {
                target: subComponent

                onLoaded: {
                    toolBar.tools = subComponent.item.tools
                    gotoUrl(movieSuppModel.getValue(model.id, "url", ""));
                }
                onDestruction: toolBar.tools = page.tools
            }

            Connections {
                target:  subComponent.item

                onBookmarkChanged: {
                    if (subComponent.item.bookmark != "") {
                        movieSuppModel.setValue(model.id, "url", subComponent.item.bookmark);
                    } else {
                        movieSuppModel.removeValue(model.id, "url");
                    }
                }
            }

            onSelected:  {
                if (style == globals.styleMovies) {
                    if (model.resume && model.resume != 0) {
                        dialogPlaceholder.source = Qt.resolvedUrl("ResumeDialog.qml");
                        dialogPlaceholder.item.position = model.resume.position
                        dialogPlaceholder.item.total = model.resume.total
                        dialogPlaceholder.item.accepted.connect(
                                    function () {
                                        $().playlist.videoClear();
                                        xbmcEventClient.actionButton("Stop");
                                        mainTabGroup.currentTab = remoteTab
                                        $().playlist.onVideoStarted =
                                                function() {
                                                    $().videoplayer.seekPercentage(model.resume.position/model.resume.total*100);
                                                    $().playlist.onVideoStarted = undefined;
                                                }

                                        $().playlist.addMovie(model.id);
                                    }
                                    );
                        dialogPlaceholder.item.rejected.connect(
                                    function () {
                                        $().playlist.videoClear();
                                        xbmcEventClient.actionButton("Stop");
                                        mainTabGroup.currentTab = remoteTab
                                        $().playlist.addMovie(model.id);
                                    }
                                    );
                        dialogPlaceholder.item.open();
                    } else {
                        $().playlist.videoClear();
                        xbmcEventClient.actionButton("Stop");
                        mainTabGroup.currentTab = remoteTab
                        $().playlist.addMovie(model.id);
                    }
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
