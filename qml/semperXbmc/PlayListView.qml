import Qt 4.7
import com.nokia.symbian 1.0
import "components" as Cp;

import "js/Utils.js" as Utils

Page {
    tools: ToolBarLayout {

        ToolButton {
            iconSource: "toolbar-back"
            onClicked: playListStack.pop()
            visible: playListStack.depth > 1
        }

        ButtonRow {
            ToolButton {
                iconSource: "img/back1.svg"
                onClicked: $().audioplayer.skipPrevious()
            }
            ToolButton {
                iconSource: "toolbar-mediacontrol-stop"
                onClicked: $().audioplayer.stop()
            }
            ToolButton {
                id: btPause
                iconSource: "toolbar-mediacontrol-pause"
                onClicked:  {
                    $().audioplayer.playPause()
                    $().playlist.paused = true;
                    visible = false;
                    btPlay.visible = true;
                }
                visible: false
            }
            ToolButton {
                id: btPlay
                iconSource: "toolbar-mediacontrol-play"
                onClicked: {
                    if (!$().playlist.playing) {
                        $().playlist.playAudio();
                        $().playlist.playing = true;
                    } else
                        $().audioplayer.playPause();
                    visible = false;
                    btPause.visible = true;
                }
            }
            ToolButton {
                iconSource: "img/skip.svg"
                onClicked: $().audioplayer.skipNext()
            }
        }

        ToolButton {
            iconSource: "toolbar-delete"
            onClicked: {
                if ($().playlist.playing)
                    $().audioplayer.stop()
                $().playlist.audioClear();
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

        Cp.Delegate {
            title: model.name
            subtitle: model.artist + "  -  " + model.album
//            duration:  model.duration > 0 ? Utils.secToMMSS(model.duration) : (model.runtime != undefined ? model.runtime : "")
            image: model.thumb
            current: model.select

            onSelected:  {
            }
        }
    }

    Timer {
        id: timer
        interval: 2000; running: false; repeat: true
        onTriggered: {
            $().playlist.update(playlistModel);
            btPause.visible = $().playlist.playing && !$().playlist.paused;
            btPlay.visible = !$().playlist.playing || $().playlist.paused;
        }

    }

    function init() {
        $().playlist.update(playlistModel);
        timer.running = true
    }

    Component.onCompleted: {
        init();
    }
}
