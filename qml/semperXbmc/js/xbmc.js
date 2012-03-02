var xbmc;

function Xbmc() {
}

Xbmc.prototype.server = "192.168.0.11";
Xbmc.prototype.port = "8080";

Xbmc.prototype.jsonRPCVer = "-1"
Xbmc.prototype.inError = false

Xbmc.prototype.init = function() {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            if (doc.status != 200) {
                if (!Xbmc.prototype.inError) {
                    console.log("Error " + doc.status + " connecting to XBMC: " + xbmc.server +":" + xbmc.port);
                    errorView.addError("error", "Cannot connect to JSON-RPC: " + xbmc.server +":" + xbmc.port);
                    Xbmc.prototype.inError = true;
                }
                jsonRetryTimer.running = true;
                return;
            }

            Xbmc.prototype.jsonRPCVer = JSON.parse(doc.responseText).result.version;
            console.debug("Connected to: " + xbmc.server+":"+xbmc.port);
            console.debug("JSON ver: " + Xbmc.prototype.jsonRPCVer);

            xbmcTcpClient.initialize(globals.server, globals.jsonTcpPort, Xbmc.prototype.jsonRPCVer);

            switch (Xbmc.prototype.jsonRPCVer) {
            case 2:  // Dharma
                xbmc.general = new General.General();
                xbmc.library = new Library.Library();
                xbmc.playlist = new Playlist.Playlist();
                break;

            case 3:  // Eden
            case 4:
                xbmc.general = new General3.General();
                xbmc.library = new Library3.Library();
                xbmc.playlist = new Playlist3.Playlist();
                break;

            default:
                return;
            }

            Xbmc.prototype.inError = false;
            main.jsonInitialized = true;
            jsonRetryTimer.running = false;
        }
    }
    var str = '{"jsonrpc": "2.0", "method": "JSONRPC.Version","id": 1}';
    doc.send(str);

//    var docPerm = new XMLHttpRequest();
//    docPerm.onreadystatechange = function() {
//        if (docPerm.readyState == XMLHttpRequest.DONE) {
//            var oJSON = JSON.parse(docPerm.responseText);

//            var error = oJSON.error;
//            if (error) {
//                console.log(Utils.dumpObj(error, "perlmissions error", "", 0));
//                errorView.addError("error", error.message, error.code);
//                return;
//            }

//            console.log(docPerm.responseText);
//        }
//    }
//    docPerm.open("POST", "http://"+xbmc.server+":" + xbmc.port + "/jsonrpc");
//    str = '{"jsonrpc": "2.0", "method": "JSONRPC.Permission","id": 1}';
//    docPerm.send(str);
}

Xbmc.prototype.introspect = function() {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
//            console.debug(doc.responseText);
            if (doc.status != 200) {
                console.log("Error " + doc.status + " connecting to XBMC: " + xbmc.server +":" + xbmc.port);
                errorView.addError("error", "Cannot connect to JSON-RPC: " + xbmc.server +":" + xbmc.port);
                Xbmc.prototype.inError = true;
                return;
            }

            var oJSON = JSON.parse(doc.responseText).result;
            console.debug(dumpObj(oJSON, "JSON introspect", "", 0));
        }
    }
    var str = '{"jsonrpc": "2.0", "method": "JSONRPC.Introspect","id": 1}';
    doc.send(str);
}

