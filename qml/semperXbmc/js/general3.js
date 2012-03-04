function General() {
    this.getVolume();
}

General.prototype.volumeUp = function() {
    main.volume += 10;
    if (main.volume > 100) {
        main.volume = 100;
    }
    General.prototype.setVolume(main.volume);
}

General.prototype.volumeDown = function() {
    main.volume -= 10;
    if (main.volume < 0) {
        main.volume = 0;
    }
    General.prototype.setVolume(this.volume);
}

General.prototype.setVolume = function(vol) {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);

            var error = oJSON.error;
            if (error) {
                console.log(Utils.dumpObj(error, "setVolume error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            main.volume = oJSON.result;
        }
    }
    
    var str = '{"jsonrpc": "2.0", "method": "Application.SetVolume", "params": { "volume":' + vol + ' }, "id": 1}';
//    console.debug(str)
    doc.send(str);
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
                console.log(Utils.dumpObj(error, "getVolume error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }
            main.volume = oJSON.result.volume;
            main.muted = oJSON.result.muted;
        }
    }
    
    var str = '{"jsonrpc": "2.0", "method": "Application.GetProperties", "params": { "properties": ["volume", "muted"] }, "id": 1}';
    doc.send(str);

    return;
}

General.prototype.setMute = function(mute) {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            console.debug(doc.responseText)
            var oJSON = JSON.parse(doc.responseText);

            var error = oJSON.error;
            if (error) {
                console.log(Utils.dumpObj(error, "setMute error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            main.muted = oJSON.result;
        }
    }

    var str = '{"jsonrpc": "2.0", "method": "Application.SetMute", "params": { "mute":' + mute + ' }, "id": 1}';
    console.debug(str)
    doc.send(str);
    return;
}
