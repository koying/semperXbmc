import QtQuick 1.0
import com.nokia.symbian 1.0

import "js/Utils.js" as Utils

Item {
    id: trackList

    property int albumId: -99

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
                onClicked: $().playlist.addAlbum(albumId)
            }

            ToolButton {
                id: tbInsert
                //                    iconSource: "img/add.svg"
                text: "Insert"
                //                    width: (buttons.width - 3 * platformStyle.paddingMedium) / 2
                onClicked: $().playlist.insertAlbum(albumId)
            }

            ToolButton {
                id: tbReplace
                //                    iconSource: "img/switch_windows.svg"
                text: "Replace"
                //                    width: (buttons.width - 3 * platformStyle.paddingMedium) / 2
                onClicked: {
                    $().playlist.audioClear();
                    $().playlist.addAlbum(albumId)
                }
            }
        }
    }

    Item {
        anchors { top: buttons.bottom; left: parent.left; right: parent.right; bottom: parent.bottom}

//        color: "black"
//        border { color: "white"; width:  2 }
//        radius: 10

        ListView {
            id: trackListview
            anchors.fill: parent
//            anchors.margins: 10
            clip: true

            model: trackModel
            delegate: trackDelegate
        }
    }

    Component {
        id: trackDelegate

        Rectangle {

            width: liTrack.width
            height: liTrack.height
            gradient:
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
            ListItem {
                id: liTrack
                subItemIndicator: true

                Item  {
                    anchors.fill: liTrack.paddingItem

                    ListItemText {
                        id: txItemTitle
                        anchors { top: parent.top; bottom: parent.bottom; left: parent.left; right: txItemDuration.left; rightMargin: 10 }

                        mode: liTrack.mode
                        role: "Title"
                        text: model.number + ". " + model.name
                    }

                    ListItemText {
                        id: txItemDuration
                        anchors { top: parent.top; bottom: parent.bottom; right: parent.right }

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

    onAlbumIdChanged: {
        trackModel.clear();
        $().library.loadTracks(albumId);
    }


}
