import QtQuick 1.0
import XbmcEvents 1.0

Item {
    BorderImage {
        id: globalKeys
        border.left: 30; border.top: 30
        border.right: 30; border.bottom: 30
        source: "img/remote/remote_background.png"
        height: 300
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }


        RemoteNavigation {
            id: remotenavigationGlobal
            anchors.fill: parent


            onUpClicked: {
                xbmcEventClient.keypress("up");
            }
            onDownClicked: {
                xbmcEventClient.keypress("down");
            }
            onLeftClicked: {
                xbmcEventClient.keypress("left");
            }
            onRightClicked: {
                xbmcEventClient.keypress("right");
            }
            onCenterClicked: {
                xbmcEventClient.keypress("return");
            }

            RemoteButton {
                anchors.top: parent.top
                anchors.topMargin: 7
                anchors.left: parent.left
                anchors.leftMargin: 7
                iconSource: "img/remote/home_48.png"
                onClicked: xbmcEventClient.keypress("escape");
            }

            RemoteButton {
                anchors.right: parent.right
                anchors.rightMargin: 7
                anchors.top: parent.top
                anchors.topMargin: 7
                iconSource: "img/remote/arrow_circle_left_48.png"
                onClicked: xbmcEventClient.keypress("backspace");
            }

            RemoteButton {
                anchors.left: parent.left
                anchors.leftMargin: 7
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 7
                iconSource: "img/remote/info_48.png"
                onClicked: xbmcEventClient.keypress("i");
            }

            RemoteButton {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 7
                anchors.rightMargin: 7
                anchors.right: parent.right
                iconSource: "img/remote/comment_48.png"
                onClicked: xbmcEventClient.keypress("c");
            }
        }

    }

    BorderImage {
        border.left: 30; border.top: 30
        border.right: 30; border.bottom: 30
        source: "img/remote/remote_background.png"
        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
            bottom: globalKeys.top
        }

        RemoteNavigation {
            id: remotenavigationPlayer
            scale:  0.7
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            textCenter: "Mute"
            iconLeft: "img/remote/video_rewind_48.png"
            iconRight: "img/remote/video_forward_48.png"
            iconTop: "img/remote/video_stop_48.png"
            iconBottom: "img/remote/video_play_48.png"

            onUpClicked: xbmcEventClient.actionButton("Stop");
            onDownClicked: xbmcEventClient.actionButton("Play");
            onLeftClicked: xbmcEventClient.actionButton("Rewind");
            onRightClicked: xbmcEventClient.actionButton("FastForward");
            onCenterClicked: xbmcEventClient.actionButton("Mute");
        }

        RemoteButton {
            anchors.top: parent.top
            anchors.topMargin: 7
            anchors.left: parent.left
            anchors.leftMargin: 7
            iconSource: "img/remote/pgup_48.png"
            onClicked: xbmcEventClient.keypress("pageup");
        }

        RemoteButton {
            anchors.right: parent.right
            anchors.rightMargin: 7
            anchors.top: parent.top
            anchors.topMargin: 7
            iconSource: "img/remote/volume_up_48.png"
            onClicked: xbmcEventClient.actionButton("VolumeUp");
        }

        RemoteButton {
            anchors.left: parent.left
            anchors.leftMargin: 7
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 7
            iconSource: "img/remote/pgdn_48.png"
            onClicked: xbmcEventClient.keypress("pagedown");
        }

        RemoteButton {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 7
            anchors.rightMargin: 7
            anchors.right: parent.right
            iconSource: "img/remote/volume_down_48.png"
            onClicked: xbmcEventClient.actionButton("VolumeDown");
        }
    }


    XbmcClient {
        id: xbmcEventClient
    }

    function settingsChanged() {
//        console.debug("settings changed");
        xbmcEventClient.initialize(globals.server, globals.eventPort);
    }
}