import QtQuick 1.1
import com.nokia.symbian 1.1

Item {
    property alias menu: pgMenu
    property alias layout: layout

    ContextMenu {
        id: settingMenu
        MenuLayout {

            MenuItem {
                text:  "Display options"
                onClicked: {
                    dialogPlaceholder.source = "../Options.qml"
                    dialogPlaceholder.item.open()
                }
            }

            MenuItem {
                text:  "Connection settings"
                onClicked: {
                    dialogPlaceholder.source = "../Settings.qml"
                    dialogPlaceholder.item.accepted.connect(
                                function () {
                                    xbmcEventClient.initialize(globals.server, globals.eventPort);
                                    main.initialize();
                                }
                                );
                    dialogPlaceholder.item.open()
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

    ContextMenu {
        id: pgMenu

        MenuLayout {
            MenuItem {
                text:  "Display options"
                onClicked: {
                    dialogPlaceholder.source = "../Options.qml"
                    dialogPlaceholder.item.open()
                }
            }

            MenuItem {
                text:  "Connection settings"
                onClicked: {
                    dialogPlaceholder.source = "../Settings.qml"
                    dialogPlaceholder.item.accepted.connect(
                                function () {
                                    xbmcEventClient.initialize(globals.server, globals.eventPort);
                                    main.initialize();
                                }
                                );
                    dialogPlaceholder.item.open()
                }
            }

            MenuItem {
                text: "Exit"
                onClicked: mainMenu.open()
            }
        }
    }

    ToolBarLayout {
        id: layout

        ToolButton {
            //        text: "Settings"
            iconSource: "../img/settings.svg"
            onClicked: settingMenu.open()
            //        menu: settingMenu
        }

        ToolButton {
            //        text: "Exit"
            iconSource: "../img/close_stop.svg"
            onClicked: mainMenu.open()
            //        menu: mainMenu
        }
    }
}
