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
        currentType: "By Sets"
    }

    Menus.MovieSortMenu {
        id: sortMenu
    }

    Menus.StyleMenu {
        id: styleMenu
    }

    ListView {
        id: videoSetsList
        anchors.fill: parent
        clip: true

        model: movieSetsProxyModel
        delegate: videoSetsDelegate
    }

    ScrollDecorator {
        id: scrolldecorator
        flickableItem: videoSetsList
    }

    Component {
        id: videoSetsDelegate

        Cp.Delegate {
            title: model.name
            image: model.poster != "" ? (globals.cacheThumbnails ? model.posterThumb : model.poster) : "qrc:/defaultImages/movie"
            watched: model.playcount > 0

            type: "header"
            style: "smallHorizontal"

            subComponentSource: "MovieComponent.qml"

            Connections {
                target: subComponent

                onLoaded: {
                    $().library.loadMovieSetMovies(model.id);
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
        $().library.loadMovieSets();
    }

    Component.onCompleted: {
        movieProxyModel.filterRole = ""
        movieProxyModel.filterRegExp = ""
        movieProxyModel.sortRole = ""
        $().library.loadMovieSets();
        globals.initialMovieView = "MovieSetsView.qml"
    }
}
