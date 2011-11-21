import QtQuick 1.0
import com.nokia.symbian 1.0

ListItem {
    id: content

    property string text
    property string subtitle
    property string duration
    property alias source: rowImage.source
    property bool watched: false
    property bool banner:  false
    property bool filtered: false
    property bool current:  false

    signal selected(string id)

    height: filtered ? 0 : 80

    Rectangle {
        anchors.fill: parent

        gradient: content.current ? highlight : normal

        Gradient {
            id: normal
            GradientStop {
                position: 0
                color: "#545454"
            }

            GradientStop {
                position: 0.15
                color: "#343434"
            }

            GradientStop {
                position: 0.85
                color: "#242424"
            }

            GradientStop {
                position: 1
                color: "#211919"
            }
        }
    }

    Row {
        id: grid
        spacing: platformStyle.paddingSmall
        anchors.fill: content
        anchors.margins: platformStyle.paddingSmall
        visible: !content.filtered

        Item {
            id: itImage
            width: grid.height
            height: grid.height

            Image {
                id: rowImage
                anchors {fill: parent; horizontalCenter: parent.horizontalCenter }
                fillMode: Image.PreserveAspectFit
                visible: source != ""
                asynchronous: true
                onStatusChanged: {
                    if (rowImage.status == Image.Ready) {
                        if (rowImage.sourceSize.width > rowImage.sourceSize.height*2 && content.banner) {   // banner
                            details.visible = false;
                            grid.anchors.fill = content
                            itImage.width = content.width
                            rowImage.fillMode = Image.Stretch;
                        }
                    }
                }

                Image {
                    source: "../img/checkmark_48.png"
                    smooth: true
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    visible: content.watched
                }
            }
        }
        Item {
            id: details
            height: content.height
            width: content.width  - itImage.width
            Column {
                Item {
                    id: rowTitle
                    height: content.subtitle ? details.height * 0.5 : details.height
                    width:  details.width

                    ListItemText {
                        id: txItemTitle

                        mode: content.mode
                        role: "Title"
                        text: content.text
                    }
                }

                Item {
                    id: rowSubtitle
                    height: details.height - rowTitle.height
                    width:  details.width
                    y: rowTitle.height
                    visible: content.subtitle != "" || content.duration != ""

                    ListItemText {
                        id: txItemSubTitle
                        anchors { left: parent.left }
                        width: parent.width - 100

                        mode: content.mode
                        role: "SubTitle"
                        text: content.subtitle
                    }
                    ListItemText {
                        id: txItemDuration
                        anchors { right: parent.right }

                        mode: content.mode
                        role: "SubTitle"
                        text: content.duration
                    }
                }
            }
        }
    }

    onClicked: {
        content.selected(id);
    }
}
