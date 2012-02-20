// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1

import "js/xbmc.js" as Xbmc
import "js/json.js" as Json
import "js/player3.js" as Player

ToolBar {
    id: root
    anchors { left: parent.left; right: parent.right; bottom: parent.bottom }

    property int playlistId: -1
    property string  playerType: ""
    property bool playing: false
    property bool paused: false

    tools: ToolBarLayout {

        ButtonRow {
            ToolButton {
                iconSource: "img/back1.svg"
                onClicked: Player.oPlayer.skipPrevious()
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
                visible: playing && !paused
            }
            ToolButton {
                id: btPlay
                iconSource: "toolbar-mediacontrol-play"
                onClicked: {
                    playPause();
                }
                visible: !playing || paused
            }
            ToolButton {
                iconSource: "img/skip.svg"
                onClicked: Player.oPlayer.skipNext()
            }
        }

//        ToolButton {
//            id: btPlaylist
//            iconSource: "img/playlist.png"
//            checkable: true
//            onCheckedChanged: {
//                if (checked) {
//                    stack.push(Qt.resolvedUrl("PlayListView.qml"), {playlistId: playlistId})
//                } else {
//                    stack.pop()
//                }
//            }
//        }
//        ToolButton {
//            iconSource: "toolbar-delete"
//            onClicked: {
//                if ($().playlist.playing)
//                    oPlayer.stop()
//                $().playlist.clear(playlistId);
//            }
////            visible: playlistModel.count > 0
//        }

    }

//    onVisibleChanged: {
//        if (!visible)
//            btPlaylist.checked = false
//    }

    Connections {
        target: main
        onJsonInitializedChanged: {
            if (main.jsonInitialized) {
                initPlayer();
            }
        }
    }

    onPlaylistIdChanged: {
        console.debug("player plylistid: " + playlistId)
    }

    function initPlayer() {
        if (root.playerType == "")
            return

        Player.oPlayer = new Player.Player(root.playerType);
        var doc = new globals.getJsonXMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.DONE) {
//                console.debug(doc.responseText);
                var oJSON = JSON.parse(doc.responseText);
                var error = oJSON.error;
                if (error) {
                    Player.oPlayer.playing = false; root.playing = false
                    Player.oPlayer.paused = false; root.paused = false
                    return;
                }

                var results = oJSON.result;
                if (results.speed == 0) {
                    Player.oPlayer.paused = true; root.paused = true
                } else {
                    Player.oPlayer.playing = true; root.playing = true
                }
                Player.oPlayer.position = results.position
            }
        }

        var o = { jsonrpc: "2.0", method: "Player.GetProperties", params: { playerid: Player.oPlayer.playerId, properties: ["speed", "percentage", "time", "totaltime", "position"] }, id: 1};
        var str = JSON.stringify(o);
//        console.log(str);
        doc.send(str);
        return;
    }

    function playPause() {
        if (!playing && !paused) {
            $().playlist.play(playlistId);
        } else
            Player.oPlayer.playPause();
    }

    function stop() {
        if (playing ||paused)
        Player.oPlayer.stop()
    }

    Component.onCompleted: {
    }
}
