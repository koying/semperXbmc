import Qt 4.7

Item {
    id: albumComponent

    GridView {
        y: 30
        id: albumView
        cellWidth: 200
        cellHeight: 120
        width: 2 * parent.width
        height: parent.height -30
        model: albumModel
        delegate: albumDelegate
        flow: GridView.TopToBottom
        transform: Rotation {
            id: angle;
            origin.x: 30;
            origin.y: 30;
            axis { x: 0; y: 1; z: 0 }
            angle: 0
            Behavior on angle { PropertyAnimation { duration: 400 } }
        }

        onMovementStarted: angle.angle = 40;
        onMovementEnded: angle.angle = 0;
    }
    Component {
        id: albumDelegate

        Album {
            width: 200
            height: 120
            detailState: "detail-touch"
        }
    }

    Rectangle {
        id: searchField
        anchors.centerIn: parent;
        width: parent.width -100
        height: 50
        color: "#99000000"
        border.width: 1
        border.color: "white"
        radius: 10
        visible: false
        TextInput {
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: 10
            font.pointSize: 16
            id: search
            color: "white"
            width: parent.width
            onTextChanged: {
                var len = search.text.length;
                for (var i = 0; i < albumModel.count; i++) {
                    if (albumModel.get(i).name.substr(0, len) == search.text) {
                        albumView.positionViewAtIndex(i, GridView.Beginning)
                        return;
                    }
                }
                //$().searchAlbums(search.text);
            }
        }
    }

    Keys.onPressed: { if (!searchField.visible) {searchField.visible = true; search.text = event.text; search.focus= true }}


}
