import Qt 4.7

Flipable {
    id: flipable
    property bool flipped: false

    front: AudioPlayListView {
        playlistId: audioPlId
    }

    back: VideoPlayListView {
        playlistId: videoPlId
    }

    transform: Rotation {
        id: rotation
        origin.x: flipable.width/2
        origin.y: flipable.height/2
        axis.x: 0; axis.y: 1; axis.z: 0     // set axis.y to 1 to rotate around y-axis
        angle: 0    // the default angle
    }

    states: State {
        name: "back"
        PropertyChanges { target: rotation; angle: 180 }
        when: flipable.flipped
    }

    transitions: Transition {
        NumberAnimation { id: rotNumAnimation; target: rotation; property: "angle"; duration: 500 }
    }

    function showAudio() {
        rotNumAnimation.duration = 0
        flipable.flipped = false
        rotNumAnimation.duration = 500
    }

    function showVideo() {
        rotNumAnimation.duration = 0
        flipable.flipped = true
        rotNumAnimation.duration = 500
    }
}
