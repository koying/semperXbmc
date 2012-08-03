// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1

ContextMenu {
    id: sortMenu
    MenuLayout {
        MenuItem {
            text:  "By First Aired"
            onClicked: {
                globals.initialTvEpisodeSort = "firstaired"
                episodeProxyModel.sortRole = globals.initialTvEpisodeSort
                episodeProxyModel.sortOrder =  globals.sortAscending ? Qt.AscendingOrder : Qt.DescendingOrder
            }
        }

        MenuItem {
            text:  "By Episode number"
            onClicked: {
                globals.initialTvEpisodeSort = "number"
                episodeProxyModel.sortRole = globals.initialTvEpisodeSort
                episodeProxyModel.sortOrder =  globals.sortAscending ? Qt.AscendingOrder : Qt.DescendingOrder
            }
        }

        MenuItem {
            text:  "By Name"
            onClicked: {
                globals.initialTvEpisodeSort = "name"
                episodeProxyModel.sortRole = globals.initialTvEpisodeSort
                episodeProxyModel.sortOrder =  Qt.AscendingOrder
            }
        }

        MenuItem {
            text:  "Default"
            onClicked: {
                globals.initialTvEpisodeSort = ""
                episodeProxyModel.sortRole = globals.initialTvEpisodeSort
                episodeProxyModel.sortOrder =  Qt.AscendingOrder
            }
        }
    }
}
