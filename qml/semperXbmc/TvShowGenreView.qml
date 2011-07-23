import Qt 4.7
import com.nokia.symbian 1.0
import "components" as Cp;

import "js/Utils.js" as Utils

Page {
    id: page

    tools:  pgTools

    ToolBarLayout {
        id: pgTools

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
        }
    }

    ContextMenu {
        id: viewMenu
        MenuLayout {
            MenuItem {
                text:  "All"
                onClicked: {
                    tvshowProxyModel.filterRole = ""
                    tvshowProxyModel.filterRegExp = ""
                    globals.initialTvshowView = "TvShowView.qml"
                    tvshowStack.replace(Qt.resolvedUrl(globals.initialTvshowView))
                }
            }
            MenuItem {
                text:  "By Genre"
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
//            MenuItem {
//                text:  "By Last Played"
//                onClicked: {
//                    tvshowProxyModel.sortRole = "lastplayed"
//                    tvshowProxyModel.sortOrder =  globals.sortAscending ? Qt.AscendingOrder : Qt.DescendingOrder
//                }
//            }
            MenuItem {
                text:  "By Rating"
                onClicked: {
                    tvshowProxyModel.sortRole = "rating"
                    tvshowProxyModel.sortOrder =  globals.sortAscending ? Qt.AscendingOrder : Qt.DescendingOrder
                }
            }

            MenuItem {
                text:  "By Name"
                onClicked: {
                    tvshowProxyModel.sortRole = "name"
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
                    globals.styleMovies = "smallHorizontal"
                }
            }
            MenuItem {
                text:  "Big Horizontal"
                onClicked: {
                    globals.styleMovies = "bigHorizontal"
                }
            }
            MenuItem {
                text:  "Vertical"
                onClicked: {
                    globals.styleMovies = "vertical"
                }
            }
        }
    }

    ListView {
        id: tvshowGenreList
        anchors.fill: parent
        clip: true

        model: tvshowGenreModel
        delegate: tvshowGenreDelegate
    }

    ScrollDecorator {
        id: scrolldecorator
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

    Component.onCompleted: {
        if (tvshowModel.count == 0)
            $().library.loadTVShows();
    }
}
