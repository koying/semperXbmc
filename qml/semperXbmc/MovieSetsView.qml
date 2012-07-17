import Qt 4.7
import com.nokia.symbian 1.1
import "components" as Cp;
import "menus" as Menus

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
        $().library.loadMovieSets();
    }

    Component.onCompleted: {
        movieProxyModel.filterRole = ""
        movieProxyModel.filterRegExp = ""
        movieProxyModel.sortRole = "year"
        $().library.loadMovieSets();
        globals.initialMovieView = "MovieSetsView.qml"
    }
}
