import QtQuick 1.0
import com.nokia.symbian 1.0
import com.semperpax.qmlcomponents 1.0
import "components" as Cp;

import "js/xbmc.js" as Xbmc
import "js/json.js" as Json

import "js/general.js" as General
import "js/player.js" as Player
import "js/library.js" as Library
import "js/playlist.js" as Playlist

import "js/general3.js" as General3
import "js/library3.js" as Library3
import "js/playlist3.js" as Playlist3
import "js/player3.js" as Player3

Window {
    id: main
    width: 360
    height: 640

    property bool jsonInitialized: false

    Globals {
        id: globals
    }

    Cp.ErrorView {
        id: errorView
        z: 5

       anchors.fill: parent
    }

//    StatusBar {
//        id: statusBar
//        property alias text: txTitle.text

//        anchors { top: parent.top; left: parent.left; right: parent.right }

//        Behavior on opacity {
//            NumberAnimation {
//                easing.type: Easing.InOutQuad
//            }
//        }

//        Text {
//            id: txTitle
//            anchors { left: parent.left; leftMargin: 10 }

//            color: "#2cb729"
//            font {
//                family: "Helvetica";
//                pixelSize: parent.height -5
//            }

//            text: mainTabGroup.currentTab.title
//        }

//        MouseArea {
//            id: statusArea
//            anchors.fill: parent
//        }
//    }

    ToolBar {
        id: toolBar
        anchors { left: parent.left; right: parent.right; top: parent.top }

        tools: ToolBarLayout {

            ToolButton {
                iconSource: "img/settings.svg"
                onClicked: {
                    settingMenu.open()
                }
            }

            ButtonRow {
                id: mainTabs
                exclusive: true
                opacity: 0

                TabButton {
                    iconSource: "img/home.png"
                    tab: remoteTab
                    onClicked: {
                        main.state = ""
                    }
                }

                TabButton {
                    iconSource: "img/filmstrip.png"
                    tab: movieTab
                    onClicked: {
                        main.state = "movies"
                        if (movieStack.depth == 0) {
                            movieStack.push(Qt.resolvedUrl(globals.initialMovieView))
                        }
                    }
                }

                TabButton {
                    iconSource: "img/tv.png"
                    tab: tvTab
                    onClicked: {
                        main.state = "tvshows"
                        if (tvshowStack.depth == 0) {
                            tvshowStack.push(Qt.resolvedUrl(globals.initialTvshowView))
                        }
                    }
                }

                TabButton {
                    iconSource: "img/music.png"
                    tab: musicTab
                    onClicked: {
                        main.state = "music"
                        if (musicStack.depth == 0) {
                            musicStack.push(Qt.resolvedUrl(globals.initialMusicView))
                        }
                    }
                }

                TabButton {
                    iconSource: "img/playlist.png"
                    tab:  playlistTab
                    onClicked: {
                        main.state = "playlist"
                        if (playListStack.depth == 0) {
                            playListStack.push(Qt.resolvedUrl("PlayListView.qml"))
                        }
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        easing.type: Easing.InOutQuad
                    }
                }

                states: [
                    State {
                        name: "initialized"; when: main.jsonInitialized
                        PropertyChanges {
                            target: mainTabs
                            opacity: 1
                        }
                    }
                ]
            }

            ToolButton {
                iconSource: "img/close_stop.svg"
                onClicked: mainMenu.open()
                onPlatformPressAndHold: Qt.quit()
            }
        }
    }

    ContextMenu {
        id: settingMenu
        MenuLayout {

            MenuItem {
                text:  "Display options"
                onClicked: {
                    options.source = "Options.qml"
                    options.item.open()
                }
            }

            MenuItem {
                text:  "Connection settings"
                onClicked: {
                    settings.source = "Settings.qml"
                    settings.item.open()
                }
            }
        }
    }

    ContextMenu {
        id: mainMenu
        MenuLayout {

            MenuItem {
                text:  "Quit"
                onClicked: Qt.quit();
            }

            MenuItem {
                text:  "Close XBMC and Quit"
                onClicked: {
                    xbmcEventClient.actionBuiltin("Quit");
                    Qt.quit();
                }
            }

            MenuItem {
                text:  "Shutdown XBMC and Quit"
                onClicked:  {
                    xbmcEventClient.actionBuiltin("Powerdown");
                    Qt.quit();
                }
            }
        }
    }

    TabGroup {
        id: mainTabGroup
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: toolBar.bottom
        anchors.bottom: parent.bottom


        RemoteView {
            id: remoteTab
            property string title: "REMOTE"
        }

        Item {
            id: movieTab

            PageStack {
                id: movieStack

                property string title: "MOVIES"

                anchors { top: parent.top; left: parent.left; right: parent.right; bottom: movieToolbar.top }
                toolBar: movieToolbar
            }

            ToolBar {
                id: movieToolbar
                anchors { bottom: parent.bottom; left: parent.left; right: parent.right }

                Behavior on opacity {
                    NumberAnimation {
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }

        Item {
            id: tvTab
            PageStack {
                id: tvshowStack

                property string title: "TV"

                anchors { top: parent.top; left: parent.left; right: parent.right; bottom: tvToolbar.top }
                toolBar: tvToolbar

            }
            ToolBar {
                id: tvToolbar
                anchors { bottom: parent.bottom; left: parent.left; right: parent.right }

                Behavior on opacity {
                    NumberAnimation {
                        easing.type: Easing.InOutQuad
                    }
                }
            }

        }

        Item {
            id: musicTab

            PageStack {
                id: musicStack

                property string title: "MUSIC"

                anchors { top: parent.top; left: parent.left; right: parent.right; bottom: musicToolbar.top }
                toolBar: musicToolbar

            }

            ToolBar {
                id: musicToolbar
                anchors { bottom: parent.bottom; left: parent.left; right: parent.right }

                Behavior on opacity {
                    NumberAnimation {
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }

        Item {
            id: playlistTab

            PageStack {
                id: playListStack

                property string title: "PLAYLIST"

                anchors { top: parent.top; left: parent.left; right: parent.right; bottom: playListToolbar.top }
                toolBar: playListToolbar

            }

            ToolBar {
                id: playListToolbar
                anchors { bottom: parent.bottom; left: parent.left; right: parent.right }

                Behavior on opacity {
                    NumberAnimation {
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }
    }

    Loader {
        id: settings
    }
    Connections {
        target: settings.item
        onSettingsChanged: {
            xbmcEventClient.initialize(globals.server, globals.eventPort);
            main.initialize();
        }
    }

    Loader {
        id: options
    }

    Loader {
        id: splash
        source: globals.showSplash ? "Splash.qml" : ""
        anchors.fill:  parent
        z: 5
        onLoaded: {
            item.state = "show"
        }
    }
    Connections {
        target: splash.item
        onHidden: {
            splash.source = ""
        }
    }


    /* Globale Models */
    SortFilterModel {
        id: artistProxyModel

        sourceModel: artistModel
    }
    VariantModel {
        id: artistModel
        fields: [ "id", "name", "poster", "selected", "posterThumb" ]
        thumbDir: thumbFile
    }

    SortFilterModel {
        id: albumProxyModel

        sourceModel: albumModel
    }
    VariantModel {
        id: albumModel
        fields: [ "idalbum", "name", "artist", "genre", "rating", "cover", "coverThumb" ]
        thumbDir: thumbFile
    }
    ListModel {
        id: trackModel
    }
    ListModel {
        id: playlistModel
    }

    ListModel {
        id: movieGenreModel
    }
    SortFilterModel {
        id: movieProxyModel

        sourceModel: movieModel
        boolFilterRole: globals.showViewed ? "" : "playcount"
    }
    VariantModel {
        id: movieModel
        fields: [ "id", "name", "poster", "genre", "duration", "runtime", "rating", "year", "playcount", "posterThumb" ]
        thumbDir: thumbFile
    }

    ListModel {
        id: tvshowGenreModel
    }
    SortFilterModel {
        id: tvshowProxyModel

        sourceModel: tvshowModel
        boolFilterRole: globals.showViewed ? "" : "playcount"
    }
    VariantModel {
        id: tvshowLastplayedModel
        fields: [ "id", "lastplayed" ]
        key: "id"

        stream: thumbFile + "/tvshowLastplayedModel.dat"
    }

    VariantModel {
        id: tvshowModel
        fields: [ "id", "name", "poster", "genre", "duration", "rating", "playcount", "posterThumb", "lastplayed" ]
        key: "id"
        relatedFields: [ "lastplayed" ]
        thumbDir: thumbFile
    }

    SortFilterModel {
        id: seasonProxyModel

        sourceModel: seasonModel
        boolFilterRole: globals.showViewed ? "" : "playcount"
    }
    VariantModel {
        id: seasonModel
        fields: [ "id", "name", "showtitle", "poster", "episodes", "genre", "duration", "rating", "playcount" ]
        thumbDir: thumbFile
    }

    SortFilterModel {
        id: episodeProxyModel

        sourceModel: episodeModel
        boolFilterRole: globals.showViewed ? "" : "playcount"
    }
    VariantModel {
        id: episodeModel
        fields: [ "id", "name", "poster", "tvshowId", "number", "duration", "rating", "playcount" ]
        thumbDir: thumbFile
    }

    XbmcEventClient {
        id: xbmcEventClient

        onErrorDetected: {
            errorView.addError(type, msg, info);
        }
    }

    XbmcJsonTcpClient {
        id: xbmcTcpClient

        onNotificationReceived: {
            var oJSON = JSON.parse(jsonMsg);
            var error = oJSON.error;
            if (error) {
                console.debug(Xbmc.dumpObj(error, "Error", "", 0));
                return;
            }
            console.debug(Xbmc.dumpObj(oJSON, "Notif", "", 0));

            var method = oJSON.method;
            console.debug(method);
            if (!method) {
                console.debug("no method");
                return;
            }

            var data = oJSON.params.data;
            if (!data) {
                console.debug("No data");
                return;
            }
            console.debug(Xbmc.dumpObj(data, "data", "", 0));

            switch (method) {
            case "VideoLibrary.OnUpdate":
                switch(data.type) {
                case "movie":
                    movieModel.update(data);
                    break;

                case "episode":
                    episodeModel.update(data);
                    break;
                }

                break;

            case "VideoLibrary.OnRemove":
                switch(data.type) {
                case "movie":
                    movieModel.remove(data);
                    break;

                case "episode":
                    episodeModel.remove(data);
                    break;
                }

                break;

            case "AudioLibrary.OnUpdate":
                break;

            case "AudioLibrary.OnRemove":
                break;
            }

        }

        onErrorDetected: {
            errorView.addError(type, msg, info);
        }
    }

    function $() {
        return Xbmc.xbmc;
    }

    function initialize() {
//        console.log("xbmc initialization");

        Xbmc.xbmc = new Xbmc.Xbmc();
        Xbmc.xbmc.port = globals.jsonPort;
        Xbmc.xbmc.server = globals.server;
//        Xbmc.xbmc.introspect();
        Xbmc.xbmc.init();

    }

    Component.onCompleted: {
        globals.load();
        if (globals.server == "Unspecified") {
            settings.source = "Settings.qml"
            settings.item.open()
            return;
        }
        xbmcEventClient.initialize(globals.server, globals.eventPort);
        xbmcTcpClient.initialize(globals.server, globals.jsonTcpPort);

        tvshowModel.relatedModel = tvshowLastplayedModel

        initialize();
    }
}
