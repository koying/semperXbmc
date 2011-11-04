/**
 * Player
 *
 */

function Player(typ) {
}

Player.prototype.getPlayers = function() {
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

//            var results = oJSON.result;
//            for (var i = 0; i < results.length; i++){
//                if (results[i].type == "audio")
//                    $().playlist.audioPlId = results[i].playlistid;
//                else if (results[i].type == "video")
//                    $().playlist.videoPlId = results[i].playlistid;
//                else if (results[i].type == "picture")
//                    $().playlist.picturePlId = results[i].playlistid;
//            }
        }
    }
    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "Player.GetActivePlayers", "id": 1}';
    doc.send(str);
    return;
}

Player.prototype.skipPrevious = function() {
    this.cmd("GoPrevious");
}

Player.prototype.playPause = function() {
    this.cmd("PlayPause");
}

Player.prototype.stop = function() {
    this.cmd("Stop");
}

Player.prototype.skipNext = function() {
    this.cmd("GoNext");
}

Player.prototype.seekPercentage = function(percent) {
    this.cmd("SeekPercentage", { value: percent.toFixed(0) } );
}

Player.prototype.seekTime = function(position) {
    this.cmd("SeekTime", { value: position.toFixed(0) } );
}

Player.prototype.cmd = function(cmd, param) {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var error = JSON.parse(doc.responseText).error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "Player.prototype.cmd error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var o = { jsonrpc: "2.0", method: "Player."+cmd, params: { playerid:0 }, id: 1};
    if (param) {
        o.params += param;
    }
    var str = JSON.stringify(o);
    console.log(str);
    doc.send(str);
    return;
}

Player.prototype.playFile = function(path) {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);
            var error = oJSON.error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "playFile error: ", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var o = { jsonrpc: "2.0", method: "Player.Open", params: { item: { file: path } }, id: 1};
    var str = JSON.stringify(o);
//    console.debug(str);
    doc.send(str);
    return;
}

