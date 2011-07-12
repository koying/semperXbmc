var xbmc;

function Xbmc() {
}

Xbmc.prototype.server = "192.168.0.11";
Xbmc.prototype.port = "8080";

Xbmc.prototype.jsonRPCVer = "-1"

Xbmc.prototype.init = function() {
    this.getVersion();
}

Xbmc.prototype.getVersion = function() {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
//            console.log(doc.responseText);
            console.debug("JSON ver: " + Xbmc.prototype.jsonRPCVer);
            Xbmc.prototype.jsonRPCVer = JSON.parse(doc.responseText).result.version;
            console.debug("JSON ver: " + Xbmc.prototype.jsonRPCVer);
        }
    }
    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "JSONRPC.Version","id": 1}';
    doc.send(str);
//    console.debug(str);
    return;
}

