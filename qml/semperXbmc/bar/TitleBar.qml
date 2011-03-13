import QtQuick 1.0

Item {

    id: container

    signal prefClicked
    signal homeClicked
    signal backClicked
    signal quitClicked

    property string text: "TITLE"
    property string fontName: "Helvetica"
    property int fontSize: 18
    property color fontColor: "lightgray"
    property bool fontBold: false

    Rectangle {
        anchors.fill: parent; color: "#343434";

        Text {
            id: titleText
            width:  parent.width
            horizontalAlignment: Text.AlignLeft
            smooth: true
            clip: true
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left; leftMargin: 10;
            }
            color: container.fontColor

            font {
                bold: container.fontBold
                family: container.fontName
                pointSize: container.fontSize
            }

            text: container.text
            elide: Text.ElideLeft
            textFormat: Text.RichText
            wrapMode: Text.Wrap
            verticalAlignment: Text.AlignVCenter
        }

        Flipable {
            id: flipBackQuit
            anchors.right: parent.right; anchors.rightMargin: 10;
            width: parent.height-4
            height: parent.height-4
            anchors.verticalCenter: parent.verticalCenter

            front:
                Button {
                id: quitButton
                anchors.fill: parent
                onClicked: quitClicked()
                imageSource: "img/delete_48.png"
            }

            back:
                Button {
                id: backButton
                anchors.fill: parent
                onClicked: backClicked()
                imageSource: "img/arrow_circle_left_48.png"
            }

            transform: Rotation {
                id: rotation1
                origin.x: flipBackQuit.width/2
                origin.y: flipBackQuit.height/2
                axis.x: 0; axis.y: 1; axis.z: 0     // set axis.y to 1 to rotate around y-axis
                angle: 0    // the default angle
            }

            states: State {
                name: "back"
                PropertyChanges {
                    target: rotation1;
                    angle: 180
                }
            }

            transitions: Transition {
                NumberAnimation { target: rotation1; property: "angle"; duration: 500 }
            }
        }

        Flipable {
            id: flipPrefHome
            anchors.right: flipBackQuit.left; anchors.rightMargin: 10
            width: parent.height-4
            height: parent.height-4
            anchors.verticalCenter: parent.verticalCenter

            front:
                Button {
                id: prefButton
                anchors.fill: parent
                onClicked: prefClicked()
                imageSource: "img/gear_48.png"
            }
            back:
                Button {
                id: homeButton
                anchors.fill: parent
                onClicked: homeClicked()
                imageSource: "img/home_48.png"
            }

            transform: Rotation {
                id: rotation2
                origin.x: flipPrefHome.width/2
                origin.y: flipPrefHome.height/2
                axis.x: 0; axis.y: 1; axis.z: 0     // set axis.y to 1 to rotate around y-axis
                angle: 0    // the default angle
            }

            states: State {
                name: "back"
                PropertyChanges {
                    target: rotation2;
                    angle: 180
                }
            }

            transitions: Transition {
                NumberAnimation { target: rotation2; property: "angle"; duration: 500 }
            }
        }
    }

    states: [
        State {
            name: "content"
            PropertyChanges {
                target: flipBackQuit
                state: "back"
            }
            PropertyChanges {
                target: flipPrefHome
                state: "back"
            }
        }

    ]
//    transitions: Transition {
//        PropertyAnimation {
//            properties: "x";
//            easing.type: Easing.InOutCubic
//            duration: 500
//        }
//    }
}
