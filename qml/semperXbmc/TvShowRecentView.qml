import Qt 4.7
import com.nokia.symbian 1.1
import "components/" as Cp;
import "menus/" as Menus

import "js/Utils.js" as Utils

Page {
    id: page
    focus: true

    tools:  menuLayout

    Menus.TvToolbarLayout {
        id: menuLayout
    }

    Keys.onBackPressed: {
        tvshowStack.pop()
        event.accepted = true
    }

    Menus.TvViewMenu {
        id: viewMenu
        currentType: "Recent episodes"
    }

    Menus.TvEpisodeSortMenu {
        id: sortMenu
    }

    Menus.TvSeasonStyleMenu {
        id: styleMenu
    }

    TvEpisodeComponent {
        anchors.fill: parent
    }

    Cp.SearchDialog {
        id: searchDlg
        visible: menuLayout.filterEnabled

        onApply: {
            episodeProxyModel.filterRole = "name"
            episodeProxyModel.filterRegExp = searchDlg.text
        }
        onCancel: {
            episodeProxyModel.filterRole = ""
            episodeProxyModel.filterRegExp = ""
        }
    }

    function refresh() {
        $().library.recentEpisodes();
    }

    Component.onCompleted: {
        episodeProxyModel.filterRole = ""
        episodeProxyModel.filterRegExp = ""
        episodeProxyModel.sortRole = ""
        $().library.recentEpisodes();

        globals.initialTvshowView = "TvShowRecentView.qml"
    }

}
