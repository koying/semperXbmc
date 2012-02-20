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
        id: buttons
        anchors { top: parent.top; left: parent.left; right: parent.right; }


        tools:
            Row {
                anchors.centerIn: parent
                spacing: platformStyle.paddingMedium

                ToolButton {
                    id: tbClearAll
                    text: "Clear Video"
                    onClicked: {
                        if (player.playing)
                            player.stop()
                        $().playlist.clear(playlistId);
                    }
                }
            }


    }

    ListModel {
        id: playlistModel
    }

    ListView {
        id: playList
        anchors {right: parent.right; left: parent.left; bottom: player.top; top: buttons.bottom }
        clip: true

        model: playlistModel
        delegate: playlistDelegate
    }

    Player {
        id: player
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
        playlistId: page.playlistId
        playerType: "Video"
    }

    ScrollDecorator {
        flickableItem: playList
    }

    Component {
        id: playlistDelegate

        Cp.Delegate {
            title: (model.number > 0 ? model.number + ". " : "") + model.name
            subtitle: model.showtitle
            subtitleR: (model.duration > 0 ? Utils.secToMinutes(model.duration) : "")
            image: model.thumb != "" ? model.thumb : "qrc:/defaultImages/movie"
            watched: model.playcount > 0

            onSelected:  {
            }
        }
    }

    Timer {
        id: timer
        interval: 2000; running: false; repeat: true
        onTriggered: {
            $().playlist.update(playlistId, playlistModel);
        }

    }

    onPlaylistIdChanged: {
        console.debug("playlistId:"+playlistId)
        timer.running = false;
        if (playlistId != -1) {
            $().playlist.update(playlistId, playlistModel);
            timer.running = true
        }
    }
}
