import QtQuick 1.0
import XbmcEvents 1.0

Item {
    id: container
    width: 320
    height: 320

    signal okClicked()
    signal upClicked()
    signal downClicked()
    signal leftClicked()
    signal righClicked()
    signal uLClicked()
    signal bLClicked()
    signal uRClicked()
    signal bRClicked()

    Image {
        id: image1
        anchors.fill: parent
        source: "img/remote/remote_background.png"

        Image {
            id: btUp
            x: 118
            width: 172
            height: 91
            anchors.top: parent.top
            anchors.topMargin: 35
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectCrop
            source: "img/remote/remote_cross_top.png"

            Image {
                id: image4
                x: 62
                anchors.top: parent.top
                anchors.topMargin: 15
                anchors.horizontalCenter: parent.horizontalCenter
                source: "img/remote/arrow_up_48.png"
            }

            MouseArea {
                id: mouse_area1
                anchors.fill: parent
                onClicked: container.UpClicked()
            }
        }

        Image {
            id: btDown
            x: 121
            y: 193
            width: 171
            height: 91
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 35
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectCrop
            source: "img/remote/remote_cross_bottom.png"

            Image {
                id: image5
                x: 72
                y: 36
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 15
                anchors.horizontalCenter: parent.horizontalCenter
                source: "img/remote/arrow_down_48.png"
            }

            MouseArea {
                id: mouse_area4
                anchors.fill: parent
                onClicked: container.DownClicked()
            }
        }

        Image {
            id: btLeft
            y: 134
            width: 91
            height: 171
            anchors.left: parent.left
            anchors.leftMargin: 35
            anchors.verticalCenter: parent.verticalCenter
            fillMode: Image.PreserveAspectCrop
            source: "img/remote/remote_cross_left.png"

            Image {
                id: image2
                y: 62
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                source: "img/remote/arrow_left_48.png"
            }

            MouseArea {
                id: mouse_area3
                anchors.fill: parent
                onClicked: container.LeftClicked()
            }
        }

        Image {
            id: btRight
            x: 274
            y: 110
            width: 91
            height: 171
            anchors.right: parent.right
            anchors.rightMargin: 35
            anchors.verticalCenter: parent.verticalCenter
            source: "img/remote/remote_cross_right.png"

            Image {
                id: image3
                y: 62
                anchors.right: parent.right
                anchors.rightMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                source: "img/remote/arrow_right_48.png"
            }

            MouseArea {
                id: mouse_area2
                anchors.fill: parent
                onClicked: container.RightClicked()
            }
        }
    }

    Image {
        id: btOK
        x: -32
        y: -33
        width: 64
        height: 64
        anchors.centerIn: parent
        source: "img/remote/remote_button.png"

        Text {
            id: text1
            x: 21
            y: 38
            color: "#aaaaaa"
            text: "OK"
            font.bold: true
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 24
        }

        MouseArea {
            id: mouse_area5
            anchors.fill: parent
            onClicked: container.OkClicked()
        }
    }

    Image {
        id: btUL
        width: 64
        height: 64
        anchors.top: parent.top
        anchors.topMargin: 7
        anchors.left: parent.left
        anchors.leftMargin: 7
        source: "img/remote/remote_button.png"

        Image {
            id: image8
            x: 8
            y: 8
            width: 36
            height: 36
            anchors.centerIn: parent
            source: "img/remote/home_48.png"
        }

        MouseArea {
            id: mouse_area8
            anchors.fill: parent
            onClicked: container.ULClicked()
        }
    }

    Image {
        id: btUR
        x: -3
        y: 7
        width: 64
        height: 64
        anchors.right: parent.right
        anchors.rightMargin: 7
        anchors.top: parent.top
        anchors.topMargin: 7
        source: "img/remote/remote_button.png"

        Image {
            id: image9
            x: 8
            y: 8
            width: 36
            height: 36
            anchors.centerIn: parent
            source: "img/remote/arrow_circle_left_48.png"
        }

        MouseArea {
            id: mouse_area9
            anchors.fill: parent
            onClicked: container.URClicked()
        }
    }

    Image {
        id: btBL
        y: 14
        width: 64
        height: 64
        anchors.left: parent.left
        anchors.leftMargin: 7
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 7
        source: "img/remote/remote_button.png"

        Image {
            id: image6
            width: 36
            height: 36
            fillMode: Image.PreserveAspectFit
            sourceSize.height: 40
            sourceSize.width: 40
            anchors.centerIn: parent
            source: "img/remote/video_play_48.png"
        }

        MouseArea {
            id: mouse_area6
            anchors.fill: parent
            onClicked: container.BLClicked()
        }
    }

    Image {
        id: btBR
        x: -2
        y: 0
        width: 64
        height: 64
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 7
        source: "img/remote/remote_button.png"
        anchors.rightMargin: 7
        anchors.right: parent.right

        Image {
            id: image7
            x: 16
            y: 8
            width: 36
            height: 36
            anchors.centerIn: parent
            source: "img/remote/video_stop_48.png"
        }

        MouseArea {
            id: mouse_area7
            anchors.fill: parent
            onClicked: container.BRClicked()
        }
    }

    XbmcClient {
        id: xbmcEventClient
    }
}
