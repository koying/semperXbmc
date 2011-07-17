import QtQuick 1.0
import com.nokia.symbian 1.0
import com.semperpax.qmlcomponents 1.0
import "components" as Cp;

import "js/xbmc.js" as Xbmc
import "js/json.js" as Json

import "js/general.js" as General
import "js/player.js" as Player
import "js/library.js" as Library
import "js/playlist.js" as Playlist

import "js/general3.js" as General3
import "js/library3.js" as Library3
import "js/playlist3.js" as Playlist3
import "js/player3.js" as Player3

Window {
    id: main
    width: 360
    height: 640

    property bool jsonInitialized: false

    Globals {
        id: globals
    }

    Cp.ErrorView {
        id: errorView
        z: 5

       anchors.fill: parent
    }

//    StatusBar {
//        id: statusBar
//        property alias text: txTitle.text

//        anchors { top: parent.top; left: parent.left; right: parent.right }

//        Behavior on opacity {
//            NumberAnimation {
//                easing.type: Easing.InOutQuad
//            }
//        }

//        Text {
//            id: txTitle
//            anchors { left: parent.left; leftMargin: 10 }

//            color: "#2cb729"
//            font {
//                family: "Helvetica";
//                pixelSize: parent.height -5
//            }

//            text: root.currentTab.title
//        }

//        MouseArea {
//            id: statusArea
//            anchors.fill: parent
//        }
//    }

    ToolBar {
        id: toolBar
        anchors { left: parent.left; right: parent.right; top: parent.top }

        tools: ToolBarLayout {

            ToolButton {
                iconSource: "img/settings.svg"
                onClicked: settings.open()
            }

            ButtonRow {
                id: mainTabs
                exclusive: true
                opacity: 0

                TabButton {
                    iconSource: "img/home.png"
                    tab: remoteTab
                    onClicked: {
                        main.state = ""
                    }
                }

                TabButton {
                    iconSource: "img/filmstrip.png"
                    tab: movieTab
                    onClicked: {
                        main.state = "movies"
                        if (movieStack.depth == 0) {
//                            movieStack.push(Qt.resolvedUrl("MovieViewCover.qml"))
                            movieStack.push(Qt.resolvedUrl("MovieView.qml"))
                        }
                    }
                }

                TabButton {
                    iconSource: "img/tv.png"
                    tab: tvTab
                    onClicked: {
                        main.state = "tvshows"
                        if (tvshowStack.depth == 0) {
                            tvshowStack.push(Qt.resolvedUrl("TvShowView.qml"))
                        }
                    }
                }

                TabButton {
                    iconSource: "img/music.png"
                    tab: musicTab
                    onClicked: {
                        main.state = "music"
                        if (musicStack.depth == 0) {
                            musicStack.push(Qt.resolvedUrl("MusicArtistView.qml"))
                        }
                    }
                }

                TabButton {
                    iconSource: "img/playlist.png"
                    tab:  playlistTab
                    onClicked: {
                        main.state = "playlist"
                        if (playListStack.depth == 0) {
                            playListStack.push(Qt.resolvedUrl("PlayListView.qml"))
                        }
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        easing.type: Easing.InOutQuad
                    }
                }

                states: [
                    State {
                        name: "initialized"; when: main.jsonInitialized
                        PropertyChanges {
                            target: mainTabs
                            opacity: 1
                        }
                    }
                ]
            }

            ToolButton {
                iconSource: "img/close_stop.svg"
                onClicked: mainMenu.open()
            }
        }
    }

    ContextMenu {
        id: mainMenu
        MenuLayout {

            MenuItem {
                text:  "Quit"
                onClicked: Qt.quit();
            }

            MenuItem {
                text:  "Close XBMC and Quit"
                onClicked: {
                    xbmcEventClient.actionBuiltin("Quit");
                    Qt.quit();
                }
            }

            MenuItem {
                text:  "Shutdown XBMC and Quit"
                onClicked:  {
                    xbmcEventClient.actionBuiltin("Powerdown");
                    Qt.quit();
                }
            }
        }
    }

    TabGroup {
        id: root
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: toolBar.bottom
        anchors.bottom: parent.bottom


        RemoteView {
            id: remoteTab
            property string title: "REMOTE"
        }

        Item {
            id: movieTab

            PageStack {
                id: movieStack

                property string title: "MOVIES"

                anchors { top: parent.top; left: parent.left; right: parent.right; bottom: movieToolbar.top }
                toolBar: movieToolbar
            }

            ToolBar {
                id: movieToolbar
                anchors { bottom: parent.bottom; left: parent.left; right: parent.right }

                Behavior on opacity {
                    NumberAnimation {
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }

        Item {
            id: tvTab
            PageStack {
                id: tvshowStack

                property string title: "TV"

                anchors { top: parent.top; left: parent.left; right: parent.right; bottom: tvToolbar.top }
                toolBar: tvToolbar

            }
            ToolBar {
                id: tvToolbar
                anchors { bottom: parent.bottom; left: parent.left; right: parent.right }

                Behavior on opacity {
                    NumberAnimation {
                        easing.type: Easing.InOutQuad
                    }
                }
            }

        }

        Item {
            id: musicTab

            PageStack {
                id: musicStack

                property string title: "MUSIC"

                anchors { top: parent.top; left: parent.left; right: parent.right; bottom: musicToolbar.top }
                toolBar: musicToolbar

            }

            ToolBar {
                id: musicToolbar
                anchors { bottom: parent.bottom; left: parent.left; right: parent.right }

                Behavior on opacity {
                    NumberAnimation {
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }

        Item {
            id: playlistTab

            PageStack {
                id: playListStack

                property string title: "PLAYLIST"

                anchors { top: parent.top; left: parent.left; right: parent.right; bottom: playListToolbar.top }
                toolBar: playListToolbar

            }

            ToolBar {
                id: playListToolbar
                anchors { bottom: parent.bottom; left: parent.left; right: parent.right }

                Behavior on opacity {
                    NumberAnimation {
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }
    }

    Settings {
        id: settings
        titleText: "SETTINGS"

        onSettingsChanged: {
            remoteTab.settingsChanged();
            main.initialize();
        }
    }


    /* Globale Models */
    VariantModel {
        id: artistModel
        fields: [ "id", "name", "poster", "selected", "posterThumb" ]
        thumbDir: "fat:///c:/semperXbmcThumbs.fat#/"
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
    VariantModel {
        id: movieModel
        fields: [ "id", "name", "poster", "genre", "duration", "runtime", "rating", "playcount", "posterThumb" ]
        thumbDir: "fat:///c:/semperXbmcThumbs.fat#/"
    }
    VariantModel {
        id: tvshowModel
        fields: [ "id", "name", "poster", "genre", "duration", "rating", "playcount", "posterThumb" ]
        thumbDir: "fat:///c:/semperXbmcThumbs.fat#/"
    }
    ListModel {
        id: seasonModel
    }
    ListModel {
        id: episodeModel
    }

    XbmcClient {
        id: xbmcEventClient

        onErrorDetected: {
            errorView.addError(type, msg, info);
        }
    }

    function $() {
        return Xbmc.xbmc;
    }

    function initialize() {
//        console.log("xbmc initialization");

        Xbmc.xbmc = new Xbmc.Xbmc();
        Xbmc.xbmc.port = globals.jsonPort;
        Xbmc.xbmc.server = globals.server;
//        Xbmc.xbmc.introspect();
        Xbmc.xbmc.init();

    }

    Component.onCompleted: {
        globals.load();
        settings.setup();
        xbmcEventClient.initialize(globals.server, globals.eventPort);
        initialize();
    }
}
