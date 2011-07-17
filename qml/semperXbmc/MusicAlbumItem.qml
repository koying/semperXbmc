import QtQuick 1.0
import com.nokia.symbian 1.0
import "components" as Cp;
import "js/Utils.js" as Utils

Rectangle {
    id: content

    signal addAlbumToplaylist(int albumId)
    signal replacePlaylistWithAlbum(int albumId)

    gradient: normal
    Gradient {
        id: normal
        GradientStop { position: 0.0; color: "#777" }
        GradientStop { position: 1.0; color: "#333" }
    }
    Gradient {
        id: pressed
        GradientStop { position: 0.0; color: "#336" }
        GradientStop { position: 1.0; color: "#003" }
    }
    Gradient {
        id: highlight
        GradientStop { position: 0.0; color: "#669" }
        GradientStop { position: 1.0; color: "#336" }
    }

    Item {
        id: grid
        anchors { top: parent.top; left: parent.left; right:  parent.right }
        height:  parent.height

        Item {
            id: itImage
            anchors.margins: 5
            anchors { top: parent.top; left: parent.left; right:  parent.right }
            height: parent.height - details.height

            Image {
                id: rowImage
                anchors {fill: parent; horizontalCenter: parent.horizontalCenter }
                fillMode:Image.PreserveAspectFit
                visible: source != ""
                source: model.thumb
                asynchronous: true
//                onStatusChanged: {
//                    if (rowImage.status == Image.Ready) {
//                    }
//                }
            }
        }
        Item {
            id: details
            anchors.margins: 5
            anchors { top: itImage.bottom; left: parent.left; right:  parent.right }
            width: parent.width
            height: content.height * 0.3
            Column {
                anchors.horizontalCenter: parent.horizontalCenter

                ListItemText {
                    id: rowTitle
                    height: rowSubtitle.text ? details.height * 0.4 : details.height
                    anchors.horizontalCenter: parent.horizontalCenter

                    role: "Title"
                    text: model.name
                }

                ListItemText {
                    id: rowSubtitle
                    height: details.height - rowTitle.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: rowTitle.height + platformStyle.paddingSmall

                    role: "SubTitle"
                    text: model.artist
                }
            }
        }

        MouseArea {
            anchors.fill: parent;
            onClicked: {
                if (content.state == "") {
                    content.state = "detail";
                    $().library.loadTracks(model.idalbum);
                } else {
                    content.state = "";
                }
            }
        }
    }

    Item {
        id: trackList
        anchors { top: grid.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }
        anchors.topMargin: 10

        //        visible: false
        opacity: 0

        ToolBar {
            id: buttons
            anchors { top: parent.top; left: parent.left; right: parent.right; }

            tools: Row {
                anchors.centerIn: parent
                spacing: platformStyle.paddingMedium

                ToolButton {
                    id: tbAdd
//                    iconSource: "img/add.svg"
                    text: "Append"
//                    width: (buttons.width - 3 * platformStyle.paddingMedium) / 2
                    onClicked: $().playlist.addAlbum(model.idalbum)
                }

                ToolButton {
                    id: tbInsert
//                    iconSource: "img/add.svg"
                    text: "Insert"
//                    width: (buttons.width - 3 * platformStyle.paddingMedium) / 2
                    onClicked: $().playlist.insertAlbum(model.idalbum)
                }

                ToolButton {
                    id: tbReplace
//                    iconSource: "img/switch_windows.svg"
                    text: "Replace"
//                    width: (buttons.width - 3 * platformStyle.paddingMedium) / 2
                    onClicked: {
                        $().playlist.audioClear();
                        $().playlist.addAlbum(model.idalbum)
                    }
                }
            }
        }

        Rectangle {
            anchors { top: buttons.bottom; left: parent.left; right: parent.right; bottom: parent.bottom}

            color: "black"
            border { color: "white"; width:  2 }
            radius: 10

            ListView {
                anchors.fill: parent
                anchors.margins: 10
                clip: true

                model: trackModel
                delegate: trackDelegate
            }
        }
    }

    Component {
        id: trackDelegate

        ListItem {
            id: liTrack
            subItemIndicator: true

            Item {
                anchors.fill: liTrack.paddingItem

                ListItemText {
                    id: txItemTitle
                    anchors { left: parent.left }
                    width: parent.width - 50

                    mode: liTrack.mode
                    role: "Title"
                    text: model.number + ". " + model.name
                }

                ListItemText {
                    id: txItemDuration
                    anchors { right: parent.right }

                    mode: liTrack.mode
                    role: "SubTitle"
                    text: Utils.secToMMSS(model.duration)
                }
            }

            onClicked: trackMenu.open()

            ContextMenu {
                id: trackMenu
                MenuLayout {
                    MenuItem {
                        text: "Append"
                        onClicked: $().playlist.addTrack(model.idtrack)
                    }
                    MenuItem {
                        text: "Insert"
                        onClicked: $().playlist.insertTrack(model.idtrack)
                    }
                }
            }

        }

    }


    states: [
        State {
            name: "highlight"
            PropertyChanges {
                target: content
                gradient: highlight
            }
        },
        State {
            name: "pressed"
            PropertyChanges {
                target: content
                gradient: pressed
            }
        },

        State {
            name: "detail"
            ParentChange {
                target:  content
                parent: page
                x: 0
                y: 0
                width: page.width
                height: page.height
            }
            PropertyChanges {
                target: itImage
                width: platformStyle.graphicSizeLarge; height: platformStyle.graphicSizeLarge
            }
            PropertyChanges {
                target: details
                width: content.width - platformStyle.graphicSizeLarge; height: platformStyle.graphicSizeLarge
            }
            PropertyChanges {
                target: grid
                height: platformStyle.graphicSizeLarge
            }
            AnchorChanges {
                target: itImage
                anchors.left: parent.left
                anchors.right: undefined
            }
            AnchorChanges {
                target: details
                anchors.left: itImage.right
                anchors.top: parent.top
            }
            PropertyChanges {
                target: trackList
//                visible: true;
                opacity: 1
            }
        }

    ]

    transitions: [
        Transition {
            from: ""
            to: "detail"
            reversible: true

            ParentAnimation {
                NumberAnimation { properties: "x,y, width, height, opacity"; duration: 500; }
            }
            AnchorAnimation { duration: 500; }
        }
    ]
    Timer {
        id: timer
        interval: 500; running: false; repeat: false
        onTriggered: content.state = selected ? "highlight" : "";

    }
}
