import QtQuick 1.0
import com.nokia.symbian 1.1
import com.semperpax.qmlcomponents 1.0
import "components" as Cp;

Rectangle {
    Cp.AutoDestructLoader { id: remoteMenu; anchors.fill:  parent; z:5 }
    Connections {
        target: remoteMenu.item
        onClose: remoteMenu.sourceUrl = ""
    }

    Haptics {
        id: haptics
    }

    BorderImage {
        id: globalKeys
        border.left: 30; border.top: 30
        border.right: 30; border.bottom: 30
        source: "img/remote/remote_background.png"
        height: main.inPortrait ? parent.height / 2 * 1.1 : parent.height
        width: main.inPortrait ? parent.width : parent.width / 2 * 1.1

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
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 7
                anchors.rightMargin: 7
                anchors.right: parent.right
                iconSource: "img/remote/comment_48.png"
                onClicked: xbmcEventClient.keypress("c");
            }

            RemoteButton {
                anchors.left: parent.left
                anchors.leftMargin: 7
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 7
                iconSource: "img/remote/plus_48.png"
                onClicked: remoteMenu.sourceUrl = Qt.resolvedUrl("RemoteMenu.qml")
                onPressedandhold: remoteMenu.sourceUrl = Qt.resolvedUrl("RemoteShortcuts.qml")
            }
        }

    }

    BorderImage {
        id: playerKeys

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
            scale:  main.inPortrait ? 0.9 : 0.8
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
            autoRepeat: true
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
            autoRepeat: true
            onClicked: xbmcEventClient.actionButton("VolumeDown");
        }
    }

    states: [
        State {
            name: "inLandscape"
            when: !main.inPortrait
            PropertyChanges {
                target: globalKeys
                height: undefined
                width: parent.width / 2 * 1.1
            }
            AnchorChanges {
                target: globalKeys
                anchors.left: undefined
                anchors.top: parent.top
            }
            AnchorChanges {
                target: playerKeys
                anchors.right: globalKeys.left
                anchors.bottom: parent.bottom
            }
        }
    ]
}
