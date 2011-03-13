import QtQuick 1.0

Item {
    id: container

    signal centerClicked()
    signal upClicked()
    signal downClicked()
    signal leftClicked()
    signal rightClicked()

    property string iconTop: "img/remote/arrow_up_48.png"
    property string iconBottom: "img/remote/arrow_down_48.png"
    property string iconLeft: "img/remote/arrow_left_48.png"
    property string iconRight: "img/remote/arrow_right_48.png"
    property string textCenter: "OK"

    Item {
        id: background
        width:  container.width; height: container.height

        RemoteButton {
            id: btUp
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -80
            imageSourceRoot: "img/remote/remote_cross_top"
            iconSource: container.iconTop
            onClicked: container.upClicked()
        }

        RemoteButton {
            id: btDown
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 80
            imageSourceRoot: "img/remote/remote_cross_bottom"
            iconSource: container.iconBottom
            onClicked: container.downClicked()
        }

        RemoteButton {
            id: btLeft
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenterOffset: -80
            imageSourceRoot: "img/remote/remote_cross_left"
            iconSource: container.iconLeft
            onClicked: container.leftClicked()
        }

        RemoteButton {
            id: btRight
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenterOffset: 80
            imageSourceRoot: "img/remote/remote_cross_right"
            iconSource: container.iconRight
            onClicked: container.rightClicked()
        }

        RemoteButton {
            id: btCenter
            anchors.centerIn: parent
            imageSourceRoot: "img/remote/remote_button"
            text:  container.textCenter
            onClicked: container.centerClicked()
        }

    }

}
