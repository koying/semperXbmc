import QtQuick 1.1
import com.nokia.android 1.1

ContextMenu {
    id: viewMenu
    property string currentType: ""

    MenuLayout {
        MenuItem {
            text:  "Artists"
            visible: viewMenu.currentType != text

            onClicked: {
                musicStack.replace(Qt.resolvedUrl("../MusicArtistView.qml"))
            }
        }

        MenuItem {
            text:  "Recent Albums"
            visible: viewMenu.currentType != text

            onClicked: {
                musicStack.replace(Qt.resolvedUrl("../MusicRecentAlbumView.qml"))
            }
        }
        MenuItem {
            text:  "All Albums"
            visible: viewMenu.currentType != text

            onClicked: {
                musicStack.replace(Qt.resolvedUrl("../MusicAlbumView.qml"))
            }
        }
    }
}
