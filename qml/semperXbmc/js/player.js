/**
 * Player
 *
 */

function Player(typ) {
    this.type=typ;
}

Player.prototype.skipPrevious = function() {
    this.cmd("SkipPrevious");
}

Player.prototype.playPause = function() {
    this.cmd("PlayPause");
}

Player.prototype.stop = function() {
    this.cmd("Stop");
}

Player.prototype.skipNext = function() {
    this.cmd("SkipNext");
}

Player.prototype.seekPercentage = function(percent) {
    this.cmd("SeekPercentage", '"value":'+percent);
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

    
    var str = '{"jsonrpc": "2.0", "method": "'+this.type+'Player.'+cmd+'",';
    if (param) {
        str += param + ","
    }
    str += ' "id": 1}';
//	console.log(str);
    doc.send(str);
    return;
}
