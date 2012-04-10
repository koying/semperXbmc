import QtQuick 1.0
import com.nokia.symbian 1.1
import com.semperpax.qmlcomponents 1.0
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
        currentType: "Trakt Watchlist"
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
        $trakt().loadMoviesWatchlist();
    }

    Component.onCompleted: {
        movieModel.clear();
        movieProxyModel.sortRole = globals.initialMovieSort
        if (globals.initialMovieSort == "name")
            movieProxyModel.sortOrder =  Qt.AscendingOrder
        else
            movieProxyModel.sortOrder =  globals.sortAscending ? Qt.AscendingOrder : Qt.DescendingOrder

        $trakt().loadMoviesWatchlist();

        globals.initialMovieView = "MovieTraktWatchlistView.qml"
    }
}
