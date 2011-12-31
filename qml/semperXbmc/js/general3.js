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
                console.log(Xbmc.dumpObj(error, "setVolume error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            General.prototype.volume = oJSON.result;
        }
    }
    
    var str = '{"jsonrpc": "2.0", "method": "Application.SetVolume", "params": ' + i + ', "id": 1}';
    doc.send(str);
    General.prototype.volume = i;
    return;
}



General.prototype.getVolume = function() {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            console.log(doc.responseText);
            var oJSON = JSON.parse(doc.responseText);

            var error = oJSON.error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "getVolume error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }
            General.prototype.volume = oJSON.result.volume;
        }
    }
    
    var str = '{"jsonrpc": "2.0", "method": "Application.GetProperties", "params": { "properties": ["volume"] }, "id": 1}';
    doc.send(str);

    return;
}
