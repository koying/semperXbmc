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
    this.playing = false;
    this.paused = false;
    this.onVideoStarted = null

    this.videoPlId = -1;
    this.audioPlId = -1;
    this.picturePlId = -1;

    Playlist.prototype.getPlaylists();
}

Playlist.prototype.getPlaylists = function(){
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
//            console.debug(doc.responseText);
            var oJSON = JSON.parse(doc.responseText);
            var error = oJSON.error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "Playlist.prototype.insertTrack error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            var results = oJSON.result;
            for (var i = 0; i < results.length; i++){
                if (results[i].type == "audio")
                    $().playlist.audioPlId = results[i].playlistid;
                else if (results[i].type == "video")
                    $().playlist.videoPlId = results[i].playlistid;
                else if (results[i].type == "picture")
                    $().playlist.picturePlId = results[i].playlistid;
            }
        }
    }
    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "Playlist.GetPlaylists", "id": 1}';
    doc.send(str);
    return;
}

Playlist.prototype.insertTrack = function(idTrack){
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);
            var error = oJSON.error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "Playlist.prototype.insertTrack error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            if (!$().playlist.playing) {
//                console.log("play");
                $().playlist.playAudio();
            }
        }
    }
    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var o = { jsonrpc: "2.0", method: "Playlist.Insert", params: { playlistid: $().playlist.audioPlId, item: { songid: idTrack }, position: 0 }, id: 1};
    var str = JSON.stringify(o);
    doc.send(str);
    return;
}

Playlist.prototype.addTrack = function(idTrack){
    var doc = new XMLHttpRequest();
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
                $().playlist.playAudio();
            }
        }
    }
    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var o = { jsonrpc: "2.0", method: "Playlist.Add", params: { playlistid: $().playlist.audioPlId, item: { songid: idTrack } }, id: 1};
    var str = JSON.stringify(o);
    doc.send(str);
    return;
}

Playlist.prototype.insertAlbum = function(idalbum){
//    console.log("add");
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);
            var error = oJSON.error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "Playlist.prototype.insertAlbum error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            if (!$().playlist.playing) {
//                console.log("play");
                $().playlist.playAudio();
            }
        }
    }
    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var o = { jsonrpc: "2.0", method: "Playlist.Insert", params: { playlistid: $().playlist.audioPlId, item: { albumid: idalbum }, position: 0 }, id: 1};
    var str = JSON.stringify(o);
    doc.send(str);
    return;
}


Playlist.prototype.addAlbum = function(idalbum){
//    console.log("add");
    var doc = new XMLHttpRequest();
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
                $().playlist.playAudio();
            }
        }
    }
    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var o = { jsonrpc: "2.0", method: "Playlist.Add", params: { playlistid: $().playlist.audioPlId, item: { albumid: idalbum } }, id: 1};
    var str = JSON.stringify(o);
    doc.send(str);
    return;
}

Playlist.prototype.addMovie = function(idmovie){
//    console.log("add movie");
    var doc = new XMLHttpRequest();
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
//                console.log("play");
                $().playlist.playVideo();
            }
        }
    }
    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var o = { jsonrpc: "2.0", method: "Playlist.Add", params: { playlistid: $().playlist.videoPlId, item: { movieid: idmovie } }, id: 1};
    var str = JSON.stringify(o);
    doc.send(str);
    return;
}

Playlist.prototype.addEpisode = function(idepisode){
    console.log("add episode");
    var doc = new XMLHttpRequest();
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
                $().playlist.playVideo();
            }
        }
    }
    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var o = { jsonrpc: "2.0", method: "Playlist.Add", params: { playlistid: $().playlist.videoPlId, item: { episodeid: idepisode } }, id: 1};
    var str = JSON.stringify(o);
    doc.send(str);
    return;
}

Playlist.prototype.videoClear = function(){
    Playlist.prototype.cmd("Clear", $().playlist.videoPlId);
    this.previousItems = {}
}

Playlist.prototype.audioClear = function(){
    Playlist.prototype.cmd("Clear", $().playlist.audioPlId);
    this.previousItems = {}
}

Playlist.prototype.update = function(playlistModel){
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
//            console.debug(doc.responseText)
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

                if (!$().playlist.previousItems || !isEqual($().playlist.previousItems,items)) {
//                    console.log("new playlist");
                    $().playlist.previousItems = items;
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
                $().playlist.playing = false;
                $().playlist.paused = false;
            }

            if (result.state && playlistModel.count > 0) {
                for (var i = 0; i < playlistModel.count; i++) {
                    playlistModel.setProperty(i, "select", false);
                }
                if (result.state.current >= 0)
                    playlistModel.setProperty(result.state.current, "select", true);
                $().playlist.playing = result.state.playing == true ? true : false;
                $().playlist.paused = result.state.paused == true ? true : false;
            }
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "Playlist.GetItems", "params": { "playlistid":' + $().playlist.audioPlId + ', "sort": {"method":"playlist", "order":"ascending"}, "properties": ["title", "artist", "album", "genre", "track", "duration", "thumbnail"] }, "id": 1}';
//    console.log(str);
    doc.send(str);
    return;

}

Playlist.prototype.cmd = function(cmd, media, param) {
    var doc = new XMLHttpRequest();
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

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "Playlist.'+cmd+'", "params": {';
    if (param) {
        str += param + ","
    }
    str += '"playlistid":'+ media + '}, "id": 1}';
    doc.send(str);
    return;
}

Playlist.prototype.playVideo = function() {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);
            var error = oJSON.error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "playVideo error: ", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }
            if ($().playlist.onVideoStarted) {
                console.log("onVideoStarted");
                $().playlist.onVideoStarted();
            }
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var o = { jsonrpc: "2.0", method: "Player.Open", params: { item: { playlistid: $().playlist.videoPlId } }, id: 1};
    var str = JSON.stringify(o);
    doc.send(str);
    return;
}

Playlist.prototype.playAudio = function() {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);
            var error = oJSON.error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "playAudio error: ", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var o = { jsonrpc: "2.0", method: "Player.Open", params: { item: { playlistid: $().playlist.audioPlId } }, id: 1};
    var str = JSON.stringify(o);
    doc.send(str);
    return;
}

