var xbmc;

function debugObject(object) {
    var output = '';
    for (var prop in object) {
        output += prop + ': ' + object[prop]+'; ';
    }
    console.log(output);
}

var MAX_DUMP_DEPTH = 10;
function dumpObj(obj, name, indent, depth) {
    if (depth > MAX_DUMP_DEPTH) {
        return indent + name + ": <Maximum Depth Reached>\n";
    }

    if (typeof obj == "object") {
        var child = null;
        var output = indent + name + "\n";
        indent += "\t";
        for (var item in obj)
        {
            try {
                child = obj[item];
            } catch (e) {
                child = "<Unable to Evaluate>";
            }
            if (typeof child == "object") {
                output += dumpObj(child, item, indent, depth + 1);
            } else {
                output += indent + item + ": " + child + "\n";
            }
        }
        return output;
    } else {
        return obj;
    }
}

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
            console.debug("JSON ver: " + Xbmc.prototype.jsonRPCVer);

            xbmcTcpClient.initialize(globals.server, globals.jsonTcpPort, Xbmc.prototype.jsonRPCVer);

            switch (Xbmc.prototype.jsonRPCVer) {
            case 2:  // Dharma
                xbmc.general = new General.General();
                xbmc.library = new Library.Library();
                xbmc.playlist = new Playlist.Playlist();
                xbmc.audioplayer = new Player.Player("Audio");
                xbmc.videoplayer = new Player.Player("Video");
                break;

            case 3:  // Eden
            case 4:
                xbmc.general = new General3.General();
                xbmc.library = new Library3.Library();
                xbmc.playlist = new Playlist3.Playlist();
                xbmc.audioplayer = new Player3.Player("Audio");
                xbmc.videoplayer = new Player3.Player("Video");
                break;

            default:
                return;
            }

            Xbmc.prototype.inError = false;
            main.jsonInitialized = true;
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
//                console.log(Xbmc.dumpObj(error, "perlmissions error", "", 0));
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

