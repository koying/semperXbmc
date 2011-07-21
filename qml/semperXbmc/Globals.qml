import QtQuick 1.0
import "js/settings.js" as DbSettings

QtObject {
    property string server: "Unspecified"
    property string jsonPort: "8080"
    property string eventPort: "9777"

    property bool showSplash: true
    property bool cacheThumbnails: true
    property bool showViewed: true
    property bool sortAscending: false
    property bool showBanners: true

    property string styleMovies: "smallHorizontal"
    property string styleTvShows: "smallHorizontal"
    property string styleTvShowSeasons: "bigHorizontal"
    property string styleMusicArtists: "smallHorizontal"
    property string styleMusicAlbums: "bigHorizontal"

    property string initialMovieView: "MovieView.qml"
    property string initialMusicView: "MusicArtistView.qml"

    function load() {
        DbSettings.initialize();

        server = DbSettings.getSetting("server", server);
        jsonPort = DbSettings.getSetting("jsonPort", jsonPort);
        eventPort = DbSettings.getSetting("eventPort", eventPort);

        showSplash = DbSettings.getSetting("showSplash", showSplash);
        cacheThumbnails = DbSettings.getSetting("cacheThumbnails", cacheThumbnails);
        showViewed = DbSettings.getSetting("showViewed", showViewed);
        sortAscending = DbSettings.getSetting("sortAscending", sortAscending);
        showBanners = DbSettings.getSetting("showBanners", showBanners);

        styleMovies = DbSettings.getSetting("styleMovies", styleMovies);
        styleTvShows = DbSettings.getSetting("styleTvShows", styleTvShows);
        styleTvShowSeasons = DbSettings.getSetting("styleTvShowSeasons", styleTvShowSeasons);
        styleMusicArtists = DbSettings.getSetting("styleMusicArtists", styleMusicArtists);
        styleMusicAlbums = DbSettings.getSetting("styleMusicAlbums", styleMusicAlbums);

        initialMovieView = DbSettings.getSetting("initialMovieView", initialMovieView);
        initialMusicView = DbSettings.getSetting("initialMusicView", initialMusicView);
    }

    function save() {
        DbSettings.setSetting("server", server);
        DbSettings.setSetting("jsonPort", jsonPort);
        DbSettings.setSetting("eventPort", eventPort);

        DbSettings.setSetting("showSplash", showSplash);
        DbSettings.setSetting("cacheThumbnails", cacheThumbnails);
        DbSettings.setSetting("showViewed", showViewed);
        DbSettings.setSetting("sortAscending", sortAscending);
        DbSettings.setSetting("showBanners", showBanners);

        DbSettings.setSetting("styleMovies", styleMovies);
        DbSettings.setSetting("styleTvShows", styleTvShows);
        DbSettings.setSetting("styleTvShowSeasons", styleTvShowSeasons);
        DbSettings.setSetting("styleMusicArtists", styleMusicArtists);
        DbSettings.setSetting("styleMusicAlbums", styleMusicAlbums);

        DbSettings.setSetting("initialMovieView", initialMovieView);
        DbSettings.setSetting("initialMusicView", initialMusicView);
    }

    Component.onDestruction: save()
}
