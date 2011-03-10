import Qt 4.7

Item {
    anchors.fill: parent
    id: videoComponent


    Row {
        id: container
        Item {
            id: homeComponent
            height: videoComponent.height
            width: videoComponent.width
            Row {
                spacing: 150
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                Button {
                    text: ""
                    source: "img/media_optical.svgz"
                    width: 120
                    height: 120
                    function clicked() {
                        console.log("content");
                        container.state = 'content';
                        movieView.visible = true;
                        tvshowView.visible = false;
                    }
                }
                Button {
                    text: ""
                    source: "img/video_television.svgz"
                    width: 120
                    height: 120
                    function clicked() {
                        container.state = 'content';
                        movieView.visible = false;
                        tvshowView.visible = true;
                    }
                }
            }
        }
        Item {
            height: videoComponent.height
            width: videoComponent.width

            MovieView {
                id: movieView
            }
            TvshowView {
                id: tvshowView
            }
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

    function back() {
        if (container.state == "") {
            return true;
        }
        else {
            if (movieView.visible || tvshowView.back()) {
                container.state = "";
            }
            return false;
        }
    }
}
