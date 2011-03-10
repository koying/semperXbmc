var xbmc;

function Xbmc() {
	this.server = "192.168.0.11";
	this.port = "8080";
}

Xbmc.prototype.init = function() {
	if (touch) {
		this.library.loadAllAlbums();
	}
	else {
		this.library.loadArtists();
	}
	this.library.loadMovies();
	this.library.loadTVShows();

	this.getVolume();
}

Xbmc.prototype.show = function(str) {
	media.state = str
	if (container.state != "content") {
		container.state = "content"
	}
}

Xbmc.prototype.back = function() {
	var n = false;
	switch(media.state) {
		case "video":
			n = videoComponent.back();
		break;
		case "music":
			n = musicComponent.back();
		break;
		default:
			n = true;
		break;
	}
	if (n) {
		container.state = "";
	}
}

Xbmc.prototype.media = function() {
	var n = false;
	switch(media.state) {
		case "video":
			return "Video";
		break;
		case "music":
			return "Audio"
		break;
		default:
			return "Audio"
		break;
	}
}

Xbmc.prototype.volumeUp = function() {
	console.log("up");
	this.volume += 10;
	if (this.volume > 100) {
		this.volume = 100;
	}
	this.setVolume(this.volume);
}

Xbmc.prototype.volumeDown = function() {
	console.log("down");
	this.volume -= 10;
	if (this.volume < 0) {
		this.volume = 0;
	}
	this.setVolume(this.volume);
}

Xbmc.prototype.setVolume = function(i) {
	var doc = new XMLHttpRequest();
	doc.onreadystatechange = function() {
		if (doc.readyState == XMLHttpRequest.DONE) {
			console.log(doc.responseText);
			$().volume = JSON.parse(doc.responseText).result;
		}
	}
	doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
	var str = '{"jsonrpc": "2.0", "method": "AudioPlaylist.GetItems", "params": { "fields": ["title", "album", "artist", "duration"] }, "id": 1}';
	var str = '{"jsonrpc": "2.0", "method": "XBMC.SetVolume", "params": ' + i + ', "id": 1}';
	doc.send(str);
	console.log(str);
	this.volume = i;
	return;
}



Xbmc.prototype.getVolume = function() {
	var doc = new XMLHttpRequest();
	doc.onreadystatechange = function() {
		if (doc.readyState == XMLHttpRequest.DONE) {
			console.log(doc.responseText);
			$().volume = JSON.parse(doc.responseText).result;
		}
	}
	doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
	var str = '{"jsonrpc": "2.0", "method": "XBMC.GetVolume","id": 1}';
	doc.send(str);
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
