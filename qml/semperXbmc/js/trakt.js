var trakt;

function Trakt()
{
}

Trakt.prototype.loadMoviesWatchlist = function () {
    var doc = new globals.getTraktHttpRequest("GET", "user/watchlist/movies", globals.traktUser);
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
//            console.debug(doc.responseText)
            var oJSON = JSON.parse(doc.responseText);

            var movies = oJSON
            for (var i = 0; i < movies.length; i++){

                var imdbnum = parseInt(movies[i].imdb_id.slice(2),10)
                movieModel.append({"id": 0, "name": movies[i].title, "poster": movies[i].images.poster, "genre":  movies[i].genres.join(), "duration": 0, "runtime": movies[i].runtime, "rating": movies[i].ratings.percentage/10, "year": movies[i].year, "imdbnumber": imdbnum, "originaltitle": movies[i].title, "playcount":0, "resume":0});
            }
            $().library.updateMoviesByImdb(movieModel)
        }
    }

    doc.send();

    return;
}
