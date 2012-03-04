/**
 * Player
 *
 */

var oPlayer;

function Player(typ) {
    if (typ == "Audio")
        Player.prototype.playerId = 0;
    else if (typ == "Video")
        Player.prototype.playerId = 1;
    else if (typ == "Picture")
        Player.prototype.playerId = 2;

}

Player.prototype.playerId = -1;
Player.prototype.playing = false
Player.prototype.paused = false
Player.prototype.position = -1
Player.prototype.percentage = 0

Player.prototype.getPlayerProperties = function() {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            console.debug(doc.responseText);
            var oJSON = JSON.parse(doc.responseText);
            var error = oJSON.error;
            if (error) {
                Player.prototype.playing = false
                Player.prototype.paused = false
                return;
            }

            var results = oJSON.result;
            if (results.speed == 0)
                Player.prototype.paused = true;
            else
                Player.prototype.playing = true;
            Player.prototype.position = results.position
        }
    }

    var o = { jsonrpc: "2.0", method: "Player.GetProperties", params: { playerid:Player.prototype.playerId, properties: ["speed", "percentage", "time", "totaltime", "position"] }, id: 1};
    var str = JSON.stringify(o);
    console.log(str);
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
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            console.debug(doc.responseText)
            var error = JSON.parse(doc.responseText).error;
            if (error) {
                console.log(Utils.dumpObj(error, "Player.prototype.seekPercentage error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }
        }
    }


    var o = { jsonrpc: "2.0", method: "Player.Seek", params: { playerid:this.playerId, value:percent }, id: 1};
    var str = JSON.stringify(o);
    console.log(str);
    doc.send(str);
    return;
}

Player.prototype.seekTime = function(position) {
    this.cmd("SeekTime", { value: position.toFixed(0) } );
}

Player.prototype.batchcmd = function(cmd, param, id) {
    var o = { jsonrpc: "2.0", method: "Player."+cmd, params: { playerid:this.playerId }};
    if (id != null)
        o.id = id;
    if (param != null) {
        o.params += param;
    }
    var str = JSON.stringify(o);
    return str;
}

Player.prototype.cmd = function(cmd, param) {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var error = JSON.parse(doc.responseText).error;
            if (error) {
                console.log(Utils.dumpObj(error, "Player.prototype.cmd error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }
        }
    }

    doc.send(Player.prototype.batchcmd(cmd, param, 1));
    return;
}

Player.prototype.playFile = function(path) {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);
            var error = oJSON.error;
            if (error) {
                console.log(Utils.dumpObj(error, "playFile error: ", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }
        }
    }


    var o = { jsonrpc: "2.0", method: "Player.Open", params: { item: { file: path } }, id: 1};
    var str = JSON.stringify(o);
//    console.debug(str);
    doc.send(str);
    return;
}

