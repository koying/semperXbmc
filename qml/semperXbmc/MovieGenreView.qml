import Qt 4.7
import com.nokia.symbian 1.1
import "components" as Cp;
import "menus" as Menus

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
            MenuItem {
                text:  "Refresh"
                onClicked: refresh()
            }
        }
    }

    Menus.MovieViewMenu {
        id: viewMenu
        currentType: "By Genre"
    }

    Menus.MovieSortMenu {
        id: sortMenu
    }

    Menus.StyleMenu {
        id: styleMenu
    }

    ListView {
        id: videoGenreList
        anchors.fill: parent
        clip: true

        model: movieGenreProxyModel
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
            titleR: globals.showViewed ? model.unseen + "/" + model.count : model.unseen

            type: "header"
            style: "smallHorizontal"

            subComponentSource: "MovieComponent.qml"

            Connections {
                target: subComponent

                onLoaded: {
                    movieProxyModel.filterRole = "genre"
                    movieProxyModel.filterRegExp = model.name
                }
            }

            onSelected:  {
                if (style == "smallHorizontal") {
                    style = "full"
                } else {
                    style = "smallHorizontal"
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

    function refresh() {
        $().library.loadMovies();
    }

    Component.onCompleted: {
        movieProxyModel.sortRole = globals.initialMovieSort
        if (globals.initialMovieSort == "name")
            movieProxyModel.sortOrder =  Qt.AscendingOrder
        else
            movieProxyModel.sortOrder =  globals.sortAscending ? Qt.AscendingOrder : Qt.DescendingOrder

        if (movieModel.count == 0 || globals.initialMovieView.indexOf("Recent") > 0 || globals.initialMovieView.indexOf("Sets") > 0)
            $().library.loadMovies();

        globals.initialMovieView = "MovieGenreView.qml"
    }
}
