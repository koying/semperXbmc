// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1

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
