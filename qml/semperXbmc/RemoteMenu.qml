import QtQuick 1.0
import com.nokia.symbian 1.0

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
            model:  remoteMenuModel
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
            id: remoteMenuModel

            ListElement { label: "Toggle subtitles"; button: "showsubtitles"; section: "Buttons" }
            ListElement { label: "Cycle subtitles"; button: "nextsubtitle"; section: "Buttons" }
            ListElement { label: "Toggle Info"; button: "info"; section: "Buttons" }
            ListElement { label: "Toggle OSD"; button: "osd"; section: "Buttons" }
            ListElement { label: "Toggle Watched"; button: "togglewatched"; section: "Buttons" }
            ListElement { label: "Toggle fullscreen"; button: "fullscreen"; section: "Buttons" }
            ListElement { label: "XBMC fullscreen"; button: "togglefullscreen"; section: "Buttons" }
//            ListElement { label: "Toggle CPU"; shortcut: "o"; section: "Buttons" }

            ListElement { label: "Favorites"; builtin: "ActivateWindow(favourites)"; section: "Shortcuts"; close: true }
            ListElement { label: "Video files"; builtin: "ActivateWindow(video)"; section: "Shortcuts"; close: true }
            ListElement { label: "Music files"; builtin: "ActivateWindow(music)"; section: "Shortcuts"; close: true }
            ListElement { label: "Programs"; builtin: "ActivateWindow(programs)"; section: "Shortcuts"; close: true }
            ListElement { label: "Addons"; builtin: "ActivateWindow(addonbrowser)"; section: "Shortcuts"; close: true }
            ListElement { label: "Settings"; builtin: "ActivateWindow(settings)"; section: "Shortcuts"; close: true }

            ListElement { label: "Play"; builtin: "PlayDVD"; section: "CD/DVD" }
            ListElement { label: "Rip"; builtin: "RipCD"; section: "CD/DVD" }
            ListElement { label: "Eject"; builtin: "EjectTray"; section: "CD/DVD" }


            ListElement { label: "Update"; builtin: "UpdateLibrary(video)"; section: "Video Library" }
            ListElement { label: "Clean"; builtin: "CleanLibrary(video)"; section: "Video Library" }
            ListElement { label: "Export"; builtin: "ExportLibrary(video)"; section: "Video Library" }

            ListElement { label: "Update"; builtin: "UpdateLibrary(music)"; section: "Music Library" }
            ListElement { label: "Clean"; builtin: "CleanLibrary(music)"; section: "Music Library" }
            ListElement { label: "Export"; builtin: "ExportLibrary(music)"; section: "Music Library" }
        }
    }
}
