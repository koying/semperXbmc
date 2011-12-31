/**
 * Playlist
 *
 */


function Playlist() {
    this.previousItems = {}
    this.playing = false;
    this.paused = false;
}

Playlist.prototype.addTrack = function(idTrack){
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);
            var error = oJSON.error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "Playlist.prototype.addTrack error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }
            if (!$().playlist.playing) {
//                console.log("play");
                $().playlist.cmd("Play", "Audio");
            }
        }
    }

    var str = '{"jsonrpc": "2.0", "method": "AudioPlaylist.Add", "params": { "songid": '+idTrack+' }, "id": 1}';
    console.log(str);
    doc.send(str);
    return;
}

Playlist.prototype.addAlbum = function(idalbum){
//    console.log("add");
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);
            var error = oJSON.error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "Playlist.prototype.addAlbum error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            if (!$().playlist.playing) {
//                console.log("play");
                $().playlist.cmd("Play", "Audio");
            }
        }
    }

    var str = '{"jsonrpc": "2.0", "method": "AudioPlaylist.Add", "params": { "albumid": '+idalbum+' }, "id": 1}';
//    console.log(str);
    doc.send(str);
    return;
}

Playlist.prototype.addMovie = function(idmovie){
//    console.log("add movie");
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);
            var error = oJSON.error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "Playlist.prototype.addMovie error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            if (!$().playlist.playing) {
                console.log("play");
                $().playlist.cmd("Play", "Video");
            }
        }
    }

    var str = '{"jsonrpc": "2.0", "method": "VideoPlaylist.Add", "params": { "movieid": '+idmovie+' }, "id": 1}';
    doc.send(str);
    return;
}

Playlist.prototype.addEpisode = function(idepisode){
    console.log("add episode");
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);
            var error = oJSON.error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "Playlist.prototype.addEpisode error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            if (!$().playlist.playing) {
//                console.log("play");
                $().playlist.cmd("Play", "Video");
            }
        }
    }

    var str = '{"jsonrpc": "2.0", "method": "VideoPlaylist.Add", "params": { "episodeid": '+idepisode+' }, "id": 1}';
    console.log(str);
    doc.send(str);
    return;
}

Playlist.prototype.videoClear = function(){
    Playlist.prototype.cmd("Clear", "Video");
    this.previousItems = {}
}

Playlist.prototype.audioClear = function(){
    Playlist.prototype.cmd("Clear", "Audio");
    this.previousItems = {}
}

Playlist.prototype.update = function(playlistModel){
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);

            var result = oJSON.result;
            if ( result && result.items) {
                var items = result.items;

                if (!$().playlist.previousItems || !isEqual($().playlist.previousItems,items)) {
//                    console.log("new playlist");
                    $().playlist.previousItems = items;
                    playlistModel.clear();
                    for (var i = 0; i < items.length; i++){

                        var thumb = "";
                        if (items[i].thumbnail && items[i].thumbnail != "" && items[i].thumbnail != "DefaultAlbumCover.png") {
                            thumb = "http://"+globals.getJsonAuthString()+$().server+":" + $().port + "/vfs/" + items[i].thumbnail;
                        }
                        playlistModel.append({"name": items[i].label, "id": i, "select": false, "thumb": thumb, "artist": items[i].artist, "album": items[i].album, "duration": items[i].duration });
                    }
                }
            } else {
                playlistModel.clear();
                $().playlist.playing = false;
                $().playlist.paused = false;
            }

            if (playlistModel.count > 0) {
                for (var i = 0; i < playlistModel.count; i++) {
                    playlistModel.setProperty(i, "select", false);
                }
                if (result.current >= 0)
                    playlistModel.setProperty(result.current, "select", true);
                $().playlist.playing = result.playing == true ? true : false;
                $().playlist.paused = result.paused == true ? true : false;
            }
        }
    }


    var str = '{"jsonrpc": "2.0", "method": "AudioPlaylist.GetItems", "params": { "sort": {"method":"playlist", "order":"ascending"}, "fields": ["title", "album", "artist", "duration"] }, "id": 1}';
//    console.log(str);
    doc.send(str);
    return;

}

Playlist.prototype.cmd = function(cmd, media, param) {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {

            var oJSON = JSON.parse(doc.responseText);
            var error = oJSON.error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "Playlist.prototype.cmd error: " + cmd, "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }
        }
    }


    var str = '{"jsonrpc": "2.0", "method": "'+ media + 'Playlist.'+cmd+'", ';
    if (param) {
        str += param + ","
    }
    str += '"id": 1}';
    console.log(str);
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
