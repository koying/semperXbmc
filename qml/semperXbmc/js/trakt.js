var trakt;

function Trakt()
{
}

Trakt.prototype.loadMoviesWatchlist = function () {
    var doc = new globals.getTraktHttpRequest("GET", "user/watchlist/movies", globals.traktUser);
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            console.debug(doc.responseText)
            var oJSON = JSON.parse(doc.responseText);

            var movies = oJSON
            for (var i = 0; i < movies.length; i++){
                movieModel.append({"id": 0, "name": movies[i].title, "poster": movies[i].images.poster, "genre":  movies[i].genres.join(), "duration": 0, "runtime": movies[i].runtime, "rating": movies[i].year, "year": movies[i].year, "imdbnumber": movies[i].imdb_id, "originaltitle": movies[i].title, "playcount":0, "resume":0});
            }
        }
    }

    doc.send();

    return;
}
