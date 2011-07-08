import Qt 4.7
import com.nokia.symbian 1.0

import "js/Utils.js" as Utils

Page {
    tools:  pgTools

    ToolBarLayout {
        id: pgTools

        ToolButton {
            visible: false
        }

        ButtonRow {
            TabButton {
                iconSource: "img/home.png"
                tab: remoteView
                onClicked: main.state = ""
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

    ListView {
        id: movieView
        anchors.fill: parent
        clip: true

        model: movieModel
        delegate: movieDelegate
    }

    Component {
        id: movieDelegate

        FRow {
            id: content
            text: name
            subtitle: genre + "\n" + (duration > 0 ? Utils.secToHours(duration) : runtime)
            source: thumb
            selected: selected
            portrait: true
            watched: playcount > 0
            function clicked(id) {
                $().playlist.videoClear();
                $().playlist.addMovie(id);
                main.state = ""
            }
        }
    }
}
