import Qt 4.7
import "js/xbmc.js" as Xbmc
import "js/script.js" as Script
import "js/json.js" as Json

Rectangle {
    id: base
    width: 800
    height: 480
    color: "#000000"
    state: "home"

    Control {
        id: controlComponent
        function back() {

            if (base.state == "playlist") {
                base.state = "album";
            }
            else if(base.state == "album"){
                base.state = "artist";
            }
            else {
                base.state = "home";
            }
        }
    }

    Item {
        x: 20
        id: homeComponent
        Button {
            y: 220
            //text: "Video"
            source: "img/folder_video.svg"
            width: 120
            height: 120
            function clicked() {
                base.state = "video"
                Xbmc.xbmc.player.type = "Video"
            }
        }
        Button {
            //text: "Music"
            source: "img/folder_sound.svg"
            y: 80
            width: 120
            height: 120
            function clicked() {
                base.state = "artist"
            }
        }
        Button {
            //text: "Photos"
            source: "img/folder_image.svg"
            y: 360
            width: 120
            height: 120
            function clicked() {
                base.state = "artist"
            }
        }
    }

    Video {
        id: videoComponent
    }

    Artist {
        id: artistComponent

        function clicked(idartist){
            base.state = "album";
            //Xbmc.xbmc.library.loadAlbums(idartist);
            albumComponent.loadAlbums(idartist);
        }
    }
    AlbumView {
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
            name: "home"

            PropertyChanges {
                target: videoComponent
                x: 800
            }
            PropertyChanges {
                target: artistComponent
                x: 800
            }
            PropertyChanges {
                target: albumComponent
                x: 800
            }
            PropertyChanges {
                target: playlistComponent
                x: 800
            }
        },

        State {
            name: "video"

            PropertyChanges {
                target: videoComponent
                x: 0
            }
            PropertyChanges {
                target: homeComponent
                x: -800
            }
            PropertyChanges {
                target: artistComponent
                x: 800
            }
            PropertyChanges {
                target: albumComponent
                x: 800
            }
            PropertyChanges {
                target: playlistComponent
                x: 800
            }
        }
        ,
        State {
            name: "artist"
            PropertyChanges {
                target: homeComponent
                x: -800
            }
            PropertyChanges {
                target: videoComponent
                x: 800
            }
            PropertyChanges {
                target: artistComponent
                x: 0
            }
            PropertyChanges {
                target: albumComponent
                x: 800
            }
            PropertyChanges {
                target: playlistComponent
                x: 800
            }
        },
        State {
            name: "album"
            PropertyChanges {
                target: homeComponent
                x: -800
            }
            PropertyChanges {
                target: videoComponent
                x: 800
            }
            PropertyChanges {
                target: artistComponent
                x: -800
            }

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
                target: artistComponent
                x: -800
            }
            PropertyChanges {
                target: videoComponent
                x: 800
            }
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

    function $() {
        return Xbmc.xbmc;
    }

    function setup() {
        var xbmc = Xbmc.setup();
        xbmc.port = _port;
        xbmc.server = _server;
        xbmc.library = artistComponent.setup(xbmc);
        xbmc.playlist = playlistComponent.setup(xbmc);
        xbmc.player = controlComponent.setup(xbmc);
        albumComponent.setup(xbmc);
        videoComponent.setup(xbmc);
    }

    Component.onCompleted: setup();
}
