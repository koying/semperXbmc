import Qt 4.7
import "js/xbmc.js" as Xbmc
import "js/player.js" as Player
import "js/library.js" as Library
import "js/playlist.js" as Playlist
import "js/json.js" as Json

Rectangle {
    id: base
    width: 800
    height: 600
    color: "#000000"
    state: "album"

    Image {
        x: 0
        y: 0
        width: parent.width
        height: parent.height
        id: background
        source: "img/bg.jpg"
        anchors.fill: parent;
    }


    Control {
        id: controlComponent
        function back() {
            if (base.state == "playlist") {
                base.state = "album";
            }
            else {
                // do nothing
            }
        }
    }

    AlbumGridView {
        z: 2
        x: 800
        id: albumComponent
        function append(id){
            base.state = "playlist";
            Xbmc.xbmc.playlist.addAlbum(id);
        }
        function replace(id){
            base.state = "playlist";
            Xbmc.xbmc.playlist.clear();
            Xbmc.xbmc.playlist.addAlbum(id);
        }
    }
    Playlist {
        x: 800
        id: playlistComponent

        function clicked(idartist){
            base.state = "playlist";
        }
    }

    states: [
        State {
            name: "album"

            PropertyChanges {
                target: albumComponent
                x: 0
            }
            PropertyChanges {
                target: playlistComponent
                x: 800
            }
        },
        State {
            name: "playlist"

            PropertyChanges {
                target: albumComponent
                x: -800
            }
            PropertyChanges {
                target: playlistComponent
                x: 0
            }
        }
    ]
    transitions: Transition {
         PropertyAnimation {
            properties: "x";
            easing.type: Easing.InOutQuad
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


    function $() {
        return Xbmc.xbmc;
    }

    function setup() {
        var xbmc = Xbmc.setup();
        xbmc.library = new Library.Library();
        xbmc.playlist = new Playlist.Playlist();
        xbmc.player = new Player.Player();

        xbmc.init();
    }

    Component.onCompleted: setup();
}
