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
        property bool seen

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
                visible: contextMenu.component ? !contextMenu.component.unavailable : true
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
                visible: contextMenu.component ? !contextMenu.component.unavailable : true
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
                visible: contextMenu.component ? !contextMenu.component.unavailable : true
            }

            MenuItem {
                text: "Show details"
                onClicked: {
                    var item = movieProxyModel.properties(contextMenu.index)
                    var delegate = contextMenu.component;
                    delegate.subComponentSource = Qt.resolvedUrl("MovieDetails.qml")
                    delegate.subComponent.loaded.connect(
                                function() {
                                   delegate.subComponent.item.movieId = item.id
                                }
                                )
                    delegate.style = "full"
                }
            }

            MenuItem {
                text: "Show IMDB"
                visible: ctxHasBrowser
                onClicked: {
                    var item = movieProxyModel.properties(contextMenu.index)
                    var delegate = contextMenu.component;
                    delegate.subComponentSource = Qt.resolvedUrl("WebDetails.qml")
                    delegate.subComponent.loaded.connect(
                                function() {
                                    toolBar.tools = delegate.subComponent.item.tools
                                    var url = movieSuppModel.getValue(item.id, "url", "")
                                    if (url != "") {
                                        delegate.subComponent.item.bookmark = url
                                        delegate.subComponent.item.url = url
                                    } else {
                                        var imdb = item.imdbnumber
                                        if (imdb != 0) {
                                            var imdbId = "tt" + Utils.sprintf("%.7d", item.imdbnumber);

                                            delegate.subComponent.item.url = "http://m.imdb.com/title/" + imdbId;
                                        } else {
                                            delegate.subComponent.item.url = "http://m.imdb.com/find?s=tt&q=" + item.originaltitle.replace(" ", "+");
                                        }
                                    }
                                }
                                )
                    delegate.subComponent.destruction.connect(
                                function() {
                                    toolBar.tools = page.tools
                                }
                                )

                    delegate.subComponent.item.bookmarkChanged.connect(
                                function() {
                                    if (delegate.subComponent.item.bookmark != "") {
                                        movieSuppModel.setValue(item.id, "url", delegate.subComponent.item.bookmark);
                                    } else {
                                        movieSuppModel.removeValue(item.id, "url");
                                    }
                                }
                                )

                    delegate.style = "full"
                }
            }
            MenuItem {
                text: "Mark as seen"
                visible: $().jsonRPCVer > 4 && !contextMenu.seen
                onClicked: {
                    var item = movieProxyModel.properties(contextMenu.index)
                    $().library.markMovieAsSeen(item.id, true)
                }
            }
            MenuItem {
                text: "Mark as not seen"
                visible: $().jsonRPCVer > 4 && contextMenu.seen
                onClicked: {
                    var item = movieProxyModel.properties(contextMenu.index)
                    $().library.markMovieAsSeen(item.id, false)
                }
            }
            MenuItem {
                text: "Remove"
                visible: $().jsonRPCVer > 4
                onClicked: {
                    dialogPlaceholder.source = Qt.resolvedUrl("DeleteDialog.qml");
                    dialogPlaceholder.item.accepted.connect(
                                function () {
                                    var item = movieProxyModel.properties(contextMenu.index)
                                    $().library.removeMovie(item.id, true)
                                }
                                );
                    dialogPlaceholder.item.rejected.connect(
                                function () {
                                    var item = movieProxyModel.properties(contextMenu.index)
                                    $().library.removeMovie(item.id, false)
                                }
                                );
                    dialogPlaceholder.item.open();
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
            subtitle: model.duration
            subtitleR:  Utils.sprintf("%.1f", model.rating)
//            subtitleR:  model.duration > 0 ? Utils.secToHours(model.duration) : (model.runtime != undefined ? model.runtime : "")
            image: model.poster != "" ? (globals.cacheThumbnails ? model.posterThumb : model.poster) : "qrc:/defaultImages/movie"
            watched: model.playcount > 0
            unavailable: model.id == 0

            style: globals.styleMovies
            banner: false

            onSelected:  {
                if (style != globals.styleMovies) {
                    style = globals.styleMovies
                    return;
                }

                if (model.id == 0) {
                    style = "full"
                    return
                }
                contextMenu.index = index
                contextMenu.component = delegate
                contextMenu.seen = (playcount > 0)
                contextMenu.open()
            }


            Component.onCompleted: {
                if (model.poster == "") {
                    $().library.getMovieThumbnail(model.id)
                }
            }
        }

    }
}
