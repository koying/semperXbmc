import Qt 4.7

Item {
    id: toolbar

    signal tvshowsRequested()
    signal moviesRequested()
    signal picturesRequested()
    signal playlistRequested()
    signal musicRequested()

    Rectangle {
        anchors.fill: parent; color: "#343434";
        border.color: "black"
        gradient: Gradient {
            GradientStop {
                position: 0.00;
                color: "#343434";
            }
            GradientStop {
                position: 1.00;
                color: "#ffffff";
            }
        }

        Row {
            spacing: 10
            anchors {
                top: parent.top; bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
            }


            Button {
                id: tvButton
                width: parent.height-4
                height: parent.height-4
                anchors.verticalCenter: parent.verticalCenter
                onClicked: toolbar.tvshowsRequested()
                imageSource: "img/TvShows.png"
            }

            Button {
                id: movieButton
                width: parent.height-4
                height: parent.height-4
                onClicked: toolbar.moviesRequested()
                imageSource: "img/Movies.png"
            }

            Button {
                id: videoButton
                width: parent.height-4
                height: parent.height-4
                onClicked: toolbar.playlistRequested()
                imageSource: "img/Library.png"
            }

            Button {
                id: musicButton
                width: parent.height-4
                height: parent.height-4
                onClicked: toolbar.musicRequested()
                imageSource: "img/Music.png"
            }

            Button {
                id: photoButton
                width: parent.height-4
                height: parent.height-4
                onClicked: toolbar.picturesRequested()
                imageSource: "img/Pictures.png"
            }
        }
    }
}