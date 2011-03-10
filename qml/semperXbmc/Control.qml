import Qt 4.7

Rectangle {
    width: parent.width
    height: 80
    id: controlComponent
    z: 99
    clip: true

    gradient: Gradient {
        GradientStop { position: 0.0; color: "#000" }
        GradientStop { position: 0.9; color: "#333" }
        GradientStop { position: 1.0; color: "#00FFFFFF" }
    }

    Button {
        id: skipBackButton;
        anchors.left: parent.left

        y: 100
        smooth: true
        source: "img/media_skip_backward.svgz"
        function clicked() {
            $().player.skipPrevious();
        }
    }

    Button {
        anchors.left: skipBackButton.right
        anchors.leftMargin: 10
        id: skipForwardButton;
        y: 100
        smooth: true
        source: "img/media_skip_forward.svgz"
        function clicked() {
            $().player.skipNext();
        }
    }




    /*Button {
        x:2
        y: 2
        source: "img/media_seek_backward.svgz"
        function clicked() {
            controlComponent.back();
        }
    }*/

    Button {
        id: playButton;
        anchors.left: parent.left
        anchors.leftMargin: 10
        y: 0
        smooth: true
        source: "img/media_playback_start.svgz"
        function clicked() {
            $().player.playPause();
        }
    }
    Button {
        anchors.left: playButton.right
        anchors.leftMargin: 10
        id: stopButton;
        y: 0
        smooth: true
        source: "img/media_playback_stop.svgz"
        function clicked() {
            $().player.stop();
        }
    }

    Button {
        anchors.left: stopButton.right
        anchors.leftMargin: 30
        id: volumeDownButton;
        y: 0
        smooth: true
        source: "img/list-remove.png"
        function clicked() {
            $().volumeDown();
        }
    }
    Button {
        anchors.left: volumeDownButton.right
        anchors.leftMargin: 10
        id: volumeUpButton;
        y: 0
        smooth: true
        source: "img/list-add.png"
        function clicked() {
            $().volumeUp();
        }
    }

    /*Button {
        x:2
        y: 2
        source: "img/media_seek_forward.svgz"
        function clicked() {
            controlComponent.back();
        }
    }*/



    /*Button {
        x:650
        y: 0
        source: "img/player_volume_muted.svgz"
        function clicked() {
            controlComponent.back();
        }
    }*/
    Button {
        id:playlistViewButton
        anchors.right: playlistClearButton.left
        anchors.rightMargin: 10
        y: 0
        source: "img/media_playlist.svg"
        function clicked() {
            $().show("playlist");
        }
    }
    Button {
        id:playlistClearButton
        anchors.right: backButton.left
        anchors.rightMargin: 10
        y: 0
        source: "img/edit_clear_list.svgz"
        function clicked() {
            $().playlist.clear();
        }
    }

    Button {
        id:backButton
        anchors.right: parent.right
        anchors.rightMargin: 10
        y: 2
        source: "img/revert.svg"
        function clicked() {
            $().back();
        }
    }

    /*MouseArea {
        anchors.fill: parent;
        onDoubleClicked: {
            parent.height = parent.height == 80 ? 200 : 80;
        }
    }*/
    transitions: Transition {
        PropertyAnimation {
            properties: "height";
            easing.type: Easing.InOutCubic
            duration: 500
        }
    }
}
