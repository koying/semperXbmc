import QtQuick 1.1
import com.nokia.android 1.1

ContextMenu {
    id: styleMenu
    MenuLayout {
        MenuItem {
            text:  "Small Horizontal"
            onClicked: {
                globals.styleMusicArtists = "smallHorizontal"
            }
        }
        MenuItem {
            text:  "Big Horizontal"
            onClicked: {
                globals.styleMusicArtists = "bigHorizontal"
            }
        }
        MenuItem {
            text:  "Vertical"
            onClicked: {
                globals.styleMusicArtists = "vertical"
            }
        }
    }
}
