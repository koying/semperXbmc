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

    RemoteNavigation {
        id: remotenavigation1
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: titlebar.bottom
        anchors.topMargin: 0

        onBLClicked: {
            $().player.playPause();
        }
        onBRClicked: {
            $().player.stop();
        }

    }

    Bar.TitleBar {
        id: titlebar

        height : 52
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right:  parent.right

        onPrefClicked: {
            settings.state = "shown";
        }
        onQuitClicked:  Qt.quit()
    }

    Bar.ToolBar {
        id: toolbar

        height : 40
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right:  parent.right
    }

    Settings {
        id: settings
        x: 30
        y: 170

        onSettingsChanged: {
            main.initialize();
        }
    }

    function $() {
        return Xbmc.xbmc;
    }

    function initialize() {
        var xbmc = Xbmc.setup();
        xbmc.port = settings.jsonPort;
        xbmc.server = settings.server;

        xbmc.library = new Library.Library();
        xbmc.playlist = new Playlist.Playlist();
        xbmc.player = new Player.Player();

        xbmc.init();
    }
}
