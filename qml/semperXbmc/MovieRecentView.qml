import QtQuick 1.0
import com.nokia.symbian 1.1
import com.semperpax.qmlcomponents 1.0
import "components" as Cp;
import "menus" as Menus

import "js/Utils.js" as Utils

Page {
    id: page
    tools:  ToolBarLayout {

        ToolButton {
            iconSource: "toolbar-back"
            onClicked: movieStack.pop()
            visible: movieStack.depth > 1
        }

        ToolButton {
            id: btFilter
            checkable: true
            iconSource: "img/filter.svg"
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
                text:  "View"
                platformSubItemIndicator: true
                onClicked: viewMenu.open()
            }

//            MenuItem {
//                text:  "Sort"
//                platformSubItemIndicator: true
//                onClicked: sortMenu.open()
//            }

            MenuItem {
                text:  "Style"
                platformSubItemIndicator: true
                onClicked: styleMenu.open()
            }
            MenuItem {
                text:  "Refresh"
                onClicked: refresh()
            }
        }
    }

    Menus.MovieViewMenu {
        id: viewMenu
        currentType: "Recent"
    }

    Menus.MovieSortMenu {
        id: sortMenu
    }

    Menus.StyleMenu {
        id: styleMenu
    }

    MovieComponent {
        anchors.fill: parent
    }

    Cp.SearchDialog {
        id: searchDlg
        visible: btFilter.checked

        onApply: {
            movieProxyModel.filterRole = "name"
            movieProxyModel.filterRegExp = searchDlg.text
        }
        onCancel: {
            movieProxyModel.filterRole = ""
            movieProxyModel.filterRegExp = ""
        }
    }

    function refresh() {
        $().library.recentMovies();
    }

    Component.onCompleted: {
        movieProxyModel.filterRole = ""
        movieProxyModel.filterRegExp = ""
        movieProxyModel.sortRole = ""
        $().library.recentMovies();
        globals.initialMovieView = "MovieRecentView.qml"
    }
}
