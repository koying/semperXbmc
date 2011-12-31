import QtQuick 1.0
import com.nokia.symbian 1.1

CommonDialog {
    id: dialog
    height: platformContentMaximumHeight

    titleText: "CONNECTION SETTINGS"
    buttonTexts: ["OK", "Cancel"]
    content: Flickable {
        anchors.fill: parent
        anchors.margins: platformStyle.paddingMedium

        contentHeight: grid.height
        boundsBehavior: Flickable.StopAtBounds

        Grid {
            id: grid
            property int lineWidth: (width - platformStyle.paddingMedium*2)

            width: parent.width
            spacing: platformStyle.paddingMedium
            columns: 2

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
                width: grid.lineWidth - (lblMax.width + platformStyle.paddingMedium)
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
                id: lblMax
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeLarge
                color: platformStyle.colorNormalLight
                height: inpJsonPort.height
                verticalAlignment: Text.AlignVCenter

                text: "HTTP User:"
            }

            TextField {
                id: inpJsonUser
                width: grid.lineWidth - (lblMax.width + platformStyle.paddingMedium)
            }

            Text {
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeLarge
                color: platformStyle.colorNormalLight
                height: inpJsonPort.height
                verticalAlignment: Text.AlignVCenter

                text: "HTTP Pwd:"
            }

            TextField {
                id: inpJsonPassword
                width: grid.lineWidth - (lblMax.width + platformStyle.paddingMedium)
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

    function setup() {
        if (globals.server == "Unspecified")
            inpServer.placeholderText = "XBMC server address"
        else
            inpServer.text = globals.server;
        inpJsonPort.text = globals.jsonPort;
        inpJsonUser.text = globals.jsonUser
        inpJsonPassword.text = globals.jsonPassword
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
