import QtQuick 1.0
import com.nokia.symbian 1.0
import com.semperpax.qmlcomponents 1.0
import "components" as Cp;

import "js/Utils.js" as Utils
import "js/filter.js" as Filter

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

    ContextMenu {
        id: viewMenu
        MenuLayout {
            MenuItem {
                text:  "All"
                onClicked: {
                    movieModel.clear();
                    globals.initialMovieView = "MovieView.qml"
                    movieStack.replace(Qt.resolvedUrl(globals.initialMovieView))
                }
            }
            MenuItem {
                text:  "Recent"
            }
            MenuItem {
                text:  "By Genre"
                onClicked: {
                    movieModel.clear();
                    globals.initialMovieView = "MovieGenreView.qml"
                    movieStack.replace(Qt.resolvedUrl(globals.initialMovieView))
                }
            }
//            MenuItem {
//                text:  "Coverflow view"
//                onClicked: movieStack.push(Qt.resolvedUrl("MovieViewCover.qml"))
//            }
        }
    }

    ContextMenu {
        id: sortMenu
        MenuLayout {
            MenuItem {
                text:  "By Year"
                onClicked: {
                    globals.initialMovieSort = "year"
                    movieProxyModel.sortRole = globals.initialMovieSort
                    movieProxyModel.sortOrder =  globals.sortAscending ? Qt.AscendingOrder : Qt.DescendingOrder
                }
            }
            MenuItem {
                text:  "By Rating"
                onClicked: {
                    globals.initialMovieSort = "rating"
                    movieProxyModel.sortRole = globals.initialMovieSort
                    movieProxyModel.sortOrder =  globals.sortAscending ? Qt.AscendingOrder : Qt.DescendingOrder
                }
            }

            MenuItem {
                text:  "By Name"
                onClicked: {
                    globals.initialMovieSort = "name"
                    movieProxyModel.sortRole = globals.initialMovieSort
                    movieProxyModel.sortOrder =  Qt.AscendingOrder
                }
            }
        }
    }

    ContextMenu {
        id: styleMenu
        MenuLayout {
            MenuItem {
                text:  "Small Horizontal"
                onClicked: {
                    globals.styleMovies = "smallHorizontal"
                }
            }
            MenuItem {
                text:  "Big Horizontal"
                onClicked: {
                    globals.styleMovies = "bigHorizontal"
                }
            }
            MenuItem {
                text:  "Vertical"
                onClicked: {
                    globals.styleMovies = "vertical"
                }
            }
        }
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
    }
}
