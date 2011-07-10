import QtQuick 1.0
import com.nokia.symbian 1.0
import "components" as Cp;
import "js/Utils.js" as Utils

Rectangle {
    id: content

    gradient: normal
    Gradient {
        id: normal
        GradientStop { position: 0.0; color: "#333" }
        GradientStop { position: 1.0; color: "#000" }
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
            anchors.margins: 10
            anchors { top: parent.top; left: parent.left; right:  parent.right }
            height: parent.height - details.height

            Image {
                id: rowImage
                anchors {fill: parent; horizontalCenter: parent.horizontalCenter }
                fillMode:Image.PreserveAspectFit
                visible: source != ""
                source: model.thumb
                onStatusChanged: {
                    if (rowImage.status == Image.Ready) {
                    }
                }
            }
        }
        Item {
            id: details
            anchors.margins: 10
            anchors { top: itImage.bottom; left: parent.left; right:  parent.right }
            width: parent.width
            height: content.height * 0.2
            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    id: rowTitle
                    height: rowSubtitle.text ? details.height * 0.4 : details.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#ffffff"
                    wrapMode: Text.Wrap
                    font.pointSize: 12
                    verticalAlignment :Text.AlignVCenter
                    elide: Text.ElideRight

                    text: model.name
                }
                Text {
                    id: rowSubtitle
                    height: details.height - rowTitle.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: rowTitle.height
                    color: "#ffffff"
                    wrapMode: Text.Wrap
                    font.pointSize: rowTitle.font.pointSize  * 0.6
                    verticalAlignment :Text.AlignVCenter
                    elide: Text.ElideRight
                    visible: rowSubtitle.text != ""

                    text: model.genre
                }
            }
        }

        MouseArea {
            anchors.fill: parent;
            onClicked: {
                if (content.state == "") {
                    content.state = "detail";
                    $().library.loadTracks(model.idalbum);
                } else
                    content.state = "";
            }
        }
    }

    Rectangle {
        id: trackList

        color: "black"
        border { color: "white"; width:  2 }
        radius: 10

//        visible: false
        opacity: 0
        anchors { top: grid.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }
        anchors.topMargin: 10

        ListView {
            anchors.fill: parent
            anchors.margins: 10
            clip: true

            model: trackModel
            delegate: trackDelegate
        }
    }

    Component {
        id: trackDelegate

        ListItem {
            id: liTrack

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
        }

//        Item {
//            id: itemWrapper
//            width: trackList.width;
//            height: 50

//            Item {
//                anchors.fill: parent
//                anchors.verticalCenter: parent.verticalCenter
//                anchors.margins: 5

//                Text {
//                    id: txItemTitle

//                    anchors { left: parent.left }
//                    width: parent.width - 50
//                    color: "white"
//                    wrapMode: Text.Wrap
//                    font.pixelSize: itemWrapper - 4
//                    verticalAlignment: Text.AlignVCenter
//                    elide: Text.ElideRight

//                    text: model.number + ". " + model.name
//                }
//                Text {
//                    id: txItemDuration
//                    anchors { left: txItemTitle.right; right: parent.right }
//                    color: "white"
//                    wrapMode: Text.Wrap
//                    font.pixelSize: itemWrapper - 4
//                    verticalAlignment: Text.AlignVCenter
//                    elide: Text.ElideRight

//                    text: Utils.secToMMSS(model.duration)
//                }
//            }
//        }
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
                width: 150; height: 150
            }
            PropertyChanges {
                target: details
                width: content.width - 150; height: 150
            }
            PropertyChanges {
                target: grid
                height: 150
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
