// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1
import com.semperpax.qmlcomponents 1.0

import "js/Utils.js" as Utils

Item {
    id: root
    anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
    height: tbar.height

    property int playlistId: -255
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
                    enabled: (xbmcPlayer.speed != -255)
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
                    visible: (xbmcPlayer.speed == 1)
                }
                ToolButton {
                    id: btPlay
                    iconSource: "toolbar-mediacontrol-play"
                    onClicked: {
                        playPause();
                    }
                    visible: (xbmcPlayer.speed != 1)
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
        onPositionChanged: console.debug("position changed:"+xbmcPlayer.position)
    }

    onPlaylistIdChanged: {
        console.debug("player plylistid: " + playlistId)
        if (!(root.playlistId < 0))
            refresh();
    }

    function playPause() {
        console.debug("speed: " + xbmcPlayer.speed)
        if (xbmcPlayer.speed == -255) {
            $().playlist.play(playlistId, 0)
        } else
            xbmcPlayer.playPause()
    }

    function stop() {
        console.debug("stop:" + xbmcPlayer.speed);
        if (xbmcPlayer.speed != -255)
            xbmcPlayer.stop()
    }

    function seekPercentage(percent) {
        xbmcPlayer.seek(percent)
    }

    function playFile(file) {
        xbmcPlayer.playFile(file)
    }

    function refresh() {
        var doc = new globals.getJsonXMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.DONE) {
                var oJSON = JSON.parse(doc.responseText);
                var error = oJSON.error;
                if (error) {
                    xbmcPlayer.speed = -255
                    xbmcPlayer.position = -1
                    xbmcPlayer.percentage = -1
                } else {
                    var results = oJSON.result;
                    xbmcPlayer.speed = results.speed
                    xbmcPlayer.position = results.position
                    xbmcPlayer.percentage = results.percentage
                }
             }
        }

        var o = { jsonrpc: "2.0", method: "Player.GetProperties", params: { playerid: root.playlistId, properties: ["speed", "percentage", "time", "totaltime", "position"] }, id: 1};
        var str = JSON.stringify(o);
        doc.send(str);
    }

    Component.onCompleted: {
    }
}
