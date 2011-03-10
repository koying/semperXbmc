import Qt 4.7
import "js/xbmc.js" as Xbmc
import "js/player.js" as Player
import "js/library.js" as Library
import "js/playlist.js" as Playlist
import "js/json.js" as Json


Rectangle {
    property bool touch:false

    id: root
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
    Row {
        id: container;
        anchors.top: controlComponent.bottom
        anchors.topMargin: - 3
        Item {
            id: homeComponent
            height: root.height - controlComponent.height
            width: root.width
            Row {
                spacing: 150
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                Button {
                    //text: "Video"
                    source: "img/folder_video.svg"
                    width: 120
                    height: 120
                    function clicked() {
                        media.state = "video";
                        container.state = 'content';
                        $().player.type = "Video";
                    }
                }
                Button {
                    //text: "Music"
                    source: "img/folder_sound.svg"
                    width: 120
                    height: 120
                    function clicked() {
                        media.state = "music";
                        container.state = 'content';
                        $().player.type = "Music";
                    }
                }
                Button {
                    //text: "Photos"
                    source: "img/folder_image.svg"
                    width: 120
                    height: 120
                    function clicked() {
                        //container.state = "artist"
                    }
                }
            }
        }

        Item {
            id: media
            width: root.width
            height: root.height - controlComponent.height
            Video {
                visible: false;
                id: videoComponent
            }
            Music {
                visible: false;
                id: musicComponent
            }

            /*
            Picture {
                visible: false;
            }
            */

            Playlist {
                visible: false;
                id: playlistComponent
            }

            states: [
                State {
                    name: "video"
                    PropertyChanges {
                        target: videoComponent
                        visible: true
                    }
                },
                State {
                    name: "music"
                    PropertyChanges {
                        target: musicComponent
                        visible: true
                    }
                }/*,
                State {
                    name: "picture"
                    PropertyChanges {
                        target: pictureComponent
                        visible: true
                    }
                }*/,
                State {
                    name: "playlist"
                    PropertyChanges {
                        target: playlistComponent
                        visible: true
                    }
                }
            ]
        }

        states: [
            State {
                name: "content"
                PropertyChanges {
                    target: container
                    x: -root.width;
                }
            }

        ]
        transitions: Transition {
            PropertyAnimation {
                properties: "x";
                easing.type: Easing.InOutCubic
                duration: 500
            }
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

