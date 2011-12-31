import QtQuick 1.0
import com.nokia.symbian 1.1

CommonDialog {
    id: dialog

    titleText: "CONNECTION SETTINGS"
    buttonTexts: ["OK", "Cancel"]
    content: Flickable {
        anchors { left: parent.left; right: parent.right; top: parent.top; }
        anchors.margins: platformStyle.paddingMedium
        height: 250

        Column {
            spacing: 10

            Grid {
                id: grid
                anchors.horizontalCenter: parent.horizontalCenter

                columns: 2
                spacing: platformStyle.paddingMedium

                Text {
                    font.family: platformStyle.fontFamilyRegular
                    font.pixelSize: platformStyle.fontSizeLarge
                    color: platformStyle.colorNormalLight
                    height: inpServer.height
                    verticalAlignment: Text.AlignVCenter

                    text: "Server:"
                }

                TextField {
                    id: inpServer
                    width: 200
                }

                Text {
                    font.family: platformStyle.fontFamilyRegular
                    font.pixelSize: platformStyle.fontSizeLarge
                    color: platformStyle.colorNormalLight
                    height: inpJsonPort.height
                    verticalAlignment: Text.AlignVCenter

                    text: "HTTP port:"
                }

                TextField {
                    id: inpJsonPort
                    width: 100
                }

                Text {
                    font.family: platformStyle.fontFamilyRegular
                    font.pixelSize: platformStyle.fontSizeLarge
                    color: platformStyle.colorNormalLight
                    height: inpJsonPort.height
                    verticalAlignment: Text.AlignVCenter

                    text: "HTTP User:"
                }

                TextField {
                    id: inpJsonUser
                    width: 200
                }

                Text {
                    font.family: platformStyle.fontFamilyRegular
                    font.pixelSize: platformStyle.fontSizeLarge
                    color: platformStyle.colorNormalLight
                    height: inpJsonPort.height
                    verticalAlignment: Text.AlignVCenter

                    text: "HTTP Password:"
                }

                TextField {
                    id: inpJsonPassword
                    width: 200
                    echoMode: TextInput.Password
                }

                Text {
                    font.family: platformStyle.fontFamilyRegular
                    font.pixelSize: platformStyle.fontSizeLarge
                    color: platformStyle.colorNormalLight
                    height: inpEventPort.height
                    verticalAlignment: Text.AlignVCenter

                    text: "Event port:"
                }

                TextField {
                    id: inpEventPort
                    width: 100
                }

            }
        }

    }

    function setup() {
        if (globals.server == "Unspecified")
            inpServer.placeholderText = "XBMC server address"
        else
            inpServer.text = globals.server;
        inpJsonPort.text = globals.jsonPort;
        inpJsonUser = globals.jsonUser
        inpJsonPassword = globals.jsonPassword
        inpEventPort.text = globals.eventPort;
    }

    onAccepted: {
        globals.server = inpServer.text;
        globals.jsonPort = inpJsonPort.text;
        globals.jsonUser = inpJsonUser.text
        globals.jsonPassword = inpJsonPassword.text
        globals.eventPort = inpEventPort.text;

        globals.save();
    }

    onButtonClicked: {
        switch (index) {
        case 0: //OK
            dialog.accept()
            break;
        case 1: // Cancel
            dialog.reject()
            break;
        }
    }

    Component.onCompleted: setup()
}
