function General() {
    this.getVolume();
}

General.prototype.volume = 100;

General.prototype.volumeUp = function() {
    General.prototype.volume += 10;
    if (General.prototype.volume > 100) {
        General.prototype.volume = 100;
    }
    General.prototype.setVolume(this.volume);
}

General.prototype.volumeDown = function() {
    General.prototype.volume -= 10;
    if (General.prototype.volume < 0) {
        General.prototype.volume = 0;
    }
    General.prototype.setVolume(this.volume);
}

General.prototype.setVolume = function(i) {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);

            var error = oJSON.error;
            if (error) {
                console.log(Utils.dumpObj(error, "setVolume error", "", 0));
                return;
            }

            General.prototype.volume = oJSON.result;
        }
    }

    var str = '{"jsonrpc": "2.0", "method": "XBMC.SetVolume", "params": ' + i + ', "id": 1}';
    doc.send(str);
    General.prototype.volume = i;
    return;
}



General.prototype.getVolume = function() {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);

            var error = oJSON.error;
            if (error) {
                console.log(Utils.dumpObj(error, "getVolume error", "", 0));
                return;
            }
            General.prototype.volume = oJSON.result;
        }
    }

    var str = '{"jsonrpc": "2.0", "method": "XBMC.GetVolume","id": 1}';
    doc.send(str);
//    console.debug(str);
    return;
}
