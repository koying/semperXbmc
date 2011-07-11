import QtQuick 1.0
import com.nokia.symbian 1.0
import "js/settings.js" as DbSettings

CommonDialog {
    id: dialog

    property alias server: inpServer.text
    property alias jsonPort: inpJsonPort.text
    property alias eventPort: inpEventPort.text

    signal settingsChanged();


    content: Item {
        anchors { left: parent.left; right: parent.right; top: parent.top; }
        anchors.margins: platformStyle.paddingMedium
        height: 175

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
            container.open();
            return;
        }

        dialog.settingsChanged();
    }

    function saveSettings() {
        DbSettings.setSetting("server", inpServer.text);
        DbSettings.setSetting("jsonPort", inpJsonPort.text);
        DbSettings.setSetting("eventPort", inpEventPort.text);

        globals.server = inpServer.text;
        globals.jsonPort = inpJsonPort.text;
        globals.eventPort = inpEventPort.text;
    }

    onAccepted: {
        saveSettings();
    }

    Component.onCompleted: setup();
}
