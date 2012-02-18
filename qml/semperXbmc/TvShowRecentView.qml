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

    Menus.TvSortMenu {
        id: sortMenu
    }

    Menus.TvStyleMenu {
        id: styleMenu
    }

    TvEpisodeComponent {
        anchors.fill: parent
    }

    Cp.SearchDialog {
        id: searchDlg
        visible: menuLayout.filterEnabled

        onApply: {
            tvshowProxyModel.filterRole = "name"
            tvshowProxyModel.filterRegExp = searchDlg.text
        }
        onCancel: {
            tvshowProxyModel.filterRole = ""
            tvshowProxyModel.filterRegExp = ""
        }
    }

    function refresh() {
        $().library.recentEpisodes();
    }

    Component.onCompleted: {
        tvshowProxyModel.filterRole = ""
        tvshowProxyModel.filterRegExp = ""
        tvshowProxyModel.sortRole = ""
        $().library.recentEpisodes();

        globals.initialTvshowView = "TvShowRecentView.qml"
    }

}
