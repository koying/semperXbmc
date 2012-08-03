// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1

ContextMenu {
    id: sortMenu
    MenuLayout {
        MenuItem {
            text:  "By Year"
            onClicked: {
                globals.initialMovieSort = "year"
                movieProxyModel.sortRole = globals.initialMovieSort
                movieProxyModel.sortOrder =  globals.sortAscending ? Qt.AscendingOrder : Qt.DescendingOrder
            }
        }
        MenuItem {
            text:  "By Rating"
            onClicked: {
                globals.initialMovieSort = "rating"
                movieProxyModel.sortRole = globals.initialMovieSort
                movieProxyModel.sortOrder =  globals.sortAscending ? Qt.AscendingOrder : Qt.DescendingOrder
            }
        }

        MenuItem {
            text:  "By Name"
            onClicked: {
                globals.initialMovieSort = "name"
                movieProxyModel.sortRole = globals.initialMovieSort
                movieProxyModel.sortOrder =  Qt.AscendingOrder
            }
        }

        MenuItem {
            text:  "Default"
            onClicked: {
                globals.initialMovieSort = ""
                movieProxyModel.sortRole = globals.initialMovieSort
            }
        }
    }
}
