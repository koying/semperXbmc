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
                globals.initialMovieView = "MovieView.qml"
                movieStack.replace(Qt.resolvedUrl("../"+globals.initialMovieView))
            }
        }
        MenuItem {
            text:  "Recent"
            visible: viewMenu.currentType != text

            onClicked: {
                globals.initialMovieView = "MovieRecentView.qml"
                movieStack.replace(Qt.resolvedUrl("../"+globals.initialMovieView))
            }
        }
        MenuItem {
            text:  "By Genre"
            visible: viewMenu.currentType != text

            onClicked: {
                globals.initialMovieView = "MovieGenreView.qml"
                movieStack.replace(Qt.resolvedUrl("../"+globals.initialMovieView))
            }
        }
        MenuItem {
            text:  "By Sets"
            visible: viewMenu.currentType != text && $().jsonRPCVer > 2

            onClicked: {
                globals.initialMovieView = "MovieSetsView.qml"
                movieStack.replace(Qt.resolvedUrl("../"+globals.initialMovieView))
            }
        }
    }
}
