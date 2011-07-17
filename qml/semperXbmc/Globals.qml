import QtQuick 1.0
import "js/settings.js" as DbSettings

QtObject {
    property string server: ""
    property string jsonPort: ""
    property string eventPort: ""
    property bool showViewed: true

    function load() {
        DbSettings.initialize();

        server = DbSettings.getSetting("server", "Unspecified");
        jsonPort = DbSettings.getSetting("jsonPort", "8080");
        eventPort = DbSettings.getSetting("eventPort", "9777");
        showViewed = DbSettings.getSetting("showViewed", true);

        console.debug(showViewed);
    }

    function save() {
        DbSettings.setSetting("server", server);
        DbSettings.setSetting("jsonPort", jsonPort);
        DbSettings.setSetting("eventPort", eventPort);
        DbSettings.setSetting("showViewed", showViewed);
    }
}
