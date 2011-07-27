String.prototype.trim = function() {
    return this.replace(/^\s+|\s+$/g, "");
};

function Library() {
}

Library.prototype.tvshowId = -1;

Library.prototype.handleMovies = function (responseText) {
    var oJSON = JSON.parse(responseText);

    var error = oJSON.error;
    if (error) {
        console.log(Xbmc.dumpObj(error, "loadMovies error", "", 0));
        errorView.addError("error", error.message, error.code);
        return;
    }

    var aGenres = []
    var result = oJSON.result;
    var movies = result.movies;

    for (var i = 0; i < movies.length; i++){
        //console.log(movies[i].thumb)
        var thumb = "qrc:/defaultImages/movie";
        if (movies[i].thumbnail) {
            thumb = "http://"+$().server+":" + $().port + "/vfs/" + movies[i].thumbnail;
        }
        var duration = 0;
        if (movies[i].streamDetails)
            duration = movies[i].streamDetails.video[0].duration;

        if (movies[i].genre && movies[i].genre != "") {
            var aGenre = movies[i].genre.split("/");
            for (var j=0; j<aGenre.length; ++j) {
                if (aGenres.indexOf(aGenre[j].trim()) == -1)
                    aGenres.push(aGenre[j].trim());
            }
        }

        movieModel.append({"id": movies[i].movieid, "name": movies[i].label, "poster": thumb, "genre":  movies[i].genre, "duration": duration, "runtime": movies[i].runtime, "rating": movies[i].rating, "year": movies[i].year, "imdbnumber": movies[i].imdbnumber, "originaltitle": movies[i].originaltitle, "playcount":movies[i].playcount});
    }

    aGenres.sort();
    for (var i = 0; i < aGenres.length; i++){
        movieGenreModel.append({"name": aGenres[i]});
    }
    movieProxyModel.reSort();
}

Library.prototype.loadMovies = function () {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            Library.prototype.handleMovies(doc.responseText);
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetMovies", "params": { "sort": {"method":"sorttitle", "order":"ascending"}, "fields": ["genre", "title", "runtime", "year", "playcount", "rating", "thumbnail", "streamDetails", "imdbnumber", "originaltitle"] }, "id": 1}';
    doc.send(str);
    movieModel.clear();

    return;
}

Library.prototype.recentMovies = function () {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            Library.prototype.handleMovies(doc.responseText);
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetRecentlyAddedMovies", "params": { "fields": ["genre", "title", "runtime", "year", "playcount", "rating", "thumbnail", "streamDetails", "imdbnumber"] }, "id": 1}';
    doc.send(str);
    movieModel.clear();

    return;
}

Library.prototype.loadTVShows = function () {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);

            var error = oJSON.error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "loadTVs error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            var aGenres = []
            var result = oJSON.result;
            var tvshows = result.tvshows;
            for (var i = 0; i < tvshows.length; i++){
                var thumb = "qrc:/defaultImages/tvshow";
                if (tvshows[i].thumbnail) {
                    thumb = "http://"+$().server+":" + $().port + "/vfs/" + tvshows[i].thumbnail;
                }
                if (tvshows[i].genre && tvshows[i].genre != "") {
                    var aGenre = tvshows[i].genre.split("/");
                    for (var j=0; j<aGenre.length; ++j) {
                        if (aGenres.indexOf(aGenre[j].trim()) == -1)
                            aGenres.push(aGenre[j].trim());
                    }
                }
                var originaltitle = tvshows[i].originaltitle;
                if (!originaltitle || originaltitle == "")
                    originaltitle = tvshows[i].label

                tvshowModel.append({"id": tvshows[i].tvshowid, "name": tvshows[i].label, "poster": thumb, "genre":  tvshows[i].genre, "duration": tvshows[i].duration, "rating": tvshows[i].rating, "imdbnumber": tvshows[i].imdbnumber, "originaltitle": originaltitle, "playcount":tvshows[i].playcount});
            }

            aGenres.sort();
            for (var i = 0; i < aGenres.length; i++){
                tvshowGenreModel.append({"name": aGenres[i]});
            }

            tvshowProxyModel.reSort();
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetTVShows", "params": { "sort": {"method":"sorttitle", "order":"ascending"}, "fields": ["genre", "plot", "episode", "year", "playcount", "rating", "thumbnail", "originaltitle", "imdbnumber"] }, "id": 1}';
    doc.send(str);
    tvshowModel.clear();

    return;
}

Library.prototype.loadSeasons = function (id) {
    Library.prototype.tvshowId = id;
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);

            var error = oJSON.error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "loadSeasons error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            var result = oJSON.result;
            var seasons = result.seasons;
            if (!seasons) return;
            for (var i = 0; i < seasons.length; i++){
                var thumb = "qrc:/defaultImages/tvshow";
                if (seasons[i].thumbnail) {
                    thumb = "http://"+$().server+":" + $().port + "/vfs/" + seasons[i].thumbnail;
                }
                var season = 0;
                if (seasons[i].season) {
                    season = seasons[i].season;
                }
                seasonModel.append({"id": season, "name": seasons[i].label, "showtitle": seasons[i].showtitle, "poster": thumb, "episodes":seasons[i].episode, "playcount":seasons[i].playcount});
            }
            seasonProxyModel.reSort();
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetSeasons", "params": { "tvshowid":'+ Library.prototype.tvshowId +', "sort": {"method":"label", "order":"ascending"}, "fields": ["thumbnail", "showtitle", "season", "episode", "playcount"] }, "id": 1}';
    doc.send(str);
    seasonModel.clear();

    return;
}

Library.prototype.handleEpisodes = function (responseText) {
    var oJSON = JSON.parse(responseText);

    var error = oJSON.error;
    if (error) {
        console.log(Xbmc.dumpObj(error, "loadepisodes error", "", 0));
        errorView.addError("error", error.message, error.code);
        return;
    }

    var result = oJSON.result;
    var episodes = result.episodes;
    if (!episodes) return;
    for (var i = 0; i < episodes.length; i++){

        var thumb = "qrc:/defaultImages/tvshow";
        if (episodes[i].thumbnail) {
            thumb = "http://"+$().server+":" + $().port + "/vfs/" + episodes[i].thumbnail;
        }

        var duration = 0;
        if (episodes[i].streamDetails)
            duration = episodes[i].streamDetails.video[0].duration;

        episodeModel.append({"id": episodes[i].episodeid, "name": episodes[i].label, "poster": thumb, "tvshowId": Library.prototype.tvshowId, "number":  episodes[i].episode, "duration": duration, "rating": episodes[i].rating, "playcount":episodes[i].playcount});
    }
    episodeProxyModel.reSort();
}

Library.prototype.loadEpisodes = function (id) {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            Library.prototype.handleEpisodes(doc.responseText);
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetEpisodes", "params": { "tvshowid":'+ Library.prototype.tvshowId +', "season":'+ id +', "sort": {"method":"episode", "order":"ascending"}, "fields": ["thumbnail", "showtitle", "episode", "playcount", "rating", "streamDetails"] }, "id": 1}';
    doc.send(str);
    episodeModel.clear();

    return;
}

Library.prototype.recentEpisodes = function () {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            Library.prototype.handleEpisodes(doc.responseText);
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetRecentlyAddedEpisodes", "params": { "fields": ["thumbnail", "showtitle", "episode", "playcount", "rating", "streamDetails"] }, "id": 1}';
    doc.send(str);
    episodeModel.clear();

    return;
}

Library.prototype.loadTracks = function (idalbum) {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);

            var error = oJSON.error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "loadTracks error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            var result = oJSON.result;
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
    trackModel.clear();

    return;
}

Library.prototype.handleAlbums = function (responseText) {
    var oJSON = JSON.parse(responseText);

    var error = oJSON.error;
    if (error) {
        console.log(Xbmc.dumpObj(error, "loadAlbums error", "", 0));
        errorView.addError("error", error.message, error.code);
        return;
    }

    var result = oJSON.result;
    var albums = result.albums;
    for (var i = 0; i < albums.length; i++){

        var thumb = "qrc:/defaultImages/album";
        if (albums[i].thumbnail) {
            thumb = "http://"+$().server+":" + $().port + "/vfs/" + albums[i].thumbnail;
        }

        albumModel.append({"idalbum": albums[i].albumid, "name": albums[i].label, "artist": albums[i].artist, "genre":albums[i].genre, "rating": albums[i].rating,  "cover": thumb});
    }
    albumProxyModel.reSort();
}

Library.prototype.loadAlbums = function (idartist) {
    albumModel.clear();
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            Library.prototype.handleAlbums(doc.responseText)
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "AudioLibrary.GetAlbums", "params": { "sort": {"method":"album", "order":"ascending"}, "fields": ["label", "artist", "genre", "rating", "year", "thumbnail"], "artistid": '+idartist+' }, "id": 1}';
    doc.send(str);
    albumModel.clear();

    return;
}

Library.prototype.loadAllAlbums = function () {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            Library.prototype.handleAlbums(doc.responseText)
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "AudioLibrary.GetAlbums", "params": { "sort": {"method":"album", "order":"ascending"}, "fields": ["label", "artist", "genre", "rating", "year", "thumbnail"]}, "id": 1}';
    doc.send(str);
    albumModel.clear();

    return;
}

Library.prototype.recentAlbums = function () {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            Library.prototype.handleAlbums(doc.responseText)
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "AudioLibrary.GetRecentlyAddedAlbums", "params": { "fields": ["label", "artist", "genre", "rating", "year", "thumbnail"]}, "id": 1}';
    doc.send(str);
    albumModel.clear();

    return;
}

Library.prototype.loadArtists = function() {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);

            var error = oJSON.error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "loadArtists error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            var result = oJSON.result;
            var artists = result.artists;
            for (var i = 0; i < artists.length; i++){
                var thumb = "qrc:/defaultImages/artist";
                if (artists[i].thumbnail) {
                    thumb = "http://"+$().server+":" + $().port + "/vfs/" + artists[i].thumbnail;
                }
                artistModel.append({"id": artists[i].artistid, "name": artists[i].artist, "poster": thumb, "selected": false});
            }
            artistProxyModel.reSort();
        }
    }
    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "AudioLibrary.GetArtists", "params": { "sort": {"method":"artist", "order":"ascending"}, "fields": ["thumbnail"] }, "id": 1}';
    doc.send(str);
    artistModel.clear();
}
