import QtQuick 1.0
import com.nokia.symbian 1.0
import com.semperpax.qmlcomponents 1.0

import "js/xbmc.js" as Xbmc
import "js/json.js" as Json

import "js/general.js" as General
import "js/player.js" as Player
import "js/library.js" as Library
import "js/playlist.js" as Playlist

import "js/library3.js" as Library3

Window {
    id: main
    width: 360
    height: 640

    Globals {
        id: globals
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
                TabButton {
                    iconSource: "img/home.png"
                    tab: remoteTab
                    onClicked: main.state = ""
                }

                TabButton {
                    iconSource: "img/filmstrip.png"
                    tab: movieTab
                    onClicked: main.state = "movies"
                }

                TabButton {
                    iconSource: "img/tv.png"
                    tab: tvTab
                    onClicked: main.state = "tvshows"
                }

                TabButton {
                    iconSource: "img/music.png"
                    tab: musicTab
                    onClicked: main.state = "music"
                }

                TabButton {
                    iconSource: "img/playlist.png"
                    tab:  playlistTab
                    onClicked: main.state = "playlist"
                }
            }

            ToolButton {
                iconSource: "img/close_stop.svg"
                onClicked: Qt.quit()
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
            id: tvTab
            PageStack {
                id: tvshowStack

                property string title: "TV"

                anchors { top: parent.top; left: parent.left; right: parent.right; bottom: tvToolbar.top }

                toolBar: tvToolbar

                Component.onCompleted: {
                    tvshowStack.push(Qt.resolvedUrl("TvShowView.qml"))
                }
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
            id: movieTab

            PageStack {
                id: movieStack

                property string title: "MOVIES"

                anchors { top: parent.top; left: parent.left; right: parent.right; bottom: movieToolbar.top }

                toolBar: movieToolbar

                Component.onCompleted: {
                    movieStack.push(Qt.resolvedUrl("MovieView.qml"))
                }
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
            id: musicTab

            PageStack {
                id: musicStack

                property string title: "MUSIC"

                anchors { top: parent.top; left: parent.left; right: parent.right; bottom: musicToolbar.top }

                toolBar: musicToolbar

                Component.onCompleted: {
                    musicStack.push(Qt.resolvedUrl("MusicArtistView.qml"))
                }
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

                Component.onCompleted: {
                    playListStack.push(Qt.resolvedUrl("PlayListView.qml"))
                }
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

    XbmcClient {
        id: xbmcEventClient
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
        initialize();
    }
}
