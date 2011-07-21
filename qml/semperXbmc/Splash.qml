import QtQuick 1.0

Rectangle {
    id: bg

    signal hidden

    onOpacityChanged: {
        if (opacity == 0)
            hidden();
    }

    color: "#80ffffff"
    opacity: 0

    Rectangle {
        id: rectangle1
        width: 320
        height: 320
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color: "transparent"

        Image {
            id: image1
            height: 320
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: parent.top
            smooth: true
            source: "img/semperXbmc_Splash.svg"

            Text {
                id: lbTitle
                color: "#ffffff"
                text: "semper"
                anchors.top: parent.top
                anchors.topMargin: 26
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                font.italic: true
                font.pixelSize: 35
            }

            Text {
                id: lbBy
                color: "#c8c8c8"
                text: "by semperpax"
                anchors.top: lbTitle.bottom
                anchors.topMargin: 94
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 15
            }

            Text {
                id: txVersion
                color: "#ffffff"
                //                text: "v" + appVersion
                text:  "v0.9.0"
                anchors.top: lbBy.bottom
                anchors.topMargin: 15
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 35
            }

            Text {
                id: lbLink
                color: "#c8c8c8"
                text: "http://redmine.semperpax.com /semperxbmc"
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 20
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.rightMargin: 30
                anchors.leftMargin: 30
                font.pixelSize: 17
                horizontalAlignment: "AlignHCenter"
                wrapMode: "WrapAtWordBoundaryOrAnywhere"

                onLinkActivated: Qt.openUrlExternally(link)
                MouseArea {
                    anchors.fill: parent
                    onClicked: Qt.openUrlExternally("http://redmine.semperpax.com/projects/semperxbmc/wiki")
                }
            }
        }

    }

    MouseArea {
        anchors.fill: parent
        onClicked: bg.state = ""
    }

    Behavior on opacity {
        NumberAnimation { duration: 500 }
    }

    Timer {
        id: splashTimer
        interval: 5000
        onTriggered: bg.state = ""
    }

    states: [
        State {
            name: "show"
            PropertyChanges {
                target: bg
                opacity: 1
            }
            PropertyChanges {
                target: splashTimer
                running: true
            }
        }
    ]
}
