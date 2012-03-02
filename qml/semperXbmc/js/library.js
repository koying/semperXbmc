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
        console.log(Utils.dumpObj(error, "loadMovies error", "", 0));
        errorView.addError("error", error.message, error.code);
        return;
    }

    var aGenres = []
    var result = oJSON.result;
    var movies = result.movies;

    for (var i = 0; i < movies.length; i++){
        //console.log(movies[i].thumb)
        var thumb = "";
        if (movies[i].thumbnail && movies[i].thumbnail != "") {
            thumb = "http://"+globals.getJsonAuthString()+$().server+":" + $().port + "/vfs/" + movies[i].thumbnail;
        }
        if (movies[i].genre && movies[i].genre != "") {
            var aGenre = movies[i].genre.split("/");
            for (var j=0; j<aGenre.length; ++j) {
                if (aGenres.indexOf(aGenre[j].trim()) == -1) {
                    var g = movieGenreModel.getValues(aGenre[j].trim());
                    if (!Utils.isEmpty(g)) {
                        g.count = g.count + 1
                        if (movies[i].playcount == 0)
                            g.unseen = g.unseen + 1
                        g.playcount = g.unseen > 0 ? 0 : 1;
                        movieGenreModel.keyUpdate(g);
                    } else {
                        movieGenreModel.append({"name":aGenre[j].trim(), "count":1, "unseen": movies[i].playcount ? 0 : 1, "playcount": movies[i].playcount ? 1 : 0})
                    }
                }
            }
        }

        movieModel.append({"id": movies[i].movieid, "name": movies[i].label, "poster": thumb, "genre":  movies[i].genre, "duration": movies[i].duration, "runtime": movies[i].runtime, "rating": movies[i].rating, "year": movies[i].year, "imdbnumber": movies[i].imdbnumber, "originaltitle": movies[i].originaltitle, "playcount": movies[i].playcount});
    }

    movieProxyModel.reSort();
    movieGenreProxyModel.reSort()
}

Library.prototype.loadMovies = function () {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            Library.prototype.handleMovies(doc.responseText);
        }
    }


    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetMovies", "params": { "start": 0, "sort": {"method":"sorttitle", "order":"ascending"}, "fields": ["genre", "title", "runtime", "year", "playcount", "rating", "thumbnail", "duration", "imdbnumber", "originaltitle"] }, "id": 1}';
    doc.send(str);
    movieModel.clear();
    movieGenreModel.clear();

    return;
}

Library.prototype.recentMovies = function () {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            Library.prototype.handleMovies(doc.responseText);
        }
    }


    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetRecentlyAddedMovies", "params": { "fields": ["genre", "title", "runtime", "year", "playcount", "rating", "thumbnail", "duration", "imdbnumber", "originaltitle"] }, "id": 1}';
    doc.send(str);
    movieModel.clear();
    movieGenreModel.clear();

    return;
}

Library.prototype.loadTVShows = function () {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);

            var error = oJSON.error;
            if (error) {
                console.log(Utils.dumpObj(error, "loadTVs error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            var aGenres = []
            var result = oJSON.result;
            var tvshows = result.tvshows;
            for (var i = 0; i < tvshows.length; i++){
                var thumb = "";
                if (tvshows[i].thumbnail && tvshows[i].thumbnail != "") {
                    thumb = "http://"+globals.getJsonAuthString()+$().server+":" + $().port + "/vfs/" + tvshows[i].thumbnail;
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


    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetTVShows", "params": { "start": 0, "sort": {"method":"sorttitle", "order":"ascending"}, "fields": ["genre", "director", "trailer", "tagline", "plot", "plotoutline", "title", "originaltitle", "showtitle", "firstaired", "duration", "season", "episode", "runtime", "year", "playcount", "rating", "imdbnumber"] }, "id": 1}';
    doc.send(str);
    tvshowModel.clear();
    tvshowGenreModel.clear();

    return;
}

Library.prototype.loadSeasons = function (id) {
    Library.prototype.tvshowId = id;
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);

            var error = oJSON.error;
            if (error) {
                console.log(Utils.dumpObj(error, "loadSeasons error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            var result = oJSON.result;
            var seasons = result.seasons;
            if (!seasons) return;
            for (var i = 0; i < seasons.length; i++){
                var thumb = "";
                if (seasons[i].thumbnail && seasons[i].thumbnail != "") {
                    thumb = "http://"+globals.getJsonAuthString()+$().server+":" + $().port + "/vfs/" + seasons[i].thumbnail;
                }
                var season = 0;
                if (seasons[i].season) {
                    season = seasons[i].season;
                }
                seasonModel.append({"id": season, "name": seasons[i].label, "showtitle": seasons[i].showtitle, "poster": thumb, "episodes":seasons[i].episode, "genre":  seasons[i].genre, "duration": seasons[i].duration, "rating": seasons[i].rating, "playcount":seasons[i].playcount});
            }
            seasonProxyModel.reSort();
        }
    }


    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetSeasons", "params": { "start": 0, "tvshowid":'+ Library.prototype.tvshowId +', "sort": {"method":"label", "order":"ascending"}, "fields": ["genre", "director", "trailer", "tagline", "plot", "plotoutline", "title", "originaltitle", "showtitle", "firstaired", "duration", "season", "episode", "runtime", "year", "playcount", "rating", "watchedepisodes"] }, "id": 1}';
    doc.send(str);
    seasonModel.clear();

    return;
}

Library.prototype.handleEpisodes = function (responseText) {
    var oJSON = JSON.parse(responseText);

    var error = oJSON.error;
    if (error) {
        console.log(Utils.dumpObj(error, "loadepisodes error", "", 0));
        errorView.addError("error", error.message, error.code);
        return;
    }

    var result = oJSON.result;
    var episodes = result.episodes;
    if (!episodes) return;
    for (var i = 0; i < episodes.length; i++){

        var thumb = "";
        if (episodes[i].thumbnail && episodes[i].thumbnail != "") {
            thumb = "http://"+globals.getJsonAuthString()+$().server+":" + $().port + "/vfs/" + episodes[i].thumbnail;
        }

        episodeModel.append({"id": episodes[i].episodeid, "name": episodes[i].label, "poster": thumb, "tvshowId": Library.prototype.tvshowId, "number":  episodes[i].episode, "duration": episodes[i].duration, "rating": episodes[i].rating, "playcount":episodes[i].playcount});
    }
    episodeProxyModel.reSort();
}

Library.prototype.loadEpisodes = function (id) {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            Library.prototype.handleEpisodes(doc.responseText);
        }
    }


    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetEpisodes", "params": { "start": 0, "tvshowid":'+ Library.prototype.tvshowId +', "season":'+ id +', "sort": {"method":"episode", "order":"ascending"}, "fields": ["genre", "director", "trailer", "tagline", "plot", "plotoutline", "title", "originaltitle", "lastplayed", "showtitle", "firstaired", "duration", "episode", "year", "playcount", "rating"] }, "id": 1}';
    doc.send(str);
    episodeModel.clear();

    return;
}

Library.prototype.recentEpisodes = function () {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            Library.prototype.handleEpisodes(doc.responseText);
        }
    }


    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetRecentlyAddedEpisodes", "params": { "fields": ["thumbnail", "showtitle", "episode", "playcount", "rating", "streamDetails"] }, "id": 1}';
    doc.send(str);
    episodeModel.clear();

    return;
}

Library.prototype.loadTracks = function (idalbum) {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);


            var error = oJSON.error;
            if (error) {
                console.log(Utils.dumpObj(error, "loadTracks error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            var result = oJSON.result;
            var songs = result.songs;
            for (var i = 0; i < songs.length; i++){
                trackModel.append({"idtrack": songs[i].songid, "name": songs[i].label, "number": songs[i].tracknumber, "duration": songs[i].duration});
            }
        }
    }


    var str = '{"jsonrpc": "2.0", "method": "AudioLibrary.GetSongs", "params": { "sort": {"method":"track", "order":"ascending"}, "fields": ["title", "artist", "genre", "tracknumber", "discnumber", "duration", "year"], "albumid" : '+idalbum+' }, "id": 1}';
    doc.send(str);
    trackModel.clear();

    return;
}

Library.prototype.handleAlbums = function (responseText) {
    var oJSON = JSON.parse(responseText);

    var error = oJSON.error;
    if (error) {
        console.log(Utils.dumpObj(error, "loadAlbums error", "", 0));
        errorView.addError("error", error.message, error.code);
        return;
    }

    var result = oJSON.result;
    var albums = result.albums;
    for (var i = 0; i < albums.length; i++){

        var thumb = "";
        if (albums[i].thumbnail && albums[i].thumbnail != "") {
            thumb = "http://"+globals.getJsonAuthString()+$().server+":" + $().port + "/vfs/" + albums[i].thumbnail;
        }

        albumModel.append({"idalbum": albums[i].albumid, "name": albums[i].label, "artist": albums[i].album_artist, "genre":albums[i].album_genre, "rating": albums[i].album_rating,  "cover": thumb});
    }
    albumProxyModel.reSort();
}

Library.prototype.loadAlbums = function (idartist) {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            Library.prototype.handleAlbums(doc.responseText);
        }
    }


    var str = '{"jsonrpc": "2.0", "method": "AudioLibrary.GetAlbums", "params": { "start": 0, "sort": {"method":"album", "order":"ascending"}, "fields": ["album_label", "album_artist", "album_genre", "album_rating", "track", "duration", "year"], "artistid": '+idartist+' }, "id": 1}';
    doc.send(str);
    albumModel.clear();

    return;
}

Library.prototype.loadAllAlbums = function () {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            Library.prototype.handleAlbums(doc.responseText);
        }
    }


    var str = '{"jsonrpc": "2.0", "method": "AudioLibrary.GetAlbums", "params": { "start": 0, "sort": {"method":"album", "order":"ascending"}, "fields": ["album_label", "album_artist", "album_genre", "album_rating", "track", "duration", "year"]}, "id": 1}';
    doc.send(str);
    albumModel.clear();

    return;
}

Library.prototype.recentAlbums = function () {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            Library.prototype.handleAlbums(doc.responseText)
        }
    }


    var str = '{"jsonrpc": "2.0", "method": "AudioLibrary.GetRecentlyAddedAlbums", "params": { "fields": ["label", "artist", "genre", "rating", "year", "thumbnail"]}, "id": 1}';
    doc.send(str);
    albumModel.clear();

    return;
}

Library.prototype.loadArtists = function() {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);

            var error = oJSON.error;
            if (error) {
                console.log(Utils.dumpObj(error, "loadArtists error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            var result = oJSON.result;
            var artists = result.artists;
            for (var i = 0; i < artists.length; i++){
                var thumb = "";
                if (artists[i].thumbnail && artists[i].thumbnail != "") {
                    thumb = "http://"+globals.getJsonAuthString()+$().server+":" + $().port + "/vfs/" + artists[i].thumbnail;
                }
                artistModel.append({"id": artists[i].artistid, "name": artists[i].label, "poster": thumb, "selected": false});
            }
            artistProxyModel.reSort();
        }
    }

    var str = '{"jsonrpc": "2.0", "method": "AudioLibrary.GetArtists", "params": { "start": 0, "sort": {"method":"artist", "order":"ascending"} }, "id": 1}';
    doc.send(str);
    artistModel.clear();

    return;
}
