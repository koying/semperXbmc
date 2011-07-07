/**
 * Playlist
 *
 */
function Playlist() {
    var playing = false;
    var items;
}

Playlist.prototype.addAlbum = function(idalbum){
//    console.log("add");
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            //console.log(doc.responseText);
            if (!$().playlist.playing) {
//                console.log("play");
                $().playlist.cmd("Play", "Audio");
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
            if (!$().playlist.playing) {
                console.log("play");
                $().playlist.cmd("Play", "Video");
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
            if (!$().playlist.playing) {
//                console.log("play");
                $().playlist.cmd("Play", "Video");
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
    this.cmd("Clear", "Video");
}

Playlist.prototype.audioClear = function(){
    this.cmd("Clear", "Audio");
}

Playlist.prototype.update = function(playlistModel){
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            //console.log(doc.responseText);
            var result = JSON.parse(doc.responseText).result;
            if ( result && result.items) {
                var items = result.items;
                // TODO Checken ob sich was geändert hat
                if (!$().playlist.items || !isEqual($().playlist.items,items)) {
                    console.log("new playlist");
                    $().playlist.items = items;
//                    playlistModel.clear();
                    for (var i = 0; i < items.length; i++){
                        var thumb = "http://"+$().server+":" + $().port + "/images/DefaultAlbumCover.png";
                        if (items[i].thumbnail && items[i].thumbnail != "DefaultAlbumCover.png") {
                            thumb = "http://"+$().server+":" + $().port + "/vfs/" + items[i].thumbnail;
                        }
                        playlistModel.append({"name": items[i].label, "id": i, "select": false, "thumb": thumb, "artist": items[i].artist, "album": items[i].album});
                    }
                }
            }
            if (playlistModel.count > 0) {
                for (var i = 0; i < playlistModel.count; i++) {
                    playlistModel.setProperty(i, "select", false);
                }
                //console.log(result.current);
                playlistModel.setProperty(result.current, "select", true);
                //$().playlist.current = result.current
                //playlistModel.get(result.current).focus = true;
                //console.log(playlistModel.getProperty(result.current, "selected"));
                $().playlist.playing = result.playing;
                //result.current);
            }
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "AudioPlaylist.GetItems", "params": { "fields": ["title", "album", "artist", "duration"] }, "id": 1}';
    //console.log(str);
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
