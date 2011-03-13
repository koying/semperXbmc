import QtQuick 1.0
import "js/xbmc.js" as Xbmc
import "js/player.js" as Player
import "js/library.js" as Library
import "js/playlist.js" as Playlist
import "js/json.js" as Json

import "bar" as Bar

Rectangle {
    id: main
    width: 360
    height: 640

    Globals {
        id: globals
    }

    Item {
        id: root
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: titlebar.bottom
        anchors.bottom: toolbar.top


        RemoteView {
            id: remoteView
            anchors.fill: parent
        }

        TvshowView {
            id: tvshowView
            z: 1
            opacity:  0
        }

        MovieView {
            id: movieView
            z: 1
            opacity:  0
        }
    }

    Bar.TitleBar {
        id: titlebar

        height : 52
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right:  parent.right
        text: "REMOTE"

        onPrefClicked: settings.state = "shown";
        onQuitClicked: Qt.quit()
        onHomeClicked: main.state = ""
        onBackClicked: {
            console.debug("back");
            switch(main.state) {
            case "tvshows":
                if (tvshowView.back())
                    main.state = ""
                break;
            case "movies":
                if (movieView.back())
                    main.state = ""
                break;
            }
        }

    }

    Bar.ToolBar {
        id: toolbar

        height : 55
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right:  parent.right

        onTvshowsRequested: main.state = "tvshows"
        onMoviesRequested: main.state = "movies"
    }

    Settings {
        id: settings
        x: 30
        y: 170

        onSettingsChanged: {
            remoteView.settingsChanged();
            main.initialize();
        }
    }

    states: [
        State {
            name: "tvshows"
            PropertyChanges {
                target: tvshowView
                opacity: 1
                x: 0;
            }
            PropertyChanges {
                target: titlebar
                text: "TV SHOWS"
                state: "content"
            }
        },
        State {
            name: "movies"
            PropertyChanges {
                target: movieView
                opacity: 1
                x: 0;
            }
            PropertyChanges {
                target: titlebar
                text: "MOVIES"
                state: "content"
            }
        }
    ]

    transitions: Transition {
        PropertyAnimation {
            properties: "opacity";
            easing.type: Easing.InOutCubic
            duration: 500
        }
    }


    /* Globale Models */
    ListModel {
        id: artistModel
    }
    ListModel {
        id: albumModel
    }
    ListModel {
        id: trackModel
    }
    ListModel {
        id: playlistModel
    }
    ListModel {
        id: movieModel
    }
    ListModel {
        id: tvshowModel
    }
    ListModel {
        id: seasonModel
    }
    ListModel {
        id: episodeModel
    }

    function $() {
        return Xbmc.xbmc;
    }

    function initialize() {
        console.log("xbmc initialization");

        var xbmc = Xbmc.setup();
        xbmc.port = globals.jsonPort;
        xbmc.server = globals.server;

        xbmc.library = new Library.Library();
        xbmc.playlist = new Playlist.Playlist();
        xbmc.player = new Player.Player();

        xbmc.init();
    }
}
