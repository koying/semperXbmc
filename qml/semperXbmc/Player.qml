// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1
import com.semperpax.qmlcomponents 1.0

Item {
    id: root
    anchors { left: parent.left; right: parent.right; bottom: parent.bottom }

    property int playlistId: -1
    property string  playerType: ""

    property alias position: xbmcPlayer.position
    property alias percentage: xbmcPlayer.percentage
    property alias speed: xbmcPlayer.speed

    ToolBar {
        id: tbar
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
        tools: ToolBarLayout {

            ButtonRow {
                ToolButton {
                    iconSource: "img/back1.svg"
                    onClicked: xbmcPlayer.skipPrevious()
                }
                ToolButton {
                    iconSource: "toolbar-mediacontrol-stop"
                    onClicked: {
                        stop()
                    }
                }
                ToolButton {
                    id: btPause
                    iconSource: "toolbar-mediacontrol-pause"
                    onClicked:  {
                        playPause()
                    }
                    visible: (xbmcPlayer.speed > 0)
                }
                ToolButton {
                    id: btPlay
                    iconSource: "toolbar-mediacontrol-play"
                    onClicked: {
                        playPause();
                    }
                    visible: (xbmcPlayer.speed <= 0)
                }
                ToolButton {
                    iconSource: "img/skip.svg"
                    onClicked: xbmcPlayer.skipNext()
                }
            }
            ToolButton {
                id: btVolume
                iconSource: main.muted ? "img/mute.svg" : "img/volume.svg"

                onClicked: {
                    volume.visible = !volume.visible
                }
            }
        }
    }

    Volume {
        id: volume
        anchors.right: parent.right
        anchors.bottom: tbar.top

        visible: false
    }

    //    onVisibleChanged: {
    //        if (!visible)
    //            btPlaylist.checked = false
    //    }

    XbmcPlayer {
        id: xbmcPlayer
        type: root.playerType
        transport: xbmcTcpClient

        onSpeedChanged: console.debug("speed changed:"+xbmcPlayer.speed)
    }

    onPlaylistIdChanged: {
        console.debug("player plylistid: " + playlistId)
    }

    function playPause() {
        if (xbmcPlayer.speed < 0) {
            $().playlist.play(playlistId, 0)
        } else
            xbmcPlayer.playPause()
    }

    function stop() {
        console.debug("stop:" + xbmcPlayer.speed);
        if (xbmcPlayer.speed >= 0)
            xbmcPlayer.stop()
    }

    function seekPercentage(percent) {
        xbmcPlayer.seek(percent)
    }

    function playFile(file) {
        xbmcPlayer.playFile(file)
    }

    Component.onCompleted: {
    }
}
