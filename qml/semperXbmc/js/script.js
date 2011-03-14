function playerCmd(cmd, param) {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            //console.log(doc.responseText);
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "AudioPlayer.'+cmd+'",';
    if (param) {
        str += param + ","
    }
    str += ' "id": 1}';
    doc.send(str);
    return;
}
