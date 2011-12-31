function playerCmd(cmd, param) {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            //console.log(doc.responseText);
        }
    }

    
    var str = '{"jsonrpc": "2.0", "method": "AudioPlayer.'+cmd+'",';
    if (param) {
        str += param + ","
    }
    str += ' "id": 1}';
    doc.send(str);
    return;
}

