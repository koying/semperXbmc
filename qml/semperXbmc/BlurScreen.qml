import QtQuick 1.0
import com.nokia.symbian 1.1

Rectangle {
    id: blurScreen
    color: "white"
    state: "off"

    property alias status: txStatus.text

    BusyIndicator {
        id: busyCursor
        width: 96
        height: 96
        anchors.centerIn: parent

        running: false
    }

    Text {
        id: txStatus
        anchors { bottom: busyCursor.top; bottomMargin: 20; horizontalCenter: parent.horizontalCenter }
        color:  "white"
        font.weight: Font.Bold
        font.pointSize: 14
        horizontalAlignment: Text.AlignHCenter
    }

    states: [
        State {
            name: "on"

            PropertyChanges {
                target: blurScreen
                opacity: 0.5
            }

            PropertyChanges {
                target: busyCursor
                visible: false
            }
        },
        State {
            name: "busy"

            PropertyChanges {
                target: blurScreen
                opacity: 0.5
            }

            PropertyChanges {
                target: busyCursor
                running: true
            }
        },
        State {
            name: "off"

            PropertyChanges {
                target: blurScreen
                opacity: 0.0
            }

            PropertyChanges {
                target: busyCursor
                visible: false
                running: false
            }
        }
    ]

    transitions: [
        Transition {
            NumberAnimation {
                properties: "opacity"
                duration: 200
            }
        }
    ]
}

// End of file.
