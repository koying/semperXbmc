String.prototype.trim = function() {
    return this.replace(/^\s+|\s+$/g, "");
};

function Library() {
    this.onDone = null
}

Library.prototype.tvshowId = -1;
Library.prototype.movieFields = '["genre", "title", "year", "playcount", "rating", "thumbnail", "runtime","imdbnumber", "originaltitle", "resume"]'
Library.prototype.episodeFields = '["title", "thumbnail", "tvshowid", "showtitle", "season", "episode", "playcount", "rating", "runtime", "firstaired", "resume"]'

Library.prototype.handleMovies = function (movies) {
    for (var i = 0; i < movies.length; i++){
        //console.log(movies[i].thumb)
//        console.log(Utils.dumpObj(movies[i], "movies[i]", "", 0));
        var thumb = "";
        if (movies[i].thumbnail && movies[i].thumbnail != "") {
            thumb = "http://"+globals.getJsonAuthString()+$().server+":" + $().port + "/vfs/" + movies[i].thumbnail;
        }

        var duration = "";
        if (movies[i].streamdetails && movies[i].streamdetails.video)
            duration = Utils.secToHours(movies[i].streamdetails.video[0].duration)
        else {
            var intRT = parseInt(movies[i].runtime)
            if (movies[i].runtime == intRT) {
                if (intRT != 0)
                    duration = Utils.secToHours(intRT*60)
            } else {
                if (movies[i].runtime != "00h00min")
                    duration = movies[i].runtime
            }
        }

        var imdbnumber = movies[i].imdbnumber
        if (imdbnumber) {
            if (imdbnumber.substring(0,2) == "tt")
                imdbnumber = imdbnumber.slice(2)
            imdbnumber = parseInt(imdbnumber,10)
        } else
            imdbnumber = 0

        var aGenre = [];
        if (movies[i].genre && movies[i].genre != "") {
            aGenre = movies[i].genre;
            if (typeof aGenre === "string") {
                aGenre = aGenre.split("/");
            }

            for (var j=0; j<aGenre.length; ++j) {
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

        movieModel.append({"id": movies[i].movieid, "name": movies[i].label, "poster": thumb, "genre":  aGenre.join(" / "), "duration": duration, "rating": movies[i].rating, "year": movies[i].year, "imdbnumber": imdbnumber, "originaltitle": movies[i].originaltitle, "playcount":movies[i].playcount, "resume":movies[i].resume});
        if (movies[i].resume && movies[i].resume.position!=0) {
            console.debug("resume " + movies[i].label + " @ " + movies[i].resume.position + "/" + movies[i].resume.total );
        }
    }

    movieProxyModel.reSort();
    movieGenreProxyModel.sortRole = "name"
    movieGenreProxyModel.sortOrder = Qt.AscendingOrder
//    movieGenreProxyModel.reSort();
}

Library.prototype.loadMovies = function () {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);

            var error = oJSON.error;
            if (error) {
                console.log(Utils.dumpObj(error, "loadMovies error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            var result = oJSON.result;
            var movies = result.movies;
            Library.prototype.handleMovies(movies);
        }
    }

    movieModel.clear();
    movieGenreModel.clear();
    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetMovies", "params": { "sort": {"method":"sorttitle", "order":"ascending"}, "properties": '+Library.prototype.movieFields+'  }, "id": 1}';
    doc.send(str);

    return;
}

Library.prototype.updateMoviesByImdb = function (movieModel) {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);
            var result = oJSON.result;
            var movies = result.movies;
            for (var i = 0; i < movies.length; i++) {
                var imdbnumber = movies[i].imdbnumber
                if (!imdbnumber)
                    continue
                if (imdbnumber.substring(0,2) == "tt")
                    imdbnumber = imdbnumber.slice(2)
                imdbnumber = parseInt(imdbnumber,10)
                for (var j=0; j<movieModel.count; ++j) {
                    if (movieModel.property(j, "imdbnumber") == imdbnumber)
                        movieModel.setProperty(j, "id", movies[i].movieid)
                }

            }
        }
    }

    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetMovies", "params": { "properties": ["imdbnumber"] }, "id": 1}';
    doc.send(str);

    return;
}

Library.prototype.recentMovies = function () {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);

            var error = oJSON.error;
            if (error) {
                console.log(Utils.dumpObj(error, "recentMovies error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            var result = oJSON.result;
            var movies = result.movies;
            Library.prototype.handleMovies(movies);
        }
    }


    movieModel.clear();
    movieGenreModel.clear();
    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetRecentlyAddedMovies", "params": { "properties": '+Library.prototype.movieFields+' }, "id": 1}';
    doc.send(str);

    return;
}

Library.prototype.loadMovieSets = function () {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState != XMLHttpRequest.DONE) return;

        var oJSON = JSON.parse(doc.responseText);

        var error = oJSON.error;
        if (error) {
            console.log(Utils.dumpObj(error, "loadMovieSets error", "", 0));
            errorView.addError("error", error.message, error.code);
            return;
        }

        var result = oJSON.result;
        var sets = result.sets;

        for (var i = 0; i < sets.length; i++){
            var thumb = "";
            if (sets[i].thumbnail && sets[i].thumbnail != "") {
                thumb = "http://"+globals.getJsonAuthString()+$().server+":" + $().port + "/vfs/" + sets[i].thumbnail;
            }

            movieSetsModel.append({"id": sets[i].setid, "name": sets[i].label, "poster": thumb, "playcount":sets[i].playcount});
        }
        movieSetsProxyModel.reSort()
    }


    movieSetsModel.clear();
    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetMovieSets", "params": { "sort": {"method":"sorttitle", "order":"ascending"}, "properties": ["title", "thumbnail","playcount"] }, "id": 1}';
    doc.send(str);

    return;
}

Library.prototype.loadMovieSetMovies = function (setId) {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);

            var error = oJSON.error;
            if (error) {
                console.log(Utils.dumpObj(error, "loadMovieSetMovies error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            var result = oJSON.result;
            var movies = result.setdetails.items.movies
            Library.prototype.handleMovies(movies);
        }
    }


    movieModel.clear();
    movieGenreModel.clear();
    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetMovieSetDetails", "params": { "setid":'+ setId +', "movies": {"sort": {"method":"year", "order":"ascending"}, "properties": '+Library.prototype.movieFields+' } }, "id": 1}';
    doc.send(str);

    return;
}

Library.prototype.markMovieAsSeen = function (movieId, seen) {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);

            var error = oJSON.error;
            if (error) {
                console.log(Utils.dumpObj(error, "markMovieAsSeen error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }
//            movieModel.update({"id": movieId, "playcount":seen ? 1 : 0})
        }
    }


    var o = { jsonrpc: "2.0", method: "VideoLibrary.SetMovieDetails", params: { movieid: movieId, playcount: seen ? 1 : 0}, id: 1};
    var str = JSON.stringify(o);
    doc.send(str);

    return;
}

Library.prototype.removeMovie = function (movieId, deletefile) {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);

            var error = oJSON.error;
            if (error) {
                console.log(Utils.dumpObj(error, "RemoveMovie error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }
        }
    }


    var o = { jsonrpc: "2.0", method: "VideoLibrary.RemoveMovie", params: { movieid: movieId, deletefile: deletefile }, id: 1};
    var str = JSON.stringify(o);
    doc.send(str);

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

            var result = oJSON.result;
            var tvshows = result.tvshows;
            var aGenres = [];
            for (var i = 0; i < tvshows.length; i++) {
                var thumb = "";
                if (tvshows[i].thumbnail && tvshows[i].thumbnail != "") {
                    thumb = "http://"+globals.getJsonAuthString()+$().server+":" + $().port + "/vfs/" + tvshows[i].thumbnail;
                }
                var aGenre = [];
                if (tvshows[i].genre && tvshows[i].genre !== "") {
                    aGenre = tvshows[i].genre;
                    if (typeof aGenre === "string") {
                        aGenre = aGenre.split("/");
                    }

                    for (var j=0; j<aGenre.length; ++j) {
                        if (aGenres.indexOf(aGenre[j].trim()) == -1)
                            aGenres.push(aGenre[j].trim());
                    }
                }
                var originaltitle = tvshows[i].originaltitle;
                if (!originaltitle || originaltitle == "")
                    originaltitle = tvshows[i].label

                tvshowModel.append({"id": tvshows[i].tvshowid, "name": tvshows[i].label, "poster": thumb, "genre":  aGenre.join(" / "), "duration": tvshows[i].duration, "rating": tvshows[i].rating, "imdbnumber": tvshows[i].imdbnumber, "originaltitle": originaltitle, "playcount":tvshows[i].playcount, "lastplayed":tvshows[i].lastplayed});
                console.debug(tvshows[i].label + " " + tvshows[i].lastplayed)
            }

            aGenres.sort();
            for (var i = 0; i < aGenres.length; i++){
                tvshowGenreModel.append({"name": aGenres[i].trim()});
            }

            tvshowProxyModel.reSort();
        }
    }


    tvshowModel.clear();
    tvshowGenreModel.clear();
    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetTVShows", "params": { "sort": {"method":"sorttitle", "order":"ascending"}, "properties": ["genre", "plot", "episode", "year", "playcount", "rating", "thumbnail", "originaltitle", "imdbnumber", "lastplayed"] }, "id": 1}';
    doc.send(str);

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
                seasonModel.append({"id": season, "name": seasons[i].label, "showtitle": seasons[i].showtitle, "poster": thumb, "episodes":seasons[i].episode, "playcount":seasons[i].playcount});
            }
            seasonProxyModel.reSort();

            if ($().library.onDone) {
                $().library.onDone()
            }
        }
    }


    seasonModel.clear();
    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetSeasons", "params": { "tvshowid":'+ Library.prototype.tvshowId +', "sort": {"method":"label", "order":"ascending"}, "properties": ["thumbnail", "showtitle", "season", "episode", "playcount"] }, "id": 1}';
    doc.send(str);

    return;
}

Library.prototype.handleEpisodes = function (responseText) {
    console.debug("got episodes")
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

        var duration = "";
        if (episodes[i].streamdetails && episodes[i].streamdetails.video)
            duration = Utils.secToHours(episodes[i].streamdetails.video[0].duration)
        else {
            var intRT = parseInt(episodes[i].runtime)
            if (episodes[i].runtime == intRT) {
                if (intRT != 0)
                    duration = Utils.secToHours(intRT*60)
            } else {
                if (episodes[i].runtime != "00h00min")
                    duration = episodes[i].runtime
            }
        }

        episodeModel.append({"id": episodes[i].episodeid, "name": episodes[i].title, "poster": thumb, "tvshowId": episodes[i].tvshowid, "showtitle": episodes[i].showtitle, "season": episodes[i].season, "number":  episodes[i].episode, "duration": duration, "rating": episodes[i].rating, "playcount":episodes[i].playcount, "resume":episodes[i].resume, "firstaired":episodes[i].firstaired});
        if (episodes[i].resume && episodes[i].resume.position!=0) {
            console.debug("resume " + episodes[i].label + " @ " + episodes[i].resume.position + "/" + episodes[i].resume.total );
        }
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


    episodeModel.clear();
    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetEpisodes", "params": { "tvshowid":'+ Library.prototype.tvshowId +', "season":'+ id +', "sort": {"method":"episode", "order":"ascending"}, "properties": ' + Library.prototype.episodeFields + ' }, "id": 1}';
    doc.send(str);

    return;
}

Library.prototype.recentEpisodes = function () {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            Library.prototype.handleEpisodes(doc.responseText);
        }
    }


    episodeModel.clear();
    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetRecentlyAddedEpisodes", "params": { "properties": ' + Library.prototype.episodeFields + ' }, "id": 1}';
    doc.send(str);

    return;
}

Library.prototype.markEpisodeAsSeen = function (epId, seen) {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);

            var error = oJSON.error;
            if (error) {
                console.log(Utils.dumpObj(error, "markEpisodeAsSeen error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

//            episodeModel.update({"id": epId, "playcount":seen ? 1 : 0})
        }
    }


    var o = { jsonrpc: "2.0", method: "VideoLibrary.SetEpisodeDetails", params: { episodeid: epId, playcount: seen ? 1 : 0}, id: 1};
    var str = JSON.stringify(o);
    doc.send(str);

    return;
}

Library.prototype.removeEpisode = function (epId, deletefile) {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);

            var error = oJSON.error;
            if (error) {
                console.log(Utils.dumpObj(error, "removeEpisode error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }
        }
    }


    var o = { jsonrpc: "2.0", method: "VideoLibrary.RemoveEpisode", params: { episodeid: epId, deletefile: deletefile }, id: 1};
    var str = JSON.stringify(o);
    doc.send(str);

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
            trackModel.clear();
            for (var i = 0; i < songs.length; i++){
                trackModel.append({"idtrack": songs[i].songid, "name": songs[i].label, "artist": songs[i].artist.join(" / "), "number": songs[i].track, "duration": songs[i].duration, "path": songs[i].file});
            }
        }
    }


    trackModel.clear();
    var str = '{"jsonrpc": "2.0", "method": "AudioLibrary.GetSongs", "params": { "sort": {"method":"track", "order":"ascending"}, "properties": ["title", "artist", "genre", "track", "duration", "file"], "filter": {"albumid": '+idalbum+'} }, "id": 1}';
    doc.send(str);

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

        albumModel.append({"idalbum": albums[i].albumid, "name": albums[i].label, "artist": albums[i].artist.join(" / "), "genre":albums[i].genre.join(" / "), "rating": albums[i].rating,  "cover": thumb});
    }
    albumProxyModel.reSort();
}

Library.prototype.loadAlbums = function (idartist) {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            Library.prototype.handleAlbums(doc.responseText)
        }
    }


    albumModel.clear();
    var str = '{"jsonrpc": "2.0", "method": "AudioLibrary.GetAlbums", "params": { "sort": {"method":"album", "order":"ascending"}, "properties": ["albumlabel", "artist", "genre", "rating", "year", "thumbnail"], "filter":{"artistid": '+idartist+'} }, "id": 1}';
    doc.send(str);

    return;
}

Library.prototype.loadAllAlbums = function () {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            Library.prototype.handleAlbums(doc.responseText)
        }
    }


    albumModel.clear();
    var str = '{"jsonrpc": "2.0", "method": "AudioLibrary.GetAlbums", "params": { "sort": {"method":"album", "order":"ascending"}, "properties": ["albumlabel", "artist", "genre", "rating", "year", "thumbnail"]}, "id": 1}';
    doc.send(str);

    return;
}

Library.prototype.recentAlbums = function () {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            Library.prototype.handleAlbums(doc.responseText)
        }
    }


    albumModel.clear();
    var str = '{"jsonrpc": "2.0", "method": "AudioLibrary.GetRecentlyAddedAlbums", "params": { "properties": ["albumlabel", "artist", "genre", "rating", "year", "thumbnail"]}, "id": 1}';
    doc.send(str);

    return;
}

Library.prototype.loadArtists = function() {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            console.debug("got response")
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
                artistModel.append({"id": artists[i].artistid, "name": artists[i].artist, "poster": thumb, "selected": false});
            }
            artistProxyModel.reSort();
        }
    }

    artistModel.clear();
    var str = '{"jsonrpc": "2.0", "method": "AudioLibrary.GetArtists", "params": { "sort": {"method":"artist", "order":"ascending"}, "properties": ["thumbnail"] }, "id": 1}';
    doc.send(str);
}

Library.prototype.loadSources = function(fileProxyModel) {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);

            var error = oJSON.error;
            if (error) {
                console.log(Utils.dumpObj(error, "loadSources error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            var result = oJSON.result;
            var sources = result.sources;
            for (var i = 0; i < sources.length; i++){
                fileProxyModel.sourceModel.append({"name": sources[i].label, "sortname": "0"+sources[i].label, "path": sources[i].file, "filetype": "directory", "playcount":0, "poster":""});
            }
            fileProxyModel.reSort()
        }
    }

    fileProxyModel.sourceModel.clear();
    var str = '{"jsonrpc": "2.0", "method": "Files.GetSources", "params": { "media": "video" }, "id": 1}';
    doc.send(str);
}

Library.prototype.loadFiles = function(fileProxyModel, directory) {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);
            console.debug(doc.responseText);

            var error = oJSON.error;
            if (error) {
                console.log(Utils.dumpObj(error, "loadFiles error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            var result = oJSON.result;
            var files = result.files;
            for (var i = 0; i < files.length; i++){
                var thumb = "";
                if (files[i].thumbnail && files[i].thumbnail != "") {
                    thumb = "http://"+globals.getJsonAuthString()+$().server+":" + $().port + "/vfs/" + files[i].thumbnail;
                }
                fileProxyModel.sourceModel.append({"name": files[i].label, "sortname": (files[i].filetype == "directory" ? "0" : "1")+files[i].label, "path": files[i].file, "filetype": files[i].filetype, "playcount": (files[i].playcount == null ? 0 : files[i].playcount), "poster": thumb });
            }
            fileProxyModel.reSort();
        }
    }

    fileProxyModel.sourceModel.clear();
    var o = { jsonrpc: "2.0", method: "Files.GetDirectory", params: { directory: directory, media: "video", "properties":["thumbnail","playcount"] }, id: 1};
    var str = JSON.stringify(o);
    console.debug(str);
    doc.send(str);
}

Library.prototype.downloadFile = function(inputPath, outputPath, filename) {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);

            var error = oJSON.error;
            if (error) {
                console.log(Utils.dumpObj(error, "downloadFile error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }
            var result = oJSON.result;
            var details = result.details;
            if (details) {
                if (result.mode == "redirect") {
                    var o = Qt.createQmlObject(
                            'import QtQuick 1.0; import com.semperpax.qmlcomponents 1.0; Download { onIsActiveChanged: downloadTab.checkQueue(); onIsFinishedChanged: downloadTab.checkQueue(); }',
                            downloadsModel, "download");
                    o.inputPath = "http://"+globals.getJsonAuthString()+$().server+":" + $().port + "/" + details.path
                    o.outputPath = outputPath
                    o.filename = filename
                    console.debug(details.path)
                    downloadsModel.append({"inputPath": "http://"+globals.getJsonAuthString()+$().server+":" + $().port + "/" + details.path, "outputPath": outputPath, "filename": filename, "downloadObject":o });
                }
            }
        }
    }


    var o = { jsonrpc: "2.0", method: "Files.PrepareDownload", params: { path: inputPath }, id: 1};
    var str = JSON.stringify(o);
    doc.send(str);

    return;
}

Library.prototype.downloadAlbum = function(idalbum) {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);

            var error = oJSON.error;
            if (error) {
                console.log(Utils.dumpObj(error, "downloadAlbum error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            var result = oJSON.result;
            var songs = result.songs;
            trackModel.clear();
            for (var i = 0; i < songs.length; i++){
                Library.prototype.downloadFile(songs[i].file, ctxDownloadMusicFolder+"/"+songs[i].artist+"/"+songs[i].album, Utils.sprintf("%.2d", songs[i].track)+"-"+songs[i].artist+"-"+songs[i].label)
            }
        }
    }


    trackModel.clear();
    var str = '{"jsonrpc": "2.0", "method": "AudioLibrary.GetSongs", "params": { "sort": {"method":"track", "order":"ascending"}, "properties": ["title", "artist", "album", "track", "file"], "albumid" : '+idalbum+' }, "id": 1}';
    doc.send(str);

    return;
}
