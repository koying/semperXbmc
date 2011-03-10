import Qt 4.7

Item {
    width: musicComponent.width
    height: musicComponent.height
    id: artistComponent

    /* Listview of all the artists */
    ListView {
        id: artistView
        z: 1
        width: parent.width
        height: parent.height
        model: artistModel
        delegate: artistDelegate
    }

    Artist {
        id: artistDelegate
    }

    Rectangle {
        z: 2
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
            onTextChanged: {
                var len = search.text.length;
                for (var i = 0; i < artistModel.count; i++) {
                    if (artistModel.get(i).name.substr(0, len) == search.text) {
                        artistView.positionViewAtIndex(i, GridView.Beginning);
                        return;
                    }
                }
                //$().searchAlbums(search.text);
            }
        }
    }

    Keys.onPressed: { if (!searchField.visible) {searchField.visible = true; search.text = event.text; search.focus= true; }}

    /* Index with Shortcuts to the letters */
    /*ListView {
        x: 720
        height: parent.height
        y: 0
        z: 2
        //flicking: false
        id: index
        model: indexModel
        delegate: indexDelegate
    }

    Component {
        id:indexDelegate

        Button {
            height: 40
            width: 80
            text: name
            function clicked() {
                var i = Library.library.search(name.substr(0,1).toLowerCase());
                artistView.positionViewAtIndex(i, ListView.Beginning);
                //Script.playerCmd("SkipPrevious");
            }
        }
    }

    ListModel {
        id: indexModel
        ListElement {
             name: "ABC"
        }
        ListElement {
             name: "DEF"
        }
        ListElement {
             name: "GHI"
        }
        ListElement {
             name: "JKL"
        }
        ListElement {
             name: "MNO"
        }
        ListElement {
             name: "PQR"
        }
        ListElement {
             name: "STU"
        }
        ListElement {
             name: "VWXZ"
        }
    }*/
}
