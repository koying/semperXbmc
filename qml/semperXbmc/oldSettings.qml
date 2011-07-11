import QtQuick 1.0
import com.nokia.symbian 1.0
import "js/settings.js" as DbSettings

CommonDialog {
    id: container;

    property alias server: inpServer.text
    property alias jsonPort: inpJsonPort.text
    property alias eventPort: inpEventPort.text

    property alias state:  background.state

    signal settingsChanged();

    Rectangle {
        id: background

        opacity: 0
        radius: 15
        anchors.fill: parent
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#999999"
            }

            GradientStop {
                position: 1
                color: "#555555"
            }
        }

        Text {
            id: text1
            x: 89
            width: 80
            height: 25
            color: "#ffffff"
            text: "<b>SETTINGS</b>"
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.top: parent.top
            anchors.topMargin: 15
            font.pointSize: 11
        }

        Text {
            id: text2
            y: 71
            width: 80
            height: 25
            color: "#ffffff"
            text: "Server:"
            anchors.left: parent.left
            anchors.leftMargin: 20
            font.pointSize: 8
        }

        Text {
            id: text3
            width: 80
            height: 25
            color: "#ffffff"
            text: "JSON port"
            anchors.top: text2.bottom
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 20
            font.pointSize: 8
        }

        Text {
            id: text4
            width: 80
            height: 25
            color: "#ffffff"
            text: "Event port"
            anchors.top: text3.bottom
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 20
            font.pointSize: 8
        }

        TextInput {
            id: inpServer
            x: 136
            y: 68
            width: 150
            height: 25
            horizontalAlignment: TextInput.AlignRight
            anchors.right: parent.right
            anchors.rightMargin: 20
            font.pointSize: 8
        }

        TextInput {
            id: inpJsonPort
            x: 135
            y: 98
            width: 150
            height: 25
            horizontalAlignment: TextInput.AlignRight
            anchors.right: parent.right
            anchors.rightMargin: 20
            font.pointSize: 8
        }

        TextInput {
            id: inpEventPort
            x: 144
            y: 128
            width: 150
            height: 25
            horizontalAlignment: TextInput.AlignRight
            anchors.right: parent.right
            anchors.rightMargin: 20
            font.pointSize: 8
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
                font.pointSize: 11
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
                    background.state = "";
                    container.settingsChanged();
                }
            }
        }

        states: [
            State {
                name: "shown";
                PropertyChanges {
                    target: background;
                    opacity: 0.95;
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
    }

    function setup() {
        DbSettings.initialize();

        var host = DbSettings.getSetting("server", "Unspecified");
        var jsonPort = DbSettings.getSetting("jsonPort", "8080");
        var eventPort = DbSettings.getSetting("eventPort", "9777");

        inpServer.text = host;
        inpJsonPort.text = jsonPort;
        inpEventPort.text = eventPort;

        globals.server = inpServer.text;
        globals.jsonPort = inpJsonPort.text;
        globals.eventPort = inpEventPort.text;

        if (host == "Unspecified") {
            background.state = "shown";
            return;
        }

        container.settingsChanged();
    }

    function saveSettings() {
        DbSettings.setSetting("server", inpServer.text);
        DbSettings.setSetting("jsonPort", inpJsonPort.text);
        DbSettings.setSetting("eventPort", inpEventPort.text);

        globals.server = inpServer.text;
        globals.jsonPort = inpJsonPort.text;
        globals.eventPort = inpEventPort.text;
    }

    Component.onCompleted: setup();
}
