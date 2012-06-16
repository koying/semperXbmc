import QtQuick 1.0
import com.semperpax.qmlcomponents 1.0

import "js/Utils.js" as Utils

Item {
    property string server: "Unspecified"
    property string jsonPort: "8080"
    property string jsonUser: ""
    property string jsonPassword: ""
    property string jsonTcpPort: "9090"
    property string eventPort: "9777"
    property string traktUser: ""
    property string traktPassword: ""

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
    property string styleFiles: "smallHorizontal"

    property string initialMovieView: "MovieView.qml"
    property string initialTvshowView: "TvShowView.qml"
    property string initialMusicView: "MusicArtistView.qml"

    property string initialMovieSort:  ""
    property string initialTvshowSort:  ""

    VariantModel {
        id: settingsBackend
        fields: ["key", "value"]
        key: "key"

        stream: ctxFatFile + "/settings.dat"

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
        jsonUser = settingsBackend.getSetting("jsonUser", jsonUser);
        jsonPassword = settingsBackend.getSetting("jsonPassword", jsonPassword);
        eventPort = settingsBackend.getSetting("eventPort", eventPort);
        traktUser = settingsBackend.getSetting("traktUser", traktUser);
        traktPassword = settingsBackend.getSetting("traktPassword", traktPassword);

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
        settingsBackend.setSetting("jsonUser", jsonUser);
        settingsBackend.setSetting("jsonPassword", jsonPassword);
        settingsBackend.setSetting("eventPort", eventPort);
        settingsBackend.setSetting("traktUser", traktUser);
        settingsBackend.setSetting("traktPassword", traktPassword);

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

    function getJsonAuthString() {
        if (jsonUser != "") {
            return (jsonUser + ":" + jsonPassword + "@")
        } else
            return "";
    }

    function getJsonXMLHttpRequest() {
        var request = new XMLHttpRequest();
        request.open("POST", "http://"+server+":" + jsonPort + "/jsonrpc");
        request.setRequestHeader("Content-Type", "application/json")
        if (jsonUser != "") {
            request.setRequestHeader("Authorization", "Basic "+Qt.btoa(jsonUser+":"+jsonPassword))
        }
        return request;
    }

    function getTraktAuthString() {
        if (traktUser != "") {
            return (traktUser + ":" + Utils.SHA1(traktPassword) + "@")
        } else
            return "";
    }

    function getTraktHttpRequest(method, verb, param) {
        var url = "http://api.trakt.tv/" + verb + ".json/aa8ef30168ad03a9ecc40dda2b0f1ace"
        if (param != "")
            url += "/" + param
        var request = new XMLHttpRequest();
        request.open(method, url );
        if (traktUser != "") {
            request.setRequestHeader("Authorization", "Basic "+Qt.btoa(traktUser+":"+Utils.SHA1(traktPassword)))
        }
        console.debug(url)
        return request;
    }

    Component.onDestruction: save()
}
