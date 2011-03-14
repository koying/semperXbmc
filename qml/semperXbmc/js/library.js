function Library() {

}

Library.prototype.loadAlbums = function (idartist) {
    albumModel.clear();
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            //console.log(doc.responseText);

            var result = JSON.parse(doc.responseText).result;
            var albums = result.albums;
            for (var i = 0; i < albums.length; i++){
                //console.log(albums[i].thumb)
                var thumb = "http://"+$().server+":" + $().port + "/images/DefaultAlbumCover.png";
                if (albums[i].thumbnail) {
                    thumb = "http://"+$().server+":" + $().port + "/vfs/" + albums[i].thumbnail;
                }

                albumModel.append({"idalbum": albums[i].albumid, "name": albums[i].label, "thumb": thumb});
            }
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "AudioLibrary.GetAlbums", "params": { "start": 0, "fields": ["album_description", "album_theme", "album_mood", "album_style", "album_type", "album_label", "album_artist", "album_genre", "album_rating", "album_title"], "artistid": '+idartist+' }, "id": 1}';
    doc.send(str);

    return;
 }

Library.prototype.loadMovies = function () {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
//            console.log(doc.responseText);

            var result = JSON.parse(doc.responseText).result;
            var movies = result.movies;
            for (var i = 0; i < movies.length; i++){
                //console.log(movies[i].thumb)
                var thumb = "http://"+$().server+":" + $().port + "/images/DefaultAlbumCover.png";
                if (movies[i].thumbnail) {
                    thumb = "http://"+$().server+":" + $().port + "/vfs/" + movies[i].thumbnail;
                }

                movieModel.append({"id": movies[i].movieid, "name": movies[i].label, "thumb": thumb, "genre":  movies[i].genre, "duration": movies[i].duration, "runtime": movies[i].runtime, "rating": movies[i].rating, "playcount":movies[i].playcount});
            }
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetMovies", "params": { "start": 0, "sort": {"method":"sorttitle", "order":"ascending"}, "fields": ["genre", "director", "trailer", "tagline", "plot", "plotoutline", "title", "originaltitle", "lastplayed", "showtitle", "firstaired", "duration", "season", "episode", "runtime", "year", "playcount", "rating"] }, "id": 1}';
    doc.send(str);

    return;
 }

Library.prototype.loadTVShows = function () {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {

            var result = JSON.parse(doc.responseText).result;
            var tvshows = result.tvshows;
            for (var i = 0; i < tvshows.length; i++){
                //console.log(movies[i].thumb)
                var thumb = "http://"+$().server+":" + $().port + "/images/DefaultAlbumCover.png";
                if (tvshows[i].thumbnail) {
                    thumb = "http://"+$().server+":" + $().port + "/vfs/" + tvshows[i].thumbnail;
                }

                tvshowModel.append({"id": tvshows[i].tvshowid, "name": tvshows[i].label, "thumb": thumb, "genre":  tvshows[i].genre, "duration": tvshows[i].duration, "rating": tvshows[i].rating, "playcount":tvshows[i].playcount});
            }
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetTVShows", "params": { "start": 0, "sort": {"method":"sorttitle", "order":"ascending"}, "fields": ["genre", "director", "trailer", "tagline", "plot", "plotoutline", "title", "originaltitle", "lastplayed", "showtitle", "firstaired", "duration", "season", "episode", "runtime", "year", "playcount", "rating"] }, "id": 1}';
    doc.send(str);

    return;
 }

Library.prototype.loadSeasons = function (id) {
    this.idtvshow = id;
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
//            console.log(doc.responseText);

            var result = JSON.parse(doc.responseText).result;
            var seasons = result.seasons;
            for (var i = 0; i < seasons.length; i++){
                //console.log(movies[i].thumb)
                var thumb = "http://"+$().server+":" + $().port + "/images/DefaultAlbumCover.png";
                if (seasons[i].thumbnail) {
                    thumb = "http://"+$().server+":" + $().port + "/vfs/" + seasons[i].thumbnail;
                }
                seasonModel.append({"id": seasons[i].season, "name": seasons[i].label, "thumb": thumb, "episodes":seasons[i].episode, "genre":  seasons[i].genre, "duration": seasons[i].duration, "rating": seasons[i].rating, "playcount":seasons[i].playcount});
            }
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetSeasons", "params": { "start": 0, "tvshowid":'+ id +', "fields": ["genre", "director", "trailer", "tagline", "plot", "plotoutline", "title", "originaltitle", "lastplayed", "showtitle", "firstaired", "duration", "season", "episode", "runtime", "year", "playcount", "rating"] }, "id": 1}';
    doc.send(str);

    return;
 }


Library.prototype.loadEpisodes = function (id) {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
//            console.log(doc.responseText);
            episodeModel.clear();
            var result = JSON.parse(doc.responseText).result;
            var episodes = result.episodes;
            for (var i = 0; i < episodes.length; i++){
                //console.log(movies[i].thumb)
                var thumb = "http://"+$().server+":" + $().port + "/images/DefaultAlbumCover.png";
                if (episodes[i].thumbnail) {
                    thumb = "http://"+$().server+":" + $().port + "/vfs/" + episodes[i].thumbnail;
                }

                episodeModel.append({"id": episodes[i].episodeid, "name": episodes[i].label, "thumb": thumb, "number":  episodes[i].episode, "duration": episodes[i].duration, "rating": episodes[i].rating, "playcount":episodes[i].playcount});
            }
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetEpisodes", "params": { "start": 0, "tvshowid":'+ this.idtvshow +', "season":'+ id +', "fields": ["genre", "director", "trailer", "tagline", "plot", "plotoutline", "title", "originaltitle", "lastplayed", "showtitle", "firstaired", "duration", "episode", "year", "playcount", "rating"] }, "id": 1}';
    doc.send(str);

    return;
 }

Library.prototype.loadTracks = function (idalbum) {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            trackModel.clear();
            //console.log(doc.responseText);

            var result = JSON.parse(doc.responseText).result;
            var songs = result.songs;
            for (var i = 0; i < songs.length; i++){
                //console.log(albums[i].thumb)
                trackModel.append({"idtrack": songs[i].trackid, "name": songs[i].label, "number": songs[i].tracknumber});
            }
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "AudioLibrary.GetSongs", "params": { "fields": ["title", "artist", "genre", "tracknumber", "discnumber", "duration", "year"], "albumid" : '+idalbum+' }, "id": 1}';
    doc.send(str);

    return;
 }

Library.prototype.loadAllAlbums = function () {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            //console.log(doc.responseText);

            var result = JSON.parse(doc.responseText).result;
            var albums = result.albums;
            for (var i = 0; i < albums.length; i++){
                //console.log(albums[i].thumb)
                var thumb = "http://"+$().server+":" + $().port + "/images/DefaultAlbumCover.png";
                if (albums[i].thumbnail) {
                    thumb = "http://"+$().server+":" + $().port + "/vfs/" + albums[i].thumbnail;
                }

                albumModel.append({"idalbum": albums[i].albumid, "name": albums[i].label, "thumb": thumb});
            }
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "AudioLibrary.GetAlbums", "params": { "start": 0, "fields": ["album_description", "album_theme", "album_mood", "album_style", "album_type", "album_label", "album_artist", "album_genre", "album_rating", "album_title"]}, "id": 1}';
    doc.send(str);

    return;
 }

Library.prototype.loadArtists = function() {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var result = JSON.parse(doc.responseText).result;
            var artists = result.artists;
            artists.sort(sort);
            $().library.artists = artists;
            for (var i = 0; i < artists.length; i++){
                artistModel.append({"id": artists[i].artistid, "name": artists[i].label, "thumb": "http://"+$().server+":" + $().port + "vfs/" + artists[i].fanart, "selected": false});
            }
//            console.log("loading artists done")
        }
    }
    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    doc.send('{"jsonrpc": "2.0", "method": "AudioLibrary.GetArtists", "id": 1}');
}

Library.prototype.search = function(str) {
    for (var i = 0; i < this.artists.length; i++){
        if (this.artists[i].label.substr(0, str.length).toLowerCase() == str) {
            return i;
        }
    }
    return 0;
}

function sort(a, b) {
    if (a.label > b.label) {
            return 1;
    }
    return -1;
}
