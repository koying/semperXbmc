import QtQuick 1.0
import com.nokia.android 1.1
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
