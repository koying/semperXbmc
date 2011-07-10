import Qt 4.7
import "components" as Cp;

Rectangle {
    property string detailState: "detail"

    id: itemDetail
    width: 200;
    height: 200;
    state: "list"
    color: "transparent";
    clip: true
    x: 10
    Cp.Image {
        id: itemThumb
        x: 50
        y: 0
        width: 100
        height: 200
        source: thumb
        text: name
        button: true;
        fancy: "false"

        function clicked() {
            console.log("album clicked " + idalbum);
            $().library.loadTracks(idalbum);
            itemDetail.state = itemDetail.state == detailState ? "list" : detailState;
        }

        /*MouseArea {
            anchors.fill: parent;
            onClicked: {
                console.log("album clicked" + idalbum);
                $().library.loadTracks(idalbum);
                itemDetail.state = itemDetail.state == detailState ? "list" : detailState
                //albumComponent.clicked(idalbum);
                //Script.loadAlbums(idartist, albumModel);

            }
            onDoubleClicked: {
                console.log("album dbclicked" + idalbum);
            }
        }*/
    }
    /*Text {
        id: itemText
        anchors.top: itemThumb.bottom
        anchors.topMargin: 5
        anchors.horizontalCenter: itemThumb.horizontalCenter
        text: name
        color: "#fff"
        elide: Text.ElideRight
    }*/
    // TODO insert some more information for the album for detail state

    Cp.Button {
        id:appendButton
        visible: false
        width: 200
        height: 25
        anchors.horizontalCenter: itemThumb.horizontalCenter
        anchors.bottom: replaceButton.top
        anchors.bottomMargin: 20
        text: "Append to Playlist"
        function clicked() {
            console.log("append");
            itemDetail.state = itemDetail.state == detailState ? "list" : detailState;
            $().playlist.addAlbum(idalbum);
        }

    }

    Cp.Button {
        id:replaceButton
        visible: false
        width: 200
        height: 25
        anchors.horizontalCenter: itemThumb.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        text: "Set as Playlist"
        function clicked() {
            console.log("replace");
            itemDetail.state = itemDetail.state == detailState ? "list" : detailState;
            $().playlist.clear();
            $().playlist.addAlbum(idalbum);
        }
    }
    Item {
        width: 250
        height: parent.height -2
        x: 350
        y: 1
        clip: true

        ListView {
            //boundsBehavior: Flickable.StopAtBounds
            width: 250
            height: parent.height -2
            visible: false
            id: trackView
            model: trackModel
            delegate: Cp.Row {
                text: name
                //color: "white"
                height: 40
                /*selected: selected
                function clicked(id) {
                    console.log("artist clicked" + id);
                    artistComponent.clicked(id);
                }*/
            }
        }
    }




    states: [
        State {
            name: "detail"
            ParentChange {
                target: itemDetail;
                parent: albumComponent;
                x: 100;
                y: 10
                width: albumComponent.width -200
                height: albumComponent.height - 20
            }
            PropertyChanges {
                target: itemDetail;
                border.width: 1
                border.color: "#999"
                color: "#99000000";
            }
            PropertyChanges {
                target: itemThumb;
                width: 200;
                height: 360
                y: 10
            }
            PropertyChanges {
                target: appendButton;
                visible: true
            }
            PropertyChanges {
                target: replaceButton;
                visible: true
            }
            PropertyChanges {
                target: trackView;
                visible: true
            }
        },
        State {
            name: "detail-touch"
            extend: "detail"
            PropertyChanges {
                target: angle;
                angle: 0
            }

        },
        State {
            name: "list"
        }

    ]

    transitions:
            [
        Transition {
            from: "list"; to: "detail"
            SequentialAnimation {
                ParentAnimation {
                    NumberAnimation { properties: "x,y, width, height"; duration: 500; easing.type: Easing.InOutQuad }
                }
                NumberAnimation { properties: "visible"; duration: 100; easing.type: Easing.InOutQuad }
            }
        },
        Transition {
            from: "detail"; to: "list"
            SequentialAnimation {
                NumberAnimation { properties: "visible"; duration: 100; easing.type: Easing.InOutQuad }
                ParentAnimation {
                    NumberAnimation { properties: "x,y, width, height"; duration: 500; easing.type: Easing.InOutQuad }
                }

            }
        },
        Transition {
            from: "list"; to: "detail-touch"
            SequentialAnimation {
                NumberAnimation { properties: "angle"; duration: 500; easing.type: Easing.InOutQuad }
                ParentAnimation {
                    NumberAnimation { properties: "x,y, width, height"; duration: 500; easing.type: Easing.InOutQuad }
                }
                NumberAnimation { properties: "visible"; duration: 100; easing.type: Easing.InOutQuad }
            }
        },
        Transition {
            from: "detail-touch"; to: "list"
            SequentialAnimation {
                NumberAnimation { properties: "visible"; duration: 100; easing.type: Easing.InOutQuad }
                ParentAnimation {
                    NumberAnimation { properties: "x,y, width, height"; duration: 500; easing.type: Easing.InOutQuad }
                }
                NumberAnimation { properties: "angle"; duration: 500; easing.type: Easing.InOutQuad }
            }
        }
    ]
}
