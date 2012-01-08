// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1

ContextMenu {
    id: viewMenu
    property string currentType: ""

    MenuLayout {
        MenuItem {
            text:  "All"
            visible: viewMenu.currentType != text

            onClicked: {
                movieStack.replace(Qt.resolvedUrl("../MovieView.qml"))
            }
        }
        MenuItem {
            text:  "Recent"
            visible: viewMenu.currentType != text

            onClicked: {
                movieStack.replace(Qt.resolvedUrl("../MovieRecentView.qml"))
            }
        }
        MenuItem {
            text:  "By Genre"
            visible: viewMenu.currentType != text

            onClicked: {
                movieStack.replace(Qt.resolvedUrl("../MovieGenreView.qml"))
            }
        }
        MenuItem {
            text:  "By Sets"
            visible: viewMenu.currentType != text && $().jsonRPCVer > 2

            onClicked: {
                movieStack.replace(Qt.resolvedUrl("../MovieSetsView.qml"))
            }
        }
    }
}
