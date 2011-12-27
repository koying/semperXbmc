import QtQuick 1.0
import com.nokia.symbian 1.1

CommonDialog {
    id: dialog

    titleText: "CONNECTION SETTINGS"

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

                    text: "JSON port:"
                }

                TextField {
                    id: inpJsonPort
                    width: 200
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
                    width: 200
                }

            }
        }

    }

    buttons: ToolBar {
        id: buttons
        width: parent.width
        height: privateStyle.toolBarHeightLandscape + 2 * platformStyle.paddingSmall

        tools: Row {
            anchors.centerIn: parent
            spacing: platformStyle.paddingMedium

            ToolButton {
                text: "Ok"
                width: (buttons.width - 3 * platformStyle.paddingMedium) / 2
                onClicked: dialog.accept()
            }

            ToolButton {
                text: "Cancel"
                width: (buttons.width - 3 * platformStyle.paddingMedium) / 2
                onClicked: dialog.reject()
            }
        }
    }

    function setup() {
        if (globals.server == "Unspecified")
            inpServer.placeholderText = "XBMC server address"
        else
            inpServer.text = globals.server;
        inpJsonPort.text = globals.jsonPort;
        inpEventPort.text = globals.eventPort;
    }

    onAccepted: {
        globals.server = inpServer.text;
        globals.jsonPort = inpJsonPort.text;
        globals.eventPort = inpEventPort.text;

        globals.save();
    }

    Component.onCompleted: setup()
}
