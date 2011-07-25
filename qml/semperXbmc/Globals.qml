import QtQuick 1.0
import com.semperpax.qmlcomponents 1.0

Item {
    property string server: "Unspecified"
    property string jsonPort: "8080"
    property string jsonTcpPort: "9090"
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
    property string initialTvshowView: "TvShowView.qml"
    property string initialMusicView: "MusicArtistView.qml"

    property string initialMovieSort:  "name"
    property string initialTvshowSort:  "name"

    VariantModel {
        id: settingsBackend
        fields: ["key", "value"]
        key: "key"

        stream: thumbFile + "/settings.dat"

        function getSetting(keyval, defval) {
            return settingsBackend.getValue(keyval, "value", defval);
        }
        function setSetting(keyval, val) {
            settingsBackend.setValue(keyval, "value", val);
        }

    }

    function load() {
        settingsBackend.load();

        server = settingsBackend.getSetting("server", server);
        jsonPort = settingsBackend.getSetting("jsonPort", jsonPort);
        eventPort = settingsBackend.getSetting("eventPort", eventPort);

        showSplash = settingsBackend.getSetting("showSplash", showSplash);
        cacheThumbnails = settingsBackend.getSetting("cacheThumbnails", cacheThumbnails);
        showViewed = settingsBackend.getSetting("showViewed", showViewed);
        sortAscending = settingsBackend.getSetting("sortAscending", sortAscending);
        showBanners = settingsBackend.getSetting("showBanners", showBanners);

        styleMovies = settingsBackend.getSetting("styleMovies", styleMovies);
        styleTvShows = settingsBackend.getSetting("styleTvShows", styleTvShows);
        styleTvShowSeasons = settingsBackend.getSetting("styleTvShowSeasons", styleTvShowSeasons);
        styleMusicArtists = settingsBackend.getSetting("styleMusicArtists", styleMusicArtists);
        styleMusicAlbums = settingsBackend.getSetting("styleMusicAlbums", styleMusicAlbums);

        initialMovieView = settingsBackend.getSetting("initialMovieView", initialMovieView);
        initialTvshowView = settingsBackend.getSetting("initialTvshowView", initialTvshowView);
        initialMusicView = settingsBackend.getSetting("initialMusicView", initialMusicView);

        initialMovieSort = settingsBackend.getSetting("initialMovieSort", initialMovieSort);
        initialTvshowSort = settingsBackend.getSetting("initialTvshowSort", initialTvshowSort);
    }

    function save() {
        settingsBackend.setSetting("server", server);
        settingsBackend.setSetting("jsonPort", jsonPort);
        settingsBackend.setSetting("eventPort", eventPort);

        settingsBackend.setSetting("showSplash", showSplash);
        settingsBackend.setSetting("cacheThumbnails", cacheThumbnails);
        settingsBackend.setSetting("showViewed", showViewed);
        settingsBackend.setSetting("sortAscending", sortAscending);
        settingsBackend.setSetting("showBanners", showBanners);

        settingsBackend.setSetting("styleMovies", styleMovies);
        settingsBackend.setSetting("styleTvShows", styleTvShows);
        settingsBackend.setSetting("styleTvShowSeasons", styleTvShowSeasons);
        settingsBackend.setSetting("styleMusicArtists", styleMusicArtists);
        settingsBackend.setSetting("styleMusicAlbums", styleMusicAlbums);

        settingsBackend.setSetting("initialMovieView", initialMovieView);
        settingsBackend.setSetting("initialTvshowView", initialTvshowView);
        settingsBackend.setSetting("initialMusicView", initialMusicView);

        settingsBackend.setSetting("initialMovieSort", initialMovieSort);
        settingsBackend.setSetting("initialTvshowSort", initialTvshowSort);

        settingsBackend.save();
    }

    Component.onDestruction: save()
}
