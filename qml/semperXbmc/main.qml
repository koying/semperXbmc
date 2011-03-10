import QtQuick 1.0
import "js/xbmc.js" as Xbmc
import "js/player.js" as Player
import "js/library.js" as Library
import "js/playlist.js" as Playlist
import "js/json.js" as Json

Rectangle {
    id: rectangle2
    width: 360
    height: 640

    Rectangle {
        id: bar
        width: 40
        height: 640
        color: "#000000"
        radius: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
    }

    RemoteNavigation {
        id: remotenavigation1
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: bar.right
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0

        onBLClicked: {
            $().player.playPause();
        }
        onBRClicked: {
            $().player.stop();
        }

    }

    function $() {
        return Xbmc.xbmc;
    }

    function setup() {
        var xbmc = Xbmc.setup();
        xbmc.port = _port;
        xbmc.server = _server;
        console.log(_server);

        xbmc.library = new Library.Library();
        xbmc.playlist = new Playlist.Playlist();
        xbmc.player = new Player.Player();

        xbmc.init();
    }

    Component.onCompleted: setup();
}
