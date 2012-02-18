import Qt 4.7
import com.nokia.android 1.1
import "components/" as Cp;
import "menus/" as Menus

import "js/Utils.js" as Utils

Page {
    id: page
    focus: true

    tools:  menuLayout

    Menus.MovieToolbarLayout {
        id: menuLayout
    }

    Keys.onBackPressed: {
        movieStack.pop()
        event.accepted = true
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
        visible: menuLayout.filterEnabled

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
