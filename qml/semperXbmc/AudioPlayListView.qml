import Qt 4.7
import com.nokia.symbian 1.1
import "components/" as Cp;
import "menus/" as Menus

import "js/Utils.js" as Utils

Item {
    id: page
    anchors.fill: parent

    property int playlistId: -1
    property int count: playlistModel.count
    property alias player: player

    ToolBar {
        id: tbar
        anchors { bottom: parent.bottom; left: parent.left; right: parent.right; }


        tools:
            ToolBarLayout {
                id: layout

                ToolButton {
                    iconSource: "toolbar-back"
                    visible: false
                }

                Row {
                    anchors.centerIn: parent
                    spacing: platformStyle.paddingMedium

                    ToolButton {
                        id: tbClearAll
                        text: "Clear Audio"
                        onClicked: {
                            player.stop()
                            $().playlist.clear(playlistId);
                        }
                    }
                }

                ToolButton {
                    Menus.MainTools {
                        id: mainTools
                    }

                    iconSource: "toolbar-menu"
                    onClicked: mainTools.menu.open()
                }
            }

    }

    ListModel {
        id: playlistModel
    }

    ListView {
        id: playList
        anchors {right: parent.right; left: parent.left; bottom: player.top; top: parent.top }
        clip: true

        model: playlistModel
        delegate: playlistDelegate
    }

    Player {
        id: player
        anchors { left: parent.left; right: parent.right; bottom: tbar.top }
        playlistId: page.playlistId
        playerType: "audio"
    }

    ScrollDecorator {
        flickableItem: playList
    }

    Component {
        id: playlistDelegate

        Cp.Delegate {
            title: (model.number > 0 ? model.number + ". " : "") + model.name
            subtitle: model.artist + "  -  " + model.album
            subtitleR:  model.duration > 0 ? Utils.secToMMSS(model.duration) : ""
            image: model.thumb != "" ? model.thumb : "qrc:/defaultImages/artist"
            percentage: (model.id == player.position ? player.percentage : 0)
            current: (model.id == player.position)

            onSelected:  {
                $().playlist.play($().playlist.audioPlId, model.id)
            }
        }
    }

    Timer {
        id: timer
        property bool active: false

        interval: 2000;
        running: active && main.state == "playlist"
        repeat: true
        onTriggered: {
            $().playlist.update(playlistId, playlistModel);
        }

    }

    onPlaylistIdChanged: {
        console.debug("playlistId:"+playlistId)
        timer.active = false;
        if (playlistId != -1) {
            $().playlist.update(playlistId, playlistModel);
            timer.active = true
        }
    }
}
