String.prototype.trim = function() {
    return this.replace(/^\s+|\s+$/g, "");
};

function Library() {
}

Library.prototype.loadMovies = function () {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);

            var error = oJSON.error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "loadMovies error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            var aGenres = [];
            var result = oJSON.result;
            var movies = result.movies;

            for (var i = 0; i < movies.length; i++){
                var thumb = "qrc:/defaultImages/movie";
                if (movies[i].thumbnail) {
                    thumb = "http://"+$().server+":" + $().port + "/vfs/" + movies[i].thumbnail;
                }

                if (movies[i].genre) {
                    var aGenre = movies[i].genre.split("/");
                    for (var j=0; j<aGenre.length; ++j) {
                        if (aGenres.indexOf(aGenre[j].trim()) == -1)
                            aGenres.push(aGenre[j].trim());
                    }
                }

                movieModel.append({"id": movies[i].movieid, "name": movies[i].label, "poster": thumb, "genre":  movies[i].genre, "duration": movies[i].duration, "runtime": movies[i].runtime, "rating": movies[i].rating, "year": movies[i].year, "watched": movies[i].playcount>0});
            }

            aGenres.sort();
            for (var i = 0; i < aGenres.length; i++){
                movieGenreModel.append({"name": aGenres[i]});
            }
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetMovies", "params": { "start": 0, "sort": {"method":"sorttitle", "order":"ascending"}, "fields": ["genre", "title", "runtime", "year", "playcount", "rating", "thumbnail", "duration"] }, "id": 1}';
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
                if (tvshows[i].genre) {
                    var aGenre = tvshows[i].genre.split("/");
                    for (var j=0; j<aGenre.length; ++j) {
                        if (aGenres.indexOf(aGenre[j].trim()) == -1)
                            aGenres.push(aGenre[j].trim());
                    }
                }
                console.debug(tvshows[i].lastplayed);

                tvshowModel.append({"id": tvshows[i].tvshowid, "name": tvshows[i].label, "poster": thumb, "genre":  tvshows[i].genre, "duration": tvshows[i].duration, "rating": tvshows[i].rating, "lastplayed": tvshows[i].lastplayed, "watched":tvshows[i].playcount>0});
            }

            aGenres.sort();
            for (var i = 0; i < aGenres.length; i++){
                tvshowGenreModel.append({"name": aGenres[i]});
            }
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetTVShows", "params": { "start": 0, "sort": {"method":"sorttitle", "order":"ascending"}, "fields": ["genre", "director", "trailer", "tagline", "plot", "plotoutline", "title", "originaltitle", "lastplayed", "showtitle", "firstaired", "duration", "season", "episode", "runtime", "year", "playcount", "rating"] }, "id": 1}';
    doc.send(str);
    tvshowModel.clear();

    return;
}

Library.prototype.loadSeasons = function (id) {
    this.idtvshow = id;
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
            for (var i = 0; i < seasons.length; i++){
                var thumb = "qrc:/defaultImages/tvshow";
                if (seasons[i].thumbnail) {
                    thumb = "http://"+$().server+":" + $().port + "/vfs/" + seasons[i].thumbnail;
                }
                var season = 0;
                if (seasons[i].season) {
                    season = seasons[i].season;
                }
                seasonModel.append({"id": season, "name": seasons[i].label, "showtitle": seasons[i].showtitle, "poster": thumb, "episodes":seasons[i].episode, "genre":  seasons[i].genre, "duration": seasons[i].duration, "rating": seasons[i].rating, "watched":seasons[i].playcount>0});
            }
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetSeasons", "params": { "start": 0, "tvshowid":'+ id +', "sort": {"method":"label", "order":"ascending"}, "fields": ["genre", "director", "trailer", "tagline", "plot", "plotoutline", "title", "originaltitle", "lastplayed", "showtitle", "firstaired", "duration", "season", "episode", "runtime", "year", "playcount", "rating", "watchedepisodes"] }, "id": 1}';
    doc.send(str);
    seasonModel.clear();

    return;
}


Library.prototype.loadEpisodes = function (id) {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);

            var error = oJSON.error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "loadepisodes error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            var result = oJSON.result;
            var episodes = result.episodes;
            for (var i = 0; i < episodes.length; i++){

                var thumb = "qrc:/defaultImages/tvshow";
                if (episodes[i].thumbnail) {
                    thumb = "http://"+$().server+":" + $().port + "/vfs/" + episodes[i].thumbnail;
                }

                episodeModel.append({"id": episodes[i].episodeid, "name": episodes[i].label, "poster": thumb, "number":  episodes[i].episode, "duration": episodes[i].duration, "rating": episodes[i].rating, "watched":episodes[i].playcount>0});
            }
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetEpisodes", "params": { "start": 0, "tvshowid":'+ this.idtvshow +', "season":'+ id +', "sort": {"method":"episode", "order":"ascending"}, "fields": ["genre", "director", "trailer", "tagline", "plot", "plotoutline", "title", "originaltitle", "lastplayed", "showtitle", "firstaired", "duration", "episode", "year", "playcount", "rating"] }, "id": 1}';
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
            for (var i = 0; i < songs.length; i++){
                trackModel.append({"idtrack": songs[i].songid, "name": songs[i].label, "number": songs[i].tracknumber, "duration": songs[i].duration});
            }
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "AudioLibrary.GetSongs", "params": { "sort": {"method":"track", "order":"ascending"}, "fields": ["title", "artist", "genre", "tracknumber", "discnumber", "duration", "year"], "albumid" : '+idalbum+' }, "id": 1}';
    doc.send(str);
    trackModel.clear();

    return;
}

Library.prototype.loadAlbums = function (idartist) {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);

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

                albumModel.append({"idalbum": albums[i].albumid, "name": albums[i].label, "artist": albums[i].album_artist, "genre":albums[i].album_genre, "rating": albums[i].album_rating,  "cover": thumb});
            }
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "AudioLibrary.GetAlbums", "params": { "start": 0, "sort": {"method":"album", "order":"ascending"}, "fields": ["album_label", "album_artist", "album_genre", "album_rating", "track", "duration", "year"], "artistid": '+idartist+' }, "id": 1}';
    doc.send(str);
    albumModel.clear();

    return;
}

Library.prototype.loadAllAlbums = function () {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);

            var error = oJSON.error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "loadAllAlbums error", "", 0));
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

                albumModel.append({"idalbum": albums[i].albumid, "name": albums[i].label, "artist": albums[i].album_artist, "genre":albums[i].album_genre, "rating": albums[i].album_rating,  "cover": thumb});
            }
        }
    }

    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "AudioLibrary.GetAlbums", "params": { "start": 0, "sort": {"method":"album", "order":"ascending"}, "fields": ["album_label", "album_artist", "album_genre", "album_rating", "track", "duration", "year"]}, "id": 1}';
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
                artistModel.append({"id": artists[i].artistid, "name": artists[i].label, "poster": thumb, "selected": false});
            }
        }
    }
    doc.open("POST", "http://"+$().server+":" + $().port + "/jsonrpc");
    var str = '{"jsonrpc": "2.0", "method": "AudioLibrary.GetArtists", "params": { "start": 0, "sort": {"method":"artist", "order":"ascending"} }, "id": 1}';
    doc.send(str);
    artistModel.clear();

    return;
}
