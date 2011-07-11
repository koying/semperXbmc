var xbmc;

function Xbmc() {
    this.server = "192.168.0.11";
    this.port = "8080";
    this.myvolume = 100;
}

Xbmc.prototype.init = function() {
//	if (touch) {
//		this.library.loadAllAlbums();
//	}
//	else {
//		this.library.loadArtists();
//	}
//    this.library.loadMovies();
//    this.library.loadTVShows();

    this.getVolume();
}

Xbmc.prototype.volumeUp = function() {
    Xbmc.prototype.myvolume += 10;
    if (Xbmc.prototype.myvolume > 100) {
        Xbmc.prototype.myvolume = 100;
    }
    Xbmc.prototype.setVolume(this.myvolume);
}

Xbmc.prototype.volumeDown = function() {
    Xbmc.prototype.myvolume -= 10;
    if (Xbmc.prototype.myvolume < 0) {
        Xbmc.prototype.myvolume = 0;
    }
    Xbmc.prototype.setVolume(this.myvolume);
}

Xbmc.prototype.setVolume = function(i) {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
//            console.log(doc.responseText);
            Xbmc.prototype.myvolume = JSON.parse(doc.responseText).result;
        }
    }
    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "XBMC.SetVolume", "params": ' + i + ', "id": 1}';
    doc.send(str);
    this.myvolume = i;
    return;
}



Xbmc.prototype.getVolume = function() {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
//            console.log(doc.responseText);
            Xbmc.prototype.myvolume = JSON.parse(doc.responseText).result;
        }
    }
    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "XBMC.GetVolume","id": 1}';
    doc.send(str);
    console.debug(str);
    return;
}



function setup() {
    xbmc = new Xbmc();
    return xbmc;
}


function isEqual(a, b) {
    if (a.length == b.length){
        for (var i = 0; i < a.length; i++){
            if (a[i].label != b[i].label) {
                return false
            }
        }
        return true;
    }
    return false;
}



function sort(a, b) {
    if (a.label > b.label) {
            return 1;
    }
    return -1;
}
