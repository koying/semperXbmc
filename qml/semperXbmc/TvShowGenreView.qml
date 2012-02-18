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
        currentType: "By Genre"
    }

    Menus.TvSortMenu {
        id: sortMenu
    }

    Menus.TvStyleMenu {
        id: styleMenu
    }

    ListView {
        id: tvshowGenreList
        anchors.fill: parent
        clip: true

        model: tvshowGenreModel
        delegate: tvshowGenreDelegate
    }

    ScrollDecorator {
        flickableItem: tvshowGenreList
    }

    Component {
        id: tvshowGenreDelegate

        Cp.Delegate {
            title: model.name

            type: "header"
            style: "smallHorizontal"

            subComponentSource: "TvshowComponent.qml"

            onSelected:  {
                if (style == "smallHorizontal") {
                    style = "full"
                    tvshowProxyModel.filterRole = "genre"
                    tvshowProxyModel.filterRegExp = model.name
                } else {
                    style = "smallHorizontal"
                    tvshowProxyModel.filterRole = ""
                    tvshowProxyModel.filterRegExp = ""
                }
            }
        }
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
        if (tvshowModel.count == 0)
            $().library.loadTVShows();
        tvshowProxyModel.sortRole = globals.initialTvshowSort
        if (globals.initialTvshowSort == "name")
            tvshowProxyModel.sortOrder =  Qt.AscendingOrder
        else
            tvshowProxyModel.sortOrder =  globals.sortAscending ? Qt.AscendingOrder : Qt.DescendingOrder

        globals.initialTvshowView = "TvShowGenreView.qml"
    }
}
