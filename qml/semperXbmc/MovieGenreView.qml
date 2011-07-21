import Qt 4.7
import com.nokia.symbian 1.0
import "components" as Cp;

import "js/Utils.js" as Utils

Page {
    id: page

    tools:  pgTools

    ToolBarLayout {
        id: pgTools

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

            MenuItem {
                text:  "Sort"
                platformSubItemIndicator: true
                onClicked: sortMenu.open()
            }

            MenuItem {
                text:  "Style"
                platformSubItemIndicator: true
                onClicked: styleMenu.open()
            }
        }
    }

    ContextMenu {
        id: viewMenu
        MenuLayout {
            MenuItem {
                text:  "All"
                onClicked: {
                    globals.initialMovieView = "MovieView.qml"
                    movieStack.replace(Qt.resolvedUrl(globals.initialMovieView))
                }
            }
            MenuItem {
                text:  "By Genre"
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
                    movieProxyModel.sortRole = "year"
                    movieProxyModel.sortOrder =  globals.sortAscending ? Qt.AscendingOrder : Qt.DescendingOrder
                }
            }
            MenuItem {
                text:  "By Rating"
                onClicked: {
                    movieProxyModel.sortRole = "rating"
                    movieProxyModel.sortOrder =  globals.sortAscending ? Qt.AscendingOrder : Qt.DescendingOrder
                }
            }

            MenuItem {
                text:  "By Name"
                onClicked: {
                    movieProxyModel.sortRole = "name"
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

    ListView {
        id: videoGenreList
        anchors.fill: parent
        clip: true

        model: videoGenreModel
        delegate: videoGenreDelegate
    }

    ScrollDecorator {
        id: scrolldecorator
        flickableItem: videoGenreList
    }

    Component {
        id: videoGenreDelegate

        Cp.Delegate {
            title: model.name

            type: "header"
            style: "smallHorizontal"

            subComponentSource: "MovieComponent.qml"

            onSelected:  {
                if (style == "smallHorizontal") {
                    style = "full"
                    movieProxyModel.filterRole = "genre"
                    movieProxyModel.filterRegExp = model.name
                } else {
                    style = "smallHorizontal"
                    movieProxyModel.filterRole = ""
                    movieProxyModel.filterRegExp = ""
                }
            }
        }
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

    Component.onCompleted: {
        if (movieModel.count == 0)
            $().library.loadMovies();
    }
}
