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

    Connections {
        id: xbmcConnection
        target: xbmcTcpClient

        onPlaylistChanged: {
            if (playlistId == page.playlistId)
                $().playlist.update(page.playlistId, playlistModel, xbmcTcpClient.getPlaylistItems(page.playlistId));
        }
    }

    Connections {
        target: main

        onStateChanged :{
            if (main.state == "playlist") {
                if (page.playlistId == -1)
                    return;

                $().playlist.update(page.playlistId, playlistModel, xbmcTcpClient.getPlaylistItems(page.playlistId));
                xbmcConnection.target = xbmcTcpClient
            } else
                xbmcConnection.target = null
        }
    }

    Component.onCompleted: {
        if (main.state == "playlist") {
            if (page.playlistId == -1)
                return;

            $().playlist.update(page.playlistId, playlistModel, xbmcTcpClient.getPlaylistItems(page.playlistId));
            xbmcConnection.target = xbmcTcpClient
        }
    }
}
