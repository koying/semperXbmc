// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.android 1.1

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
