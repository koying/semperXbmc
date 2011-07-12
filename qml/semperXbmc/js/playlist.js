/**
 * Playlist
 *
 */


function debugObject(object) {
    var output = '';
    for (var prop in object) {
        output += prop + ': ' + object[prop]+'; ';
    }
    console.debug(output);
}

function Playlist() {
    this.playing = false;
    this.paused = false;
    this.items = null;
}

Playlist.prototype.insertTrack = function(idTrack){
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            //console.log(doc.responseText);
            if (!Playlist.prototype.playing) {
//                console.log("play");
                Playlist.prototype.cmd("Play", "Audio");
            }
        }
    }
    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "AudioPlaylist.Insert", "params": { "songid": '+idTrack+', "index": 0 }, "id": 1}';
//    console.log(str);
    doc.send(str);
    return;
}

Playlist.prototype.addTrack = function(idTrack){
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            //console.log(doc.responseText);
            if (!Playlist.prototype.playing) {
//                console.log("play");
                Playlist.prototype.cmd("Play", "Audio");
            }
        }
    }
    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "AudioPlaylist.Add", "params": { "songid": '+idTrack+' }, "id": 1}';
//    console.log(str);
    doc.send(str);
    return;
}

Playlist.prototype.insertAlbum = function(idalbum){
//    console.log("add");
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            //console.log(doc.responseText);
            if (!Playlist.prototype.playing) {
//                console.log("play");
                Playlist.prototype.cmd("Play", "Audio");
            }
        }
    }
    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "AudioPlaylist.Insert", "params": { "albumid": '+idalbum+', "index": 0 }, "id": 1}';
//    console.log(str);
    doc.send(str);
    return;
}


Playlist.prototype.addAlbum = function(idalbum){
//    console.log("add");
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            //console.log(doc.responseText);
            if (!Playlist.prototype.playing) {
//                console.log("play");
                Playlist.prototype.cmd("Play", "Audio");
            }
        }
    }
    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "AudioPlaylist.Add", "params": { "albumid": '+idalbum+' }, "id": 1}';
//    console.log(str);
    doc.send(str);
    return;
}

Playlist.prototype.addMovie = function(idmovie){
//    console.log("add movie");
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            console.log(doc.responseText);
            if (!Playlist.prototype.playing) {
                console.log("play");
                Playlist.prototype.cmd("Play", "Video");
            }
        }
    }
    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "VideoPlaylist.Add", "params": { "movieid": '+idmovie+' }, "id": 1}';
    doc.send(str);
    return;
}

Playlist.prototype.addEpisode = function(idepisode){
    console.log("add episode");
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            //console.log(doc.responseText);
            if (!Playlist.prototype.playing) {
//                console.log("play");
                Playlist.prototype.cmd("Play", "Video");
            }
        }
    }
    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "VideoPlaylist.Add", "params": { "episodeid": '+idepisode+' }, "id": 1}';
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
//            console.log(doc.responseText);
            var result = JSON.parse(doc.responseText).result;
            if ( result && result.items) {
                var items = result.items;
                // TODO Checken ob sich was geändert hat
                if (!Playlist.prototype.items || !isEqual(Playlist.prototype.items,items)) {
                    console.log("new playlist");
                    Playlist.prototype.items = items;
                    playlistModel.clear();
                    for (var i = 0; i < items.length; i++){
//                        debugObject(items[i]);
                        var thumb = "http://"+$().server+":" + $().port + "/images/DefaultAlbumCover.png";
                        if (items[i].thumbnail && items[i].thumbnail != "DefaultAlbumCover.png") {
                            thumb = "http://"+$().server+":" + $().port + "/vfs/" + items[i].thumbnail;
                        }
                        playlistModel.append({"name": items[i].label, "id": i, "select": false, "thumb": thumb, "artist": items[i].artist, "album": items[i].album, "duration": items[i].duration });
                    }
                }
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

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "AudioPlaylist.GetItems", "params": { "sort": {"method":"playlist", "order":"ascending"}, "fields": ["title", "album", "artist", "duration"] }, "id": 1}';
//    console.log(str);
    doc.send(str);
    return;

}

Playlist.prototype.cmd = function(cmd, media, param) {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            console.log(doc.responseText);
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
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
