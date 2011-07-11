import Qt 4.7
import com.nokia.symbian 1.0
import "components" as Cp;

import "js/Utils.js" as Utils

Page {
    tools: ToolBarLayout {

        ToolButton {
            iconSource: "toolbar-back"
            onClicked: tvshowStack.pop()
            visible: tvshowStack.depth > 1
        }

        ButtonRow {
            checkedButton: stop4a

            ToolButton {
                iconSource: "img/back1.svg"
                onClicked: $().player.skipPrevious()
            }
            ToolButton {
                id: stop4a
                iconSource: "toolbar-mediacontrol-stop"
                onClicked: $().player.stop()
            }
            ToolButton {
                iconSource: "toolbar-mediacontrol-pause"
                onClicked: $().player.playPause()
//                visible: $().playlist.playing &&
            }
            ToolButton {
                iconSource: "toolbar-mediacontrol-play"
                onClicked: $().playlist.cmd("Play", "Audio");
//                visible: !$().playlist.playing
            }
            ToolButton {
                iconSource: "img/skip.svg"
                onClicked: $().player.skipPrevious()
            }
        }

        ToolButton {
            iconSource: "toolbar-delete"
            onClicked: {
                if ($().playlist.playing)
                    $().player.stop()
                $().playlist.audioClear();
                playlistModel.clear();
            }
            visible: playlistModel.count > 0
        }
    }

    ListView {
        id: playList
        anchors.fill: parent
        clip: true

        model: playlistModel
        delegate: playlistDelegate
    }

    Component {
        id: playlistDelegate

        Cp.Row {
            text: model.name
            subtitle: model.artist + "  -  " + model.album
//            duration:  model.duration > 0 ? Utils.secToMMSS(model.duration) : (model.runtime != undefined ? model.runtime : "")
            source: model.thumb

            onSelected:  {
            }
        }
    }

    Timer {
        id: timer
        interval: 2000; running: false; repeat: true
        onTriggered: $().playlist.update(playlistModel);

    }

    Component.onCompleted: {
        $().playlist.update(playlistModel);
        timer.running = true
    }
}
