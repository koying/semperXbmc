/**
 * Playlist
 *
 */


function Playlist() {
}

Playlist.prototype.previousItems = {}
Playlist.prototype.playing = false;
Playlist.prototype.paused = false;

Playlist.prototype.insertTrack = function(idTrack){
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {

            var error = JSON.parse(doc.responseText).error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "Playlist.prototype.insertTrack error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            if (!Playlist.prototype.playing) {
//                console.log("play");
                Playlist.prototype.cmd("Play", "Audio");
            }
        }
    }
    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "AudioPlaylist.Insert", "params": { "item": { "songid": '+idTrack+'}, "index": 0 }, "id": 1}';
//    console.log(str);
    doc.send(str);
    return;
}

Playlist.prototype.addTrack = function(idTrack){
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {

            var error = JSON.parse(doc.responseText).error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "Playlist.prototype.addTrack error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            if (!Playlist.prototype.playing) {
//                console.log("play");
                Playlist.prototype.cmd("Play", "Audio");
            }
        }
    }
    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "AudioPlaylist.Add", "params": { "item": { "songid": '+idTrack+'} }, "id": 1}';
//    console.log(str);
    doc.send(str);
    return;
}

Playlist.prototype.insertAlbum = function(idalbum){
//    console.log("add");
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {

            var error = JSON.parse(doc.responseText).error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "Playlist.prototype.insertAlbum error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            if (!Playlist.prototype.playing) {
//                console.log("play");
                Playlist.prototype.cmd("Play", "Audio");
            }
        }
    }
    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "AudioPlaylist.Insert", "params": { "item": { "albumid": '+idalbum+'}, "index": 0 }, "id": 1}';
//    console.log(str);
    doc.send(str);
    return;
}


Playlist.prototype.addAlbum = function(idalbum){
//    console.log("add");
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {

            var error = JSON.parse(doc.responseText).error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "Playlist.prototype.addAlbum error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            if (!Playlist.prototype.playing) {
//                console.log("play");
                Playlist.prototype.cmd("Play", "Audio");
            }
        }
    }
    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "AudioPlaylist.Add", "params": { "item": { "albumid": '+idalbum+'} }, "id": 1}';
//    console.log(str);
    doc.send(str);
    return;
}

Playlist.prototype.addMovie = function(idmovie){
//    console.log("add movie");
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {

            var error = JSON.parse(doc.responseText).error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "Playlist.prototype.addMovie error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            if (!Playlist.prototype.playing) {
                console.log("play");
                Playlist.prototype.cmd("Play", "Video");
            }
        }
    }
    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "VideoPlaylist.Add", "params": { "item": { "movieid": '+idmovie+'} }, "id": 1}';
    doc.send(str);
    return;
}

Playlist.prototype.addEpisode = function(idepisode){
    console.log("add episode");
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {

            var error = JSON.parse(doc.responseText).error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "Playlist.prototype.addEpisode error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            if (!Playlist.prototype.playing) {
//                console.log("play");
                Playlist.prototype.cmd("Play", "Video");
            }
        }
    }
    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "VideoPlaylist.Add", "params": { "item": { "episodeid": '+idepisode+'} }, "id": 1}';
    console.log(str);
    doc.send(str);
    return;
}

Playlist.prototype.videoClear = function(){
    Playlist.prototype.cmd("Clear", "Video");
}

Playlist.prototype.audioClear = function(){
    Playlist.prototype.cmd("Clear", "Audio");
}

Playlist.prototype.update = function(playlistModel){
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);

            var error = oJSON.error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "Playlist.prototype.update error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            var result = oJSON.result;
            if ( result && result.items) {
                var items = result.items;

                if (!Playlist.prototype.previousItems || !isEqual(Playlist.prototype.previousItems,items)) {
                    console.log("new playlist");
                    Playlist.prototype.previousItems = items;
                    playlistModel.clear();
                    for (var i = 0; i < items.length; i++){

                        var thumb = "qrc:/defaultImages/album";
                        if (items[i].thumbnail && items[i].thumbnail != "DefaultAlbumCover.png") {
                            thumb = "http://"+$().server+":" + $().port + "/vfs/" + items[i].thumbnail;
                        }
                        playlistModel.append({"name": items[i].label, "id": i, "select": false, "thumb": thumb, "artist": items[i].artist, "album": items[i].album, "duration": items[i].duration });
                    }
                }
            } else {
                playlistModel.clear();
                Playlist.prototype.playing = false;
                Playlist.prototype.paused = false;
            }

            if (result.state && playlistModel.count > 0) {
                for (var i = 0; i < playlistModel.count; i++) {
                    playlistModel.setProperty(i, "select", false);
                }
                if (result.state.current >= 0)
                    playlistModel.setProperty(result.state.current, "select", true);
                Playlist.prototype.playing = result.state.playing == true ? true : false;
                Playlist.prototype.paused = result.state.paused == true ? true : false;
            }
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "AudioPlaylist.GetItems", "params": { "sort": {"method":"track", "order":"ascending"}, "fields": ["title", "artist", "album", "genre", "track", "duration", "thumbnail"] }, "id": 1}';
//    console.log(str);
    doc.send(str);
    return;

}

Playlist.prototype.cmd = function(cmd, media, param) {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            console.debug(doc.responseText);
            var error = JSON.parse(doc.responseText).error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "Playlist.prototype.update error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "'+ media + 'Playlist.'+cmd+'", ';
    if (param) {
        str += param + ","
    }
    str += '"id": 1}';
    doc.send(str);
    return;
}


function isEqual(a, b) {
    if (a.length == b.length){
        for (var i = 0; i < a.length; i++){
            if (a[i].label != b[i].label) {
                return false
            }
        }
        return true;
    }
    return false;
}
