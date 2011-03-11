import QtQuick 1.0
import "js/settings.js" as DbSettings

Item{
    id: container;

    property alias server: inpServer.text
    property alias jsonPort: inpJsonPort.text
    property alias eventPort: inpEventPort.text

    signal settingsChanged();

    width: 300
    height: 300
    opacity: 0

    Rectangle {
        id: background
        radius: 15
        anchors.fill: parent
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#cccccc"
            }

            GradientStop {
                position: 1
                color: "#777777"
            }
        }

        Text {
            id: text1
            x: 89
            width: 80
            height: 20
            color: "#ffffff"
            text: "<b>SETTINGS</b>"
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.top: parent.top
            anchors.topMargin: 15
            font.pixelSize: 24
        }

        Text {
            id: text2
            y: 71
            width: 80
            height: 20
            color: "#ffffff"
            text: "Server:"
            anchors.left: parent.left
            anchors.leftMargin: 20
            font.pixelSize: 14
        }

        Text {
            id: text3
            width: 80
            height: 20
            color: "#ffffff"
            text: "JSON port"
            anchors.top: text2.bottom
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 20
            font.pixelSize: 14
        }

        Text {
            id: text4
            width: 80
            height: 20
            color: "#ffffff"
            text: "Event port"
            anchors.top: text3.bottom
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 20
            font.pixelSize: 14
        }

        TextInput {
            id: inpServer
            x: 110
            y: 68
            width: 90
            height: 20
            text: "192.168.1.1"
            horizontalAlignment: TextInput.AlignRight
            anchors.right: parent.right
            anchors.rightMargin: 20
            font.pixelSize: 14
        }

        TextInput {
            id: inpJsonPort
            x: 137
            y: 98
            width: 40
            height: 20
            text: "6780"
            horizontalAlignment: TextInput.AlignRight
            anchors.right: parent.right
            anchors.rightMargin: 20
            font.pixelSize: 14
        }

        TextInput {
            id: inpEventPort
            x: 144
            y: 128
            width: 40
            height: 20
            text: "9777"
            horizontalAlignment: TextInput.AlignRight
            anchors.right: parent.right
            anchors.rightMargin: 20
            font.pixelSize: 14
        }

        Rectangle {
            id: rectangle2
            x: 50
            y: 169
            width: 100
            height: 48
            color: "#00000000"
            radius: 10
            anchors.horizontalCenterOffset: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            border.width: 2
            border.color: "#ffffff"
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                id: text5
                x: 39
                y: 26
                color: "#ffffff"
                text: "DONE"
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 18
            }

            MouseArea {
                id: backArea
                anchors.fill: parent
                drag.minimumY: -1000
                drag.minimumX: -1000
                drag.maximumY: 1000
                drag.maximumX: 1000

                onClicked: {
                    saveSettings();
                    state = "";
                    container.settingsChanged();
                }
            }
        }
    }

    states: [
        State {
            name: "shown";
            PropertyChanges {
                target: background;
                opacity: 0.7;
            }
        }
    ]

    transitions: [
        Transition {
            from: "";
            to: "shown";
            SequentialAnimation {
                NumberAnimation {
                    properties: "opacity";
                    easing.type: "OutCubic";
                    duration: 100;
                }
            }
        },
        Transition {
            from: "shown";
            to: "";
            SequentialAnimation {
                NumberAnimation {
                    properties: "opacity";
                    easing.type: "OutCubic";
                    duration: 100;
                }
            }
        }
    ]

    function setup() {
        DbSettings.initialize();

        var host = DbSettings.getSetting("server", "Unspecified");
        var jsonPort = DbSettings.getSetting("jsonPort", "8080");
        var eventPort = DbSettings.getSetting("jsonPort", "9777");

        inpServer.text = host;
        inpJsonPort.text = jsonPort;
        inpEventPort.text = eventPort;

        container.settingsChanged();
    }

    function saveSettings() {
        DbSettings.setSetting("server", inpServer.text);
        DbSettings.setSetting("jsonPort", inpJsonPort.text);
        DbSettings.setSetting("eventPort", inpEventPort.text);
    }

    Component.onCompleted: setup();
}
