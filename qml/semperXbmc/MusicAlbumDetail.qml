import QtQuick 1.0
import com.nokia.symbian 1.0

Item {
    id: trackList

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

}
