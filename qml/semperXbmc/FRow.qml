import Qt 4.7


Rectangle {
    property alias text: rowTitle.text
    property alias subtitle: rowSubtitle.text
    property alias source: rowImage.source
    property bool selected: false;
    property bool portrait: false;
    property bool watched: false;
    width: parent.width;
    height: 80
    id: content
    gradient: selected ? highlight : normal
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
    Row {
        id: row
        width: parent.width
        height: parent.height
        spacing: 20
        Image {
            id: rowImage
            width: parent.height;
            height: parent.height
            fillMode:Image.PreserveAspectFit
            visible: rowImage.source != ""
            onStatusChanged: {
                if (rowImage.status == Image.Ready) {
                    if (rowImage.sourceSize.width > rowImage.sourceSize.height*2) {   // banner
                        details.visible = false;
                        rowImage.width = parent.width
//                        parent.height = rowImage.sourceSize.height;
                        rowImage.fillMode = Image.Stretch;
                    }
                }
            }

            Image {
                source: "img/checkmark_48.png"
                smooth: true
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 10
                visible: content.watched
            }
        }
        Column {
            id: details
            Text {
                id: rowTitle
                height: subtitle ? row.height * 0.4 : row.height
                color: "#ffffff"
                wrapMode: Text.Wrap
                font.pointSize: 12
                verticalAlignment :Text.AlignVCenter
                elide: Text.ElideRight
            }
            Text {
                id: rowSubtitle
                height: row.height - rowTitle.height
                y: rowTitle.height
                color: "#ffffff"
                wrapMode: Text.Wrap
                font.pointSize: rowTitle.font.pointSize  * 0.6
                verticalAlignment :Text.AlignVCenter
                elide: Text.ElideRight
                visible: rowSubtitle.text != ""
            }
        }

    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent;
        onClicked: {
            timer.start();
            content.state = "pressed";
            content.clicked(id);
        }
    }
    states: [
        State {
            name: "normal"
            PropertyChanges {
                target: content
                gradient: normal
            }
        },
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
        }

    ]
    Timer {
        id: timer
        interval: 500; running: false; repeat: false
        onTriggered: content.state = selected ? "highlight" : "normal";

    }
}

