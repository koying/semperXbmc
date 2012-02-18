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
        currentType: "All"
    }

    Menus.TvSortMenu {
        id: sortMenu
    }

    Menus.TvStyleMenu {
        id: styleMenu
    }

    TvshowComponent {
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
        $().library.loadTVShows();
    }

    Component.onCompleted: {
        tvshowProxyModel.sortRole = globals.initialTvshowSort
        if (globals.initialTvshowSort == "name")
            tvshowProxyModel.sortOrder =  Qt.AscendingOrder
        else
            tvshowProxyModel.sortOrder =  globals.sortAscending ? Qt.AscendingOrder : Qt.DescendingOrder
        if (tvshowModel.count == 0)
            $().library.loadTVShows();

        globals.initialTvshowView = "TvShowView.qml"
    }

}
