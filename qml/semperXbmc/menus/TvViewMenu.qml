import QtQuick 1.1
import com.nokia.android 1.1

ContextMenu {
    id: viewMenu
    property string currentType: ""

    MenuLayout {
        MenuItem {
            text:  "All"
            visible: viewMenu.currentType != text

            onClicked: {
                tvshowStack.replace(Qt.resolvedUrl("../TvShowView.qml"))
            }
        }

        MenuItem {
            text:  "Recent episodes"
            visible: viewMenu.currentType != text

            onClicked: {
                tvshowStack.replace(Qt.resolvedUrl("../TvShowRecentView.qml"))
            }
        }

        MenuItem {
            text:  "By Genre"
            visible: viewMenu.currentType != text

            onClicked: {
                tvshowStack.replace(Qt.resolvedUrl("../TvShowGenreView.qml"))
            }
        }
    }
}
