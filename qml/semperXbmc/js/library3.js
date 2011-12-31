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
        var thumb = "";
        if (movies[i].thumbnail && movies[i].thumbnail != "") {
            thumb = "http://"+globals.getJsonAuthString()+$().server+":" + $().port + "/vfs/" + movies[i].thumbnail;
        }
        var duration = 0;
        if (movies[i].streamdetails)
            duration = movies[i].streamdetails.video[0].duration;

        if (movies[i].genre && movies[i].genre != "") {
            var aGenre = movies[i].genre.split("/");
            for (var j=0; j<aGenre.length; ++j) {
                if (aGenres.indexOf(aGenre[j].trim()) == -1)
                    aGenres.push(aGenre[j].trim());
            }
        }

        movieModel.append({"id": movies[i].movieid, "name": movies[i].label, "poster": thumb, "genre":  movies[i].genre, "duration": duration, "runtime": movies[i].runtime, "rating": movies[i].rating, "year": movies[i].year, "imdbnumber": movies[i].imdbnumber, "originaltitle": movies[i].originaltitle, "playcount":movies[i].playcount, "resume":movies[i].resume});
        if (movies[i].resume && movies[i].resume.position!=0) {
            console.debug("resume " + movies[i].label + " @ " + movies[i].resume.position + "/" + movies[i].resume.total );
        }
    }

    aGenres.sort();
    for (var i = 0; i < aGenres.length; i++){
        movieGenreModel.append({"name": aGenres[i]});
    }
    movieProxyModel.reSort();
}

Library.prototype.loadMovies = function () {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            Library.prototype.handleMovies(doc.responseText);
        }
    }


    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetMovies", "params": { "sort": {"method":"sorttitle", "order":"ascending"}, "properties": ["genre", "title", "runtime", "year", "playcount", "rating", "thumbnail", "streamdetails", "imdbnumber", "originaltitle"] }, "id": 1}';
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


    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetRecentlyAddedMovies", "params": { "properties": ["genre", "title", "runtime", "year", "playcount", "rating", "thumbnail", "streamdetails", "imdbnumber", "originaltitle"] }, "id": 1}';
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
                console.log(Xbmc.dumpObj(error, "loadTVs error", "", 0));
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


    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetTVShows", "params": { "sort": {"method":"sorttitle", "order":"ascending"}, "properties": ["genre", "plot", "episode", "year", "playcount", "rating", "thumbnail", "originaltitle", "imdbnumber"] }, "id": 1}';
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
                console.log(Xbmc.dumpObj(error, "loadSeasons error", "", 0));
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
        }
    }


    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetSeasons", "params": { "tvshowid":'+ Library.prototype.tvshowId +', "sort": {"method":"label", "order":"ascending"}, "properties": ["thumbnail", "showtitle", "season", "episode", "playcount"] }, "id": 1}';
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

        var thumb = "";
        if (episodes[i].thumbnail && episodes[i].thumbnail != "") {
            thumb = "http://"+globals.getJsonAuthString()+$().server+":" + $().port + "/vfs/" + episodes[i].thumbnail;
        }

        var duration = 0;
        if (episodes[i].streamdetails)
            duration = episodes[i].streamdetails.video[0].duration;

        episodeModel.append({"id": episodes[i].episodeid, "name": episodes[i].label, "poster": thumb, "tvshowId": episodes[i].tvshowid, "showtitle": episodes[i].showtitle, "season": episodes[i].season, "number":  episodes[i].episode, "duration": duration, "rating": episodes[i].rating, "playcount":episodes[i].playcount, "resume":episodes[i].resume});
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


    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetEpisodes", "params": { "tvshowid":'+ Library.prototype.tvshowId +', "season":'+ id +', "sort": {"method":"episode", "order":"ascending"}, "properties": ["thumbnail", "tvshowid", "showtitle", "season", "episode", "playcount", "rating", "streamdetails", "resume"] }, "id": 1}';
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


    var str = '{"jsonrpc": "2.0", "method": "VideoLibrary.GetRecentlyAddedEpisodes", "params": { "properties": ["thumbnail", "tvshowid", "showtitle", "season", "episode", "playcount", "rating", "streamdetails"] }, "id": 1}';
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
                console.log(Xbmc.dumpObj(error, "loadTracks error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            var result = oJSON.result;
            var songs = result.songs;
            trackModel.clear();
            for (var i = 0; i < songs.length; i++){
                trackModel.append({"idtrack": songs[i].songid, "name": songs[i].label, "artist": songs[i].artist, "number": songs[i].track, "duration": songs[i].duration, "path": songs[i].file});
            }
        }
    }


    var str = '{"jsonrpc": "2.0", "method": "AudioLibrary.GetSongs", "params": { "sort": {"method":"track", "order":"ascending"}, "properties": ["title", "artist", "genre", "track", "duration", "file"], "albumid" : '+idalbum+' }, "id": 1}';
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

        var thumb = "";
        if (albums[i].thumbnail && albums[i].thumbnail != "") {
            thumb = "http://"+globals.getJsonAuthString()+$().server+":" + $().port + "/vfs/" + albums[i].thumbnail;
        }

        albumModel.append({"idalbum": albums[i].albumid, "name": albums[i].label, "artist": albums[i].artist, "genre":albums[i].genre, "rating": albums[i].rating,  "cover": thumb});
    }
    albumProxyModel.reSort();
}

Library.prototype.loadAlbums = function (idartist) {
    albumModel.clear();
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            Library.prototype.handleAlbums(doc.responseText)
        }
    }


    var str = '{"jsonrpc": "2.0", "method": "AudioLibrary.GetAlbums", "params": { "sort": {"method":"album", "order":"ascending"}, "properties": ["albumlabel", "artist", "genre", "rating", "year", "thumbnail"], "artistid": '+idartist+' }, "id": 1}';
    doc.send(str);
    albumModel.clear();

    return;
}

Library.prototype.loadAllAlbums = function () {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            Library.prototype.handleAlbums(doc.responseText)
        }
    }


    var str = '{"jsonrpc": "2.0", "method": "AudioLibrary.GetAlbums", "params": { "sort": {"method":"album", "order":"ascending"}, "properties": ["albumlabel", "artist", "genre", "rating", "year", "thumbnail"]}, "id": 1}';
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


    var str = '{"jsonrpc": "2.0", "method": "AudioLibrary.GetRecentlyAddedAlbums", "params": { "properties": ["albumlabel", "artist", "genre", "rating", "year", "thumbnail"]}, "id": 1}';
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
                console.log(Xbmc.dumpObj(error, "loadArtists error", "", 0));
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

    var str = '{"jsonrpc": "2.0", "method": "AudioLibrary.GetArtists", "params": { "sort": {"method":"artist", "order":"ascending"}, "properties": ["thumbnail"] }, "id": 1}';
    doc.send(str);
    artistModel.clear();
}

Library.prototype.loadSources = function(fileModel) {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);

            var error = oJSON.error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "loadSources error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            var result = oJSON.result;
            var sources = result.sources;
            for (var i = 0; i < sources.length; i++){
                fileModel.append({"name": sources[i].label, "path": sources[i].file, "filetype": "directory"});
            }
        }
    }

    var str = '{"jsonrpc": "2.0", "method": "Files.GetSources", "params": { "media": "video" }, "id": 1}';
    doc.send(str);
    fileModel.clear();
}

Library.prototype.loadFiles = function(fileModel, directory) {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);
            console.debug(doc.responseText);

            var error = oJSON.error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "loadFiles error", "", 0));
                errorView.addError("error", error.message, error.code);
                return;
            }

            var result = oJSON.result;
            var files = result.files;
            for (var i = 0; i < files.length; i++){
                fileModel.append({"name": files[i].label, "path": files[i].file, "filetype": files[i].filetype});
            }
        }
    }

    var o = { jsonrpc: "2.0", method: "Files.GetDirectory", params: { directory: directory, media: "video" }, id: 1};
    var str = JSON.stringify(o);
    console.debug(str);
    doc.send(str);
    fileModel.clear();
}

Library.prototype.downloadFile = function(inputPath, outputPath, filename) {
    var doc = new globals.getJsonXMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var oJSON = JSON.parse(doc.responseText);

            var error = oJSON.error;
            if (error) {
                console.log(Xbmc.dumpObj(error, "downloadFile error", "", 0));
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
                console.log(Xbmc.dumpObj(error, "downloadAlbum error", "", 0));
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


    var str = '{"jsonrpc": "2.0", "method": "AudioLibrary.GetSongs", "params": { "sort": {"method":"track", "order":"ascending"}, "properties": ["title", "artist", "album", "track", "file"], "albumid" : '+idalbum+' }, "id": 1}';
    doc.send(str);
    trackModel.clear();

    return;
}
