/**
 * Playlist
 *
 */

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

function Playlist() {
    this.previousItems = {}

    this.onPlaylistChanged = null
    this.onPlaylistStarted = null

    this.videoPlId = -1;
    this.audioPlId = -1;
    this.picturePlId = -1;

    Playlist.prototype.getPlaylists();
}

Playlist.prototype.getPlaylistSize = function(id) {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
//            console.debug(doc.responseText);
            var oJSON = JSON.parse(doc.responseText);
            var error = oJSON.error;
            if (error) {
                console.log(Utils.dumpObj(error, "Playlist.prototype.getPlaylistSize error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            var results = oJSON.result;
            if (results.type == "audio") {
                $().playlist.audioPlId = id;
                audioPlId = $().playlist.audioPlId
            } else if (results.type == "video") {
                $().playlist.videoPlId = id;
                videoPlId = $().playlist.videoPlId
            } else if (results.type == "pictures") {
                $().playlist.picturePlId = id;
            }

        }
    }

    var o = { jsonrpc: "2.0", method: "Playlist.GetProperties", params: { playlistid: id, properties: ["type", "size"] }, id: 1};
    var str = JSON.stringify(o);
    doc.send(str);
    return;
}


Playlist.prototype.getPlaylists = function(){
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
//            console.debug(doc.responseText);
            var oJSON = JSON.parse(doc.responseText);
            var error = oJSON.error;
            if (error) {
                console.log(Utils.dumpObj(error, "Playlist.prototype.insertTrack error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            var results = oJSON.result;
            for (var i = 0; i < results.length; i++){
                Playlist.prototype.getPlaylistSize(results[i].playlistid)
            }
        }
    }

    var str = '{"jsonrpc": "2.0", "method": "Playlist.GetPlaylists", "id": 1}';
    doc.send(str);
    return;
}

Playlist.prototype.insertTrack = function(idTrack){
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);
            var error = oJSON.error;
            if (error) {
                console.log(Utils.dumpObj(error, "Playlist.prototype.insertTrack error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            if ($().playlist.onPlaylistChanged) {
                $().playlist.onPlaylistChanged($().playlist.audioPlId)
            }
        }
    }

    var o = { jsonrpc: "2.0", method: "Playlist.Insert", params: { playlistid: $().playlist.audioPlId, item: { songid: idTrack }, position: 0 }, id: 1};
    var str = JSON.stringify(o);
    doc.send(str);
    return;
}

Playlist.prototype.addTrack = function(idTrack){
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);
            var error = oJSON.error;
            if (error) {
                console.log(Utils.dumpObj(error, "Playlist.prototype.addTrack error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            if ($().playlist.onPlaylistChanged) {
                $().playlist.onPlaylistChanged($().playlist.audioPlId)
            }
        }
    }

    var o = { jsonrpc: "2.0", method: "Playlist.Add", params: { playlistid: $().playlist.audioPlId, item: { songid: idTrack } }, id: 1};
    var str = JSON.stringify(o);
    doc.send(str);
    return;
}

Playlist.prototype.insertAlbum = function(idalbum){
//    console.log("add");
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);
            var error = oJSON.error;
            if (error) {
                console.log(Utils.dumpObj(error, "Playlist.prototype.insertAlbum error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            if ($().playlist.onPlaylistChanged) {
                $().playlist.onPlaylistChanged($().playlist.audioPlId)
            }
        }
    }

    var o = { jsonrpc: "2.0", method: "Playlist.Insert", params: { playlistid: $().playlist.audioPlId, item: { albumid: idalbum }, position: 0 }, id: 1};
    var str = JSON.stringify(o);
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
                console.log(Utils.dumpObj(error, "Playlist.prototype.addAlbum error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            if ($().playlist.onPlaylistChanged) {
                $().playlist.onPlaylistChanged($().playlist.audioPlId)
            }
        }
    }

    var o = { jsonrpc: "2.0", method: "Playlist.Add", params: { playlistid: $().playlist.audioPlId, item: { albumid: idalbum } }, id: 1};
    var str = JSON.stringify(o);
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
                console.log(Utils.dumpObj(error, "Playlist.prototype.addMovie error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            if ($().playlist.onPlaylistChanged) {
                $().playlist.onPlaylistChanged($().playlist.videoPlId)
            }
        }
    }

    var o = { jsonrpc: "2.0", method: "Playlist.Add", params: { playlistid: $().playlist.videoPlId, item: { movieid: idmovie } }, id: 1};
    var str = JSON.stringify(o);
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
                console.log(Utils.dumpObj(error, "Playlist.prototype.addEpisode error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            if ($().playlist.onPlaylistChanged) {
                $().playlist.onPlaylistChanged($().playlist.videoPlId)
            }
        }
    }

    var o = { jsonrpc: "2.0", method: "Playlist.Add", params: { playlistid: $().playlist.videoPlId, item: { episodeid: idepisode } }, id: 1};
    var str = JSON.stringify(o);
    doc.send(str);
    return;
}


Playlist.prototype.clear = function(id){
    Playlist.prototype.cmd("Clear", id, null, null);
    this.previousItems = {}
}

Playlist.prototype.videoClear = function(){
    Playlist.prototype.clear($().playlist.videoPlId);
}

Playlist.prototype.audioClear = function(){
    Playlist.prototype.clear($().playlist.audioPlId);
}

Playlist.prototype.update = function(id, playlistModel){
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
//            console.debug(doc.responseText)
            var oJSON = JSON.parse(doc.responseText);
            var error = oJSON.error;
            if (error) {
                console.log(Utils.dumpObj(error, "Playlist.prototype.update error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

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
                        var number = 0
                        if (items[i].episode)
                            number = items[i].episode
                        else if (items[i].track)
                            number = items[i].track
                        playlistModel.append({"name": items[i].label, "id": i, "select": false, "thumb": thumb, "artist": items[i].artist, "album": items[i].album, "duration": items[i].duration, "showtitle": items[i].showtitle, "playcount": items[i].playcount, "number": number});
                    }
                }
            } else {
                playlistModel.clear();
            }
        }
    }


            var str = '{"jsonrpc": "2.0", "method": "Playlist.GetItems", "params": { "playlistid":' + id + ', "sort": {"method":"playlist", "order":"ascending"}, "properties": ["title", "artist", "album", "genre", "track", "duration", "thumbnail", "showtitle", "episode", "playcount"] }, "id": 1}';
//    console.log(str);
    doc.send(str);
    return;

}

Playlist.prototype.batchcmd = function(cmd, playlistId, param, id) {
    var o = { jsonrpc: "2.0", method: "Playlist."+cmd, params: { playlistid:playlistId }};
    if (id != null)
        o.id = id;
    if (param != null) {
        o.params += param;
    }
    var str = JSON.stringify(o);
    return str;
}

Playlist.prototype.cmd = function(cmd, media, param) {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);
            var error = oJSON.error;
            if (error) {
                console.log(Utils.dumpObj(error, "Playlist.prototype.cmd error: " + cmd, "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }
        }
    }

    doc.send(Playlist.prototype.batchcmd(cmd, media, param, 1));
    return;
}

Playlist.prototype.play = function(id) {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);
            var error = oJSON.error;
            if (error) {
                console.log(Utils.dumpObj(error, "play error: ", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            if ($().playlist.onPlaylistStarted) {
                $().playlist.onPlaylistStarted(id)
            }
        }
    }


    var o = { jsonrpc: "2.0", method: "Player.Open", params: { item: { playlistid: id } }, id: 1};
    var str = JSON.stringify(o);
            console.debug(str)
    doc.send(str);
    return;
}

Playlist.prototype.playVideo = function() {
    Playlist.prototype.play($().playlist.videoPlId)
}

Playlist.prototype.playAudio = function() {
    Playlist.prototype.play($().playlist.audioPlId)
}

