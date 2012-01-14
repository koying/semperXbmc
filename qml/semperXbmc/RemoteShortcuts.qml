import QtQuick 1.0
import com.nokia.symbian 1.1

Rectangle {
    id: root
    width: 300
    height: 300
    color: "#80ffffff"

    signal close

    MouseArea {
        anchors.fill: parent
        onClicked: {
            close();
        }
    }

    Rectangle {
        id: rectangle1
        color: "#000000"
        radius: 10
        anchors.fill: parent
        anchors.margins: 50

        ListView {
            id: list
            anchors.fill: parent
            anchors.margins: 10
            model:  remoteShortcutsModel
            section.delegate: sectionHeader
            section.property:  "section"
            clip: true

            delegate: delegate
        }

        Component {
            id: delegate


            Item {
                id: wrapper
                width: list.width
                height:  40

                Rectangle {
                    anchors.fill: parent
                    gradient: Gradient {
                        id: normal
                        GradientStop {
                            position: 0
                            color: "#545454"
                        }

                        GradientStop {
                            position: 0.15
                            color: "#343434"
                        }

                        GradientStop {
                            position: 0.85
                            color: "#242424"
                        }

                        GradientStop {
                            position: 1
                            color: "#211919"
                        }
                    }
                    ListItem {
                        id: li
                        anchors.fill: parent

                        Text {
                            anchors.fill: parent
                            color: "white"
                            font.pixelSize: wrapper.height - 17
                            text: model.label
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: {
                            if (model.button)
                                xbmcEventClient.actionButton(model.button);
                            else if (model.builtin)
                                xbmcEventClient.actionBuiltin(model.builtin);
                            else if (model.shortcut)
                                xbmcEventClient.keypress(model.shortcut);

                            if (model.close)
                                root.close();
                        }
                    }
                }
            }
        }

        Component {
            id: sectionHeader

            Item {
                id: wrapper
                width: list.width
                height:  40

                Rectangle {
                    radius:  10
                    anchors.fill: parent
                    gradient: Gradient {
                        id: header

                        GradientStop {
                            position: 0
                            color: "#281b18"
                        }

                        GradientStop {
                            position: 0.15
                            color: "#503730"
                        }

                        GradientStop {
                            position: 0.85
                            color: "#382520"
                        }

                        GradientStop {
                            position: 1
                            color: "#32201b"
                        }
                    }
                    Item {
                        id: sectionHeading
                        anchors.fill: parent
                        anchors.margins: 5

                        Text {
                            anchors.fill: parent
                            color: "white"
                            font.pixelSize: wrapper.height - 17
                            text: section
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }
        }

        ListModel {
            id: remoteShortcutsModel

            ListElement { label: "Favorites"; builtin: "ActivateWindow(favourites)"; close: true }
            ListElement { label: "Settings"; builtin: "ActivateWindow(settings,return)"; close: true }
            ListElement { label: "Programs"; builtin: "ActivateWindow(programs)"; close: true }
            ListElement { label: "Addons"; builtin: "ActivateWindow(addonbrowser)"; close: true }
            ListElement { label: "By Title"; builtin: "ActivateWindow(videolibrary,MovieTitles,return)"; section: "Movies"; close: true }
            ListElement { label: "By Genre"; builtin: "ActivateWindow(videolibrary,MovieGenres,return)"; section: "Movies"; close: true }
            ListElement { label: "Recent"; builtin: "ActivateWindow(videolibrary,RecentlyAddedMovies,return)"; section: "Movies"; close: true }
            ListElement { label: "By Title"; builtin: "ActivateWindow(videolibrary,TvShowTitles,return)"; section: "TV Shows"; close: true }
            ListElement { label: "By Genre"; builtin: "ActivateWindow(videolibrary,TvShowGenres,return)"; section: "TV Shows"; close: true }
            ListElement { label: "Recent episodes "; builtin: "ActivateWindow(videolibrary,RecentlyAddedEpisodes,return)"; section: "TV Shows"; close: true }
            ListElement { label: "Artists"; builtin: "ActivateWindow(MusicLibrary,Artists,return)"; section: "Music"; close: true }
            ListElement { label: "Albums"; builtin: "ActivateWindow(MusicLibrary,Albums,return)"; section: "Music"; close: true }
            ListElement { label: "Recent Albums"; builtin: "ActivateWindow(MusicLibrary,RecentlyAddedAlbums,return)"; section: "Music"; close: true }
            ListElement { label: "Video"; builtin: "ActivateWindow(videolibrary,Plugins,return)"; section: "Plugins"; close: true }
            ListElement { label: "Music"; builtin: "ActivateWindow(MusicLibrary,Plugins,return)"; section: "Plugins"; close: true }
        }
    }
}
