import Qt 4.7
import com.nokia.symbian 1.0
import "components" as Cp;

import "js/Utils.js" as Utils

Page {
    id: page
    tools:  ToolBarLayout {

        ToolButton {
            iconSource: "toolbar-back"
            onClicked: tvshowStack.pop()
            visible: tvshowStack.depth > 1
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

    ContextMenu {
        id: viewMenu
        MenuLayout {
            MenuItem {
                text:  "All"
                onClicked: {
                    tvshowProxyModel.clear();
                    globals.initialTvshowView = "TvShowView.qml"
                    tvshowStack.replace(Qt.resolvedUrl(globals.initialTvshowView))
                }
            }
            MenuItem {
                text:  "Recent episodes"
            }
            MenuItem {
                text:  "By Genre"
                onClicked: {
                    tvshowProxyModel.clear();
                    globals.initialTvshowView = "TvShowGenreView.qml"
                    tvshowStack.replace(Qt.resolvedUrl(globals.initialTvshowView))
                }
            }
//            MenuItem {
//                text:  "Coverflow view"
//                onClicked: movieStack.push(Qt.resolvedUrl("MovieViewCover.qml"))
//            }
        }
    }

    ContextMenu {
        id: sortMenu
        MenuLayout {
            MenuItem {
                text:  "By Last Played"
                onClicked: {
                    globals.initialTvshowSort = "lastplayed"
                    tvshowProxyModel.sortRole = globals.initialTvshowSort
                    tvshowProxyModel.sortOrder =  globals.sortAscending ? Qt.AscendingOrder : Qt.DescendingOrder
                }
            }

            MenuItem {
                text:  "By Rating"
                onClicked: {
                    globals.initialTvshowSort = "rating"
                    tvshowProxyModel.sortRole = globals.initialTvshowSort
                    tvshowProxyModel.sortOrder =  globals.sortAscending ? Qt.AscendingOrder : Qt.DescendingOrder
                }
            }

            MenuItem {
                text:  "By Name"
                onClicked: {
                    globals.initialTvshowSort = "name"
                    tvshowProxyModel.sortRole = globals.initialTvshowSort
                    tvshowProxyModel.sortOrder =  Qt.AscendingOrder
                }
            }
        }
    }

    ContextMenu {
        id: styleMenu
        MenuLayout {
            MenuItem {
                text:  "Small Horizontal"
                onClicked: {
                    globals.styleTvShows = "smallHorizontal"
                }
            }
            MenuItem {
                text:  "Big Horizontal"
                onClicked: {
                    globals.styleTvShows = "bigHorizontal"
                }
            }
            MenuItem {
                text:  "Vertical"
                onClicked: {
                    globals.styleTvShows = "vertical"
                }
            }
        }
    }

    TvEpisodeComponent {
        anchors.fill: parent
    }

    Cp.SearchDialog {
        id: searchDlg
        visible: btFilter.checked

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
    }

}