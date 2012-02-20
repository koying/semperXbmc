import QtQuick 1.0
import com.nokia.symbian 1.1
import com.semperpax.qmlcomponents 1.0
import "components/" as Cp;
import "menus/" as Menus

import "js/xbmc.js" as Xbmc
import "js/json.js" as Json
import "js/Utils.js" as Utils

import "js/general.js" as General
import "js/library.js" as Library
import "js/playlist.js" as Playlist

import "js/general3.js" as General3
import "js/library3.js" as Library3
import "js/playlist3.js" as Playlist3

Window {
    id: main

    property bool jsonInitialized: false
    property real scaling: inPortrait ? main.height / 640 : main.height / 360
    property int videoPlId: -1;
    property int audioPlId: -1;
    property int picturePlId: -1;
    property int videoPlSize: -1;
    property int audioPlSize: -1;
    property int picturePlSize: -1;

    Globals {
        id: globals
    }

    Cp.ErrorView {
        id: errorView
        z: 5

       anchors.fill: parent
    }

    Text {
        id: txMsg
        anchors { top: parent.top; horizontalCenter: parent.horizontalCenter }
        text: "No JSON to " + globals.server
        font.family: "Helvetica"
        font.pixelSize: 24
        color: "white"
    }

    TabBar {
        id: tabBar
        anchors { left: parent.left; right: parent.right; top: parent.top }
        opacity: 0

        TabButton {
            iconSource: "img/home.png"
            tab: remoteTab
            onClicked: {
                main.state = ""
//                remoteTab.menu.active = true;
                remoteTab.focus = true;
            }
        }

        TabButton {
            iconSource: "img/filmstripBg.png"
            tab: movieTab
            onClicked: {
                main.state = "movies"
                if (movieStack.depth == 0) {
                    movieStack.push(Qt.resolvedUrl(globals.initialMovieView))
                }
//                movieToolbar.active = true
                movieStack.currentPage.focus = true;
            }
        }

        TabButton {
            iconSource: "img/tvBg.png"
            tab: tvTab
            onClicked: {
                main.state = "tvshows"
                if (tvshowStack.depth == 0) {
                    tvshowStack.push(Qt.resolvedUrl(globals.initialTvshowView))
                }
//                tvToolbar.active = true;
                tvshowStack.currentPage.focus = true;
            }
        }

        TabButton {
            iconSource: "img/musicBg.png"
            tab: musicTab
            onClicked: {
                main.state = "music"
                if (musicStack.depth == 0) {
                    musicStack.push(Qt.resolvedUrl(globals.initialMusicView))
                }
//                musicToolbar.active = true
                musicStack.currentPage.focus = true;
            }
        }

        TabButton {
            iconSource: "img/folderBg.png"
            tab:  fileTab
            onClicked: {
                main.state = "file"
                if (fileStack.depth == 0) {
                    fileStack.push(Qt.resolvedUrl("FileView.qml"), {curDir: "/"})
                }
//                fileToolbar.active = true
                fileStack.currentPage.focus = true;
            }
        }

        TabButton {
            iconSource: "img/playlistBg.png"
            tab: playlistTab
            onClicked: {
                if (main.state == "playlist")
                    playlistView.flipped = !playlistView.flipped
                else
                    main.state = "playlist"
            }
            //                playlistToolbar.active = true
        }

        TabButton {
            iconSource: "img/download.png"
            tab: downloadTab
            visible: (downloadTab.count > 0)
            onClicked: {
                main.state = "download"
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
                    target: tabBar
                    opacity: 1
                }
                PropertyChanges {
                    target: txMsg
                    opacity: 0
                }
            }
        ]
    }

    TabGroup {
        id: mainTabGroup
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: tabBar.bottom
        anchors.bottom: parent.bottom


        RemoteView {
            id: remoteTab
            property string title: "REMOTE"
        }

        Item {
            id: movieTab
            property string title: "MOVIES"

            PageStack {
                id: movieStack

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
            property string title: "TV"

            PageStack {
                id: tvshowStack

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
            property string title: "MUSIC"

            PageStack {
                id: musicStack

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
            id: fileTab
            property string title: "FILES"

            PageStack {
                id: fileStack

                anchors { top: parent.top; left: parent.left; right: parent.right; bottom: fileToolbar.top }
                toolBar: fileToolbar

            }

            ToolBar {
                id: fileToolbar
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
            property alias view: playlistView

            PlayListView {
                id: playlistView
                property string title: "PLAYLIST"
                anchors { top: parent.top; left: parent.left; right: parent.right; bottom: playlistToolbar.top }
            }

            Menus.MainTools {
                id: mainTools
            }

            ToolBar {
                id: playlistToolbar
                tools: mainTools.layout
                anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
            }
        }

        DownloadView {
            id: downloadTab
            property string title: "DOWNLOADS"
        }
    }


    Loader {
        id: dialogPlaceholder
    }

    Connections {
        id: dialogPlaceholderConnections
        target: dialogPlaceholder.item

        onAccepted: {
            dialogPlaceholder.source = ""
        }

        onRejected: {
            dialogPlaceholder.source = ""
        }
    }

    Cp.AutoDestructLoader {
        id: splash;
        anchors.fill: parent
        z:5
        duration: 5000

        MouseArea {
            anchors.fill: parent
            onClicked: splash.sourceUrl = ""
        }
    }

    /* Globale Models */
    SortFilterModel {
        id: artistProxyModel

        sourceModel: artistModel
    }
    VariantModel {
        id: artistSuppModel
        fields: [ "id", "url" ]
        key: "id"

        stream: ctxFatFile + "/artistSuppModel.dat"

        Component.onCompleted: load()
        Component.onDestruction: save()
    }
    VariantModel {
        id: artistModel
        fields: [ "id", "name", "poster", "selected", "posterThumb" ]
        thumbDir: ctxFatFile
    }

    SortFilterModel {
        id: albumProxyModel

        sourceModel: albumModel
    }
    VariantModel {
        id: albumSuppModel
        fields: [ "id", "url" ]
        key: "id"

        stream: ctxFatFile + "/albumSuppModel.dat"

        Component.onCompleted: load()
        Component.onDestruction: save()
    }
    VariantModel {
        id: albumModel
        fields: [ "idalbum", "name", "artist", "genre", "rating", "cover", "coverThumb" ]
        thumbDir: ctxFatFile
    }
    ListModel {
        id: trackModel
    }

    SortFilterModel {
        id: movieGenreProxyModel

        sourceModel: movieGenreModel
        boolFilterRole: globals.showViewed ? "" : "playcount"
    }

    VariantModel {
        id: movieGenreModel
        fields: [ "name", "count", "unseen", "playcount" ]
        key: "name"
    }

    SortFilterModel {
        id: movieSetsProxyModel

        sourceModel: movieSetsModel
        boolFilterRole: globals.showViewed ? "" : "playcount"
    }
    VariantModel {
        id: movieSetsModel
        fields: [ "id", "name", "playcount", "poster", "posterThumb" ]
        thumbDir: ctxFatFile
    }

    SortFilterModel {
        id: movieProxyModel

        sourceModel: movieModel
        boolFilterRole: globals.showViewed ? "" : "playcount"
    }
    VariantModel {
        id: movieSuppModel
        fields: [ "id", "url" ]
        key: "id"

        stream: ctxFatFile + "/movieSuppModel.dat"

        Component.onCompleted: load()
        Component.onDestruction: save()
    }
    VariantModel {
        id: movieModel
        fields: [ "id", "name", "poster", "genre", "duration", "runtime", "rating", "year", "playcount", "imdbnumber", "originaltitle", "posterThumb", "resume" ]
        thumbDir: ctxFatFile
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
        id: tvshowSuppModel
        fields: [ "showtitle", "lastplayed", "url" ]
        key: "showtitle"

        stream: ctxFatFile + "/tvshowLastplayedModel.dat"

        Component.onCompleted: load()
        Component.onDestruction: save()
    }

    VariantModel {
        id: tvshowModel
        fields: [ "id", "name", "poster", "genre", "duration", "rating", "playcount", "imdbnumber", "originaltitle", "posterThumb", "lastplayed" ]
        key: "name"
        relatedFields: [ "lastplayed" ]
        thumbDir: ctxFatFile
    }

    SortFilterModel {
        id: seasonProxyModel

        sourceModel: seasonModel
        boolFilterRole: globals.showViewed ? "" : "playcount"
    }
    VariantModel {
        id: seasonModel
        fields: [ "id", "name", "showtitle", "poster", "episodes", "genre", "duration", "rating", "playcount" ]
        thumbDir: ctxFatFile
    }

    SortFilterModel {
        id: episodeProxyModel

        sourceModel: episodeModel
        boolFilterRole: globals.showViewed ? "" : "playcount"
    }
    VariantModel {
        id: episodeModel
        fields: [ "id", "name", "poster", "tvshowId", "showtitle", "season", "number", "duration", "rating", "playcount", "resume" ]
        thumbDir: ctxFatFile
    }

    ListModel {
        id: downloadsModel
    }

    Timer {
        id: jsonRetryTimer
        interval: 2000

        onTriggered: {
            Xbmc.xbmc.init();
        }
    }

    Timer {
        id: utilTimer
        interval: 2000; running: false; repeat: true
        onTriggered: {
            $().playlist.getPlaylists()
        }
    }

    XbmcEventClient {
        id: xbmcEventClient

        onErrorDetected: {
            errorView.addError(type, msg, info);
        }
    }

    Notifications {
        id: xbmcTcpClient
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

    onJsonInitializedChanged: {
        if (jsonInitialized)
            utilTimer.running = true
    }

    Component.onCompleted: {
        globals.load();
//        remoteTab.menu.active = true;

        if (globals.showSplash)
            splash.sourceUrl = Qt.resolvedUrl("Splash.qml")

        if (globals.server == "Unspecified") {
            dialogPlaceholder.source = "Settings.qml"
            dialogPlaceholder.item.accepted.connect(
                        function () {
                            xbmcEventClient.initialize(globals.server, globals.eventPort);
                            main.initialize();
                        }
                        );
            dialogPlaceholder.item.open()
            return;
        }
        xbmcEventClient.initialize(globals.server, globals.eventPort);

        tvshowModel.relatedModel = tvshowSuppModel

        initialize();
    }
}
