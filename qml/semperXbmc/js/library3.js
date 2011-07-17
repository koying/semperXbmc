
function Library() {
}

Library.prototype.loadMovies = function () {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
//            console.log(doc.responseText);

            var error = JSON.parse(doc.responseText).error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "loadMovies error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            var result = JSON.parse(doc.responseText).result;
            var movies = result.movies;
            movieModel.clear();
            for (var i = 0; i < movies.length; i++){
                //console.log(movies[i].thumb)
                var thumb = "http://"+$().server+":" + $().port + "/images/DefaultAlbumCover.png";
                if (movies[i].thumbnail) {
                    thumb = "http://"+$().server+":" + $().port + "/vfs/" + movies[i].thumbnail;
                }
                var duration = 0;
                if (movies[i].streamDetails)
                    duration = movies[i].streamDetails.video[0].duration;

                movieModel.append({"id": movies[i].movieid, "name": movies[i].label, "poster": thumb, "genre":  movies[i].genre, "duration": duration, "runtime": movies[i].runtime, "rating": movies[i].rating, "playcount":movies[i].playcount});
            }
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetMovies", "params": { "sort": {"method":"sorttitle", "order":"ascending"}, "fields": ["genre", "title", "runtime", "year", "playcount", "rating", "thumbnail", "streamDetails"] }, "id": 1}';
    doc.send(str);

    return;
}

Library.prototype.loadTVShows = function () {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {

            var error = JSON.parse(doc.responseText).error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "loadTVs error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            var result = JSON.parse(doc.responseText).result;
            var tvshows = result.tvshows;
            for (var i = 0; i < tvshows.length; i++){
                var thumb = "http://"+$().server+":" + $().port + "/images/DefaultAlbumCover.png";
                if (tvshows[i].thumbnail) {
                    thumb = "http://"+$().server+":" + $().port + "/vfs/" + tvshows[i].thumbnail;
                }

                tvshowModel.append({"id": tvshows[i].tvshowid, "name": tvshows[i].label, "poster": thumb, "genre":  tvshows[i].genre, "duration": tvshows[i].duration, "rating": tvshows[i].rating, "playcount":tvshows[i].playcount});
                //                console.log("tvshow append: " + tvshows[i].label);
            }
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetTVShows", "params": { "sort": {"method":"sorttitle", "order":"ascending"}, "fields": ["genre", "plot", "episode", "year", "playcount", "rating", "thumbnail"] }, "id": 1}';
    doc.send(str);

    return;
}

Library.prototype.loadSeasons = function (id) {
    this.idtvshow = id;
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {

            var error = JSON.parse(doc.responseText).error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "loadSeasons error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            var result = JSON.parse(doc.responseText).result;
            var seasons = result.seasons;
            for (var i = 0; i < seasons.length; i++){
                var thumb = "http://"+$().server+":" + $().port + "/images/DefaultAlbumCover.png";
                if (seasons[i].thumbnail) {
                    thumb = "http://"+$().server+":" + $().port + "/vfs/" + seasons[i].thumbnail;
                }
                var season = 0;
                if (seasons[i].season) {
                    season = seasons[i].season;
                }
                seasonModel.append({"id": season, "name": seasons[i].label, "thumb": thumb, "episodes":seasons[i].episode, "playcount":seasons[i].playcount});
            }
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetSeasons", "params": { "tvshowid":'+ id +', "sort": {"method":"label", "order":"ascending"}, "fields": ["thumbnail", "showtitle", "season", "episode", "playcount"] }, "id": 1}';
    doc.send(str);

    return;
}


Library.prototype.loadEpisodes = function (id) {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {

            var error = JSON.parse(doc.responseText).error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "loadepisodes error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            var result = JSON.parse(doc.responseText).result;
            var episodes = result.episodes;
            episodeModel.clear();
            for (var i = 0; i < episodes.length; i++){

                var thumb = "http://"+$().server+":" + $().port + "/images/DefaultAlbumCover.png";
                if (episodes[i].thumbnail) {
                    thumb = "http://"+$().server+":" + $().port + "/vfs/" + episodes[i].thumbnail;
                }

                var duration = 0;
                if (episodes[i].streamDetails)
                    duration = episodes[i].streamDetails.video[0].duration;

                episodeModel.append({"id": episodes[i].episodeid, "name": episodes[i].label, "thumb": thumb, "number":  episodes[i].episode, "duration": duration, "rating": episodes[i].rating, "playcount":episodes[i].playcount});
            }
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetEpisodes", "params": { "tvshowid":'+ this.idtvshow +', "season":'+ id +', "sort": {"method":"episode", "order":"ascending"}, "fields": ["thumbnail", "showtitle", "episode", "playcount", "rating", "streamDetails"] }, "id": 1}';
    doc.send(str);

    return;
}

Library.prototype.loadTracks = function (idalbum) {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {

            var error = JSON.parse(doc.responseText).error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "loadTracks error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            var result = JSON.parse(doc.responseText).result;
            var songs = result.songs;
            trackModel.clear();
            for (var i = 0; i < songs.length; i++){
                trackModel.append({"idtrack": songs[i].songid, "name": songs[i].label, "number": songs[i].track, "duration": songs[i].duration});
            }
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "AudioLibrary.GetSongs", "params": { "sort": {"method":"track", "order":"ascending"}, "fields": ["title", "artist", "genre", "track", "duration"], "albumid" : '+idalbum+' }, "id": 1}';
    doc.send(str);

    return;
}

Library.prototype.loadAlbums = function (idartist) {
    albumModel.clear();
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {

            var error = JSON.parse(doc.responseText).error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "loadAlbums error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            var result = JSON.parse(doc.responseText).result;
            var albums = result.albums;
            albumModel.clear();
            for (var i = 0; i < albums.length; i++){

                var thumb = "http://"+$().server+":" + $().port + "/images/DefaultAlbumCover.png";
                if (albums[i].thumbnail) {
                    thumb = "http://"+$().server+":" + $().port + "/vfs/" + albums[i].thumbnail;
                }

                albumModel.append({"idalbum": albums[i].albumid, "name": albums[i].label, "artist": albums[i].artist, "genre":albums[i].genre, "rating": albums[i].rating,  "thumb": thumb});
            }
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "AudioLibrary.GetAlbums", "params": { "sort": {"method":"album", "order":"ascending"}, "fields": ["label", "artist", "genre", "rating", "year", "thumbnail"], "artistid": '+idartist+' }, "id": 1}';
    doc.send(str);

    return;
}

Library.prototype.loadAllAlbums = function () {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {

            var error = JSON.parse(doc.responseText).error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "loadAllAlbums error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            var result = JSON.parse(doc.responseText).result;
            var albums = result.albums;
            albumModel.clear();
            for (var i = 0; i < albums.length; i++){
                var thumb = "http://"+$().server+":" + $().port + "/images/DefaultAlbumCover.png";
                if (albums[i].thumbnail) {
                    thumb = "http://"+$().server+":" + $().port + "/vfs/" + albums[i].thumbnail;
                }

                albumModel.append({"idalbum": albums[i].albumid, "name": albums[i].label, "artist": albums[i].artist, "genre":albums[i].genre, "rating": albums[i].rating,  "thumb": thumb});
            }
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "AudioLibrary.GetAlbums", "params": { "sort": {"method":"album", "order":"ascending"}, "fields": ["label", "artist", "genre", "rating", "year", "thumbnail"}, "id": 1}';
    doc.send(str);

    return;
}

Library.prototype.loadArtists = function() {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {

            var error = JSON.parse(doc.responseText).error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "loadArtists error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            var result = JSON.parse(doc.responseText).result;
            var artists = result.artists;
            artists.sort(sort);
            artistModel.clear();
            for (var i = 0; i < artists.length; i++){
                var thumb = "img/user.svg";
                if (artists[i].thumbnail) {
                    thumb = "http://"+$().server+":" + $().port + "/vfs/" + artists[i].thumbnail;
                }
                artistModel.append({"id": artists[i].artistid, "name": artists[i].artist, "poster": thumb, "selected": false});
            }
            //            console.log("loading artists done")
        }
    }
    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "AudioLibrary.GetArtists", "params": { "sort": {"method":"artist", "order":"ascending"}, "fields": ["thumbnail"] }, "id": 1}';
    doc.send(str);
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
