import QtQuick 1.0
import com.nokia.symbian 1.1
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

    ContextMenu {
        id: contextMenu
        property int index
        property variant component

        MenuLayout {
            MenuItem {
                text: "Play movie"
                onClicked: {
                    var item = movieProxyModel.properties(contextMenu.index)
                    if (item.resume && item.resume.position != 0) {
                        dialogPlaceholder.source = Qt.resolvedUrl("ResumeDialog.qml");
    //                    console.debug(model.resume.position + "/" + model.resume.total)
                        dialogPlaceholder.item.position = item.resume.position
                        dialogPlaceholder.item.total = item.resume.total
                        dialogPlaceholder.item.accepted.connect(
                                    function () {
                                        $().playlist.onPlaylistStarted =
                                                function(id) {
                                                    playlistTab.videoPlayer().seekPercentage(item.resume.position/item.resume.total*100);
                                                    $().playlist.onPlaylistStarted = null;
                                                }

                                        playMovie(item.id);
                                    }
                                    );
                        dialogPlaceholder.item.rejected.connect(
                                    function () {
                                        playMovie(item.id);
                                    }
                                    );
                        dialogPlaceholder.item.open();
                    } else {
                        playMovie(item.id);
                    }
                }
                visible: !contextMenu.component.unavailable
            }
            MenuItem {
                text: "Append to queue"
                onClicked: {
                    var item = movieProxyModel.properties(contextMenu.index)

                    var batch = "[";
                    var o = { jsonrpc: "2.0", method: "Playlist.Add", params: { playlistid: $().playlist.videoPlId, item: { movieid: item.id } }};
                    batch += JSON.stringify(o)
                    batch += "]"

                    var doc = new globals.getJsonXMLHttpRequest();
                    doc.send(batch);
                }
                visible: !contextMenu.component.unavailable
            }
            MenuItem {
                text: "Insert into queue"
                onClicked: {
                    var item = movieProxyModel.properties(contextMenu.index)

                    var batch = "[";

                    var o = { jsonrpc: "2.0", method: "Playlist.Insert", params: { playlistid: $().playlist.videoPlId, item: { movieid: item.id }, position: 0 }};
                    batch += JSON.stringify(o)

                    batch += "]"

                    var doc = new globals.getJsonXMLHttpRequest();
                    doc.send(batch);
                }
                visible: !contextMenu.component.unavailable
            }
            MenuItem {
                text: "Show IMDB"
                visible: ctxHasBrowser
                onClicked: {
                    contextMenu.component.style = "full"
                }
            }
        }
    }

    function playMovie(movieId) {
        var batch = "[";
        var o = { jsonrpc: "2.0", method: "Player.Stop", params: { playerid:1 }};
        batch += JSON.stringify(o)
        o = { jsonrpc: "2.0", method: "Playlist.Clear", params: { playlistid:$().playlist.videoPlId }};
        batch += "," + JSON.stringify(o)

        o = { jsonrpc: "2.0", method: "Playlist.Add", params: { playlistid: $().playlist.videoPlId, item: { movieid: movieId } }, id: 1};
        batch += "," + JSON.stringify(o)

        batch += "]"

        var doc = new globals.getJsonXMLHttpRequest();
        doc.onreadystatechange = function() {
                    if (doc.readyState == XMLHttpRequest.DONE) {
                        var oJSON = JSON.parse(doc.responseText);
                        var error = oJSON.error;
                        if (error) {
                            console.log(Utils.dumpObj(error, "playMovie error", "", 0));
                            errorView.addError("error", error.message, error.code);
                                return;
                            }
                            $().playlist.play($().playlist.videoPlId, 0)
                        }
                    }
            //                console.debug(batch)
            doc.send(batch);

            main.state = "playlist"
            playlistTab.showVideo()
            mainTabGroup.currentTab = playlistTab
    }

    Component {
        id: movieDelegate

        Cp.Delegate {
            id: delegate

            title: model.name
            titleR: model.year ? model.year : ""
            subtitle: (model.genre != undefined ? model.genre : "")
            subtitleR:  Utils.sprintf("%.1f", model.rating)
//            subtitleR:  model.duration > 0 ? Utils.secToHours(model.duration) : (model.runtime != undefined ? model.runtime : "")
            image: model.poster != "" ? (globals.cacheThumbnails ? model.posterThumb : model.poster) : "qrc:/defaultImages/movie"
            watched: model.playcount > 0
            unavailable: model.id == 0

            style: globals.styleMovies
            banner: globals.showBanners

            subComponentSource: ctxHasBrowser ? Qt.resolvedUrl("WebDetails.qml") : ""
            function gotoUrl(url) {
                if (url != "") {
                    subComponent.item.bookmark = url
                    subComponent.item.url = url
                } else {
                    var imdb = model.imdbnumber
                    if (imdb != 0) {
                        var imdbId = "tt" + Utils.sprintf("%.7d", model.imdbnumber);

                        subComponent.item.url = "http://m.imdb.com/title/" + imdbId;
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
                    if (model.id == 0) {
                        style = "full"
                        return
                    }
                    if (model.resume && model.resume.position != 0) {
                        dialogPlaceholder.source = Qt.resolvedUrl("ResumeDialog.qml");
                        dialogPlaceholder.item.position = model.resume.position
                        dialogPlaceholder.item.total = model.resume.total
                        dialogPlaceholder.item.accepted.connect(
                                    function () {
                                        $().playlist.onPlaylistStarted =
                                                function(id) {
                                                    playlistTab.videoPlayer().seekPercentage(model.resume.position/model.resume.total*100);
                                                    $().playlist.onPlaylistStarted = null;
                                                }

                                        playMovie(model.id);
                                    }
                                    );
                        dialogPlaceholder.item.rejected.connect(
                                    function () {
                                        playMovie(model.id);
                                    }
                                    );
                        dialogPlaceholder.item.open();
                    } else {
                        playMovie(model.id);
                    }
                } else
                    style = globals.styleMovies
            }

            onContext: {
                contextMenu.index = index
                contextMenu.component = delegate
                contextMenu.open()
            }
        }
    }
}
