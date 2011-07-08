import Qt 4.7
import com.nokia.symbian 1.0

import "js/Utils.js" as Utils

Page {
    width: root.width
    height: root.height

    tools: pgTools

    ToolBarLayout {
        id: pgTools

        ToolButton {
            visible: false
        }

        ButtonRow {
            TabButton {
                visible: false
            }

            TabButton {
                iconSource: "img/filmstrip.png"
                tab: movieView
                onClicked: main.state = "movies"
            }

            TabButton {
                iconSource: "img/tv.png"
                tab: tvshowView
                onClicked: main.state = "tvshows"
            }

            TabButton {
                iconSource: "img/music.png"
                onClicked: main.state = "music"
            }

            TabButton {
                iconSource: "img/playlist.png"
                onClicked: main.state = "playlist"
            }
        }

        ToolButton {
            iconSource: "toolbar-menu"
            onClicked: pgMenu.open()
        }
    }

    Menu {
        id: pgMenu
        content: MenuLayout {
            MenuItem {
                text: "Quit"
                onClicked: Qt.quit()
            }
        }
    }

    Row {
        id: container
        Item {
            id: tvshow
            height: root.height
            width: root.width
            ListView {
                id: tvshowView
                z: 1
                width: parent.width
                height: parent.height
                model: tvshowModel
                delegate: tvshowDelegate
            }
        }
        Item {
            id: season
            height: root.height
            width: root.width
            ListView {
                id: seasonView
                z: 1
                width: parent.width
                height: parent.height
                model: seasonModel
                delegate: seasonDelegate
            }
        }

        Item {
            id: episode
            height: root.height
            width: root.width
            ListView {
                id: episodeView
                z: 1
                width: parent.width
                height: parent.height
                model: episodeModel
                delegate: episodeDelegate
            }
        }

        states: [
            State {
                name: "season"
                PropertyChanges {
                    target: container
                    x: -root.width;
                }
            },
            State {
                name: "episode"
                PropertyChanges {
                    target: container
                    x: 2 * -root.width;
                }
            }
        ]
        transitions: Transition {
            PropertyAnimation {
                properties: "x";
                easing.type: Easing.InOutCubic
                duration: 500
            }
        }
    }


    Component {
        id: tvshowDelegate

        FRow {
            id: content
            text: name
            subtitle: genre /*+ "\n" + rating*/
            source: thumb
            selected: selected
            portrait: true
            watched: playcount > 0
            function clicked(id) {
//                console.log("show clicked" + id);
                seasonModel.clear();
                $().library.loadSeasons(id);
                container.state = "season";
            }
        }
    }

    Component {
        id: seasonDelegate

        FRow {
            id: content
            text: name
            subtitle: episodes + " episodes"
            source: thumb
            selected: selected
            portrait: true
            watched: playcount > 0
            function clicked(id) {
//                console.log("season clicked" + id);
                episodeModel.clear();
                $().library.loadEpisodes(id);
                container.state = "episode";
            }
        }
    }

    Component {
        id: episodeDelegate

        FRow {
            id: content
            text: (number > 0 ? number + ". " : "") + name
            subtitle: Utils.secToMinutes(duration)
            source: thumb
            selected: selected
            portrait: true
            watched: playcount > 0
            function clicked(id) {
//                console.log("episode clicked" + id);
                $().playlist.videoClear();
                $().playlist.addEpisode(id);
                main.state = ""
            }
        }
    }



    function back() {
        if (container.state == "season") {
            container.state = "";
            return false;
        }
        if (container.state == "episode") {
            container.state = "season";
            return false;
        }
        return true;
    }
}
