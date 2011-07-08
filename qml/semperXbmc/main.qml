import QtQuick 1.0
import com.nokia.symbian 1.0

import "js/xbmc.js" as Xbmc
import "js/player.js" as Player
import "js/library.js" as Library
import "js/playlist.js" as Playlist
import "js/json.js" as Json

Window {
    id: main
    width: 360
    height: 640

    Globals {
        id: globals
    }

    StatusBar {
        id: statusBar
        property alias text: txTitle.text

        anchors { top: parent.top; left: parent.left; right: parent.right }

        Behavior on opacity {
            NumberAnimation {
                easing.type: Easing.InOutQuad
            }
        }

        Text {
            id: txTitle
            anchors { left: parent.left; leftMargin: 10 }

            color: "#2cb729"
            font {
                family: "Helvetica";
                pixelSize: parent.height -5
            }

            text: "REMOTE"
        }

        MouseArea {
            id: statusArea
            anchors.fill: parent
        }
    }

    TabGroup {
        id: root
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: statusBar.bottom
        anchors.bottom: toolBar.top


        RemoteView {
            id: remoteView
        }

        PageStack {
            id: tvshowView
            toolBar: toolBar

            Component.onCompleted: {
                tvshowView.push(Qt.resolvedUrl("TvshowView.qml"))
            }
        }

        PageStack {
            id: movieView

            toolBar: toolBar

            Component.onCompleted: {
                movieView.push(Qt.resolvedUrl("MovieView.qml"))
            }
        }
    }


    ToolBarLayout {
        id: pgTools

        ToolButton {
            visible: false
        }

        ButtonRow {
            TabButton {
                iconSource: "img/home.png"
                tab: remoteView
                onClicked: main.state = ""
            }

            TabButton {
                iconSource: "img/filmstrip.png"
                tab: movieView
                onClicked: main.state = "movies"
            }

            TabButton {
                iconSource: "img/tv.png"
                tab: tvshowView
                onClicked: main.state = "tvshows"
            }

            TabButton {
                iconSource: "img/music.png"
                onClicked: main.state = "music"
            }

            TabButton {
                iconSource: "img/playlist.png"
                onClicked: main.state = "playlist"
            }
        }

        ToolButton {
            iconSource: "toolbar-menu"
            onClicked: pgMenu.open()
        }
    }

    Menu {
        id: pgMenu
        content: MenuLayout {
            MenuItem {
                text: "Quit"
                onClicked: Qt.quit()
            }
        }
    }

    ToolBar {
        id: toolBar
        property string backState

        anchors { bottom: parent.bottom; left: parent.left; right: parent.right }

        tools: pgTools

        Behavior on opacity {
            NumberAnimation {
                easing.type: Easing.InOutQuad
            }
        }
    }

    states: [
        State {
            name: "tvshows"
            PropertyChanges {
                target: statusBar
                text: "TV SHOWS"
            }
        },
        State {
            name: "movies"
            PropertyChanges {
                target: statusBar
                text: "MOVIES"
            }
        }
    ]

    Settings {
        id: settings
        x: 30
        y: 170

        onSettingsChanged: {
            remoteView.settingsChanged();
            main.initialize();
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
//        console.log("xbmc initialization");

        var xbmc = Xbmc.setup();
        xbmc.port = globals.jsonPort;
        xbmc.server = globals.server;

        xbmc.library = new Library.Library();
        xbmc.playlist = new Playlist.Playlist();
        xbmc.player = new Player.Player();

        xbmc.init();
    }
}
