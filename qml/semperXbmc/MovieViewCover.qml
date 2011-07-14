import QtQuick 1.0
import com.nokia.symbian 1.0
import com.semperpax.qmlcomponents 1.0
import "components" as Cp;

Page {
    tools:  ToolBarLayout {

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
        MenuLayout {

            CheckBox {
                text:  "Show viewed items"
                checked: globals.showViewed
                onClicked: globals.showViewed = checked
            }

            MenuItem {
                text:  "View..."
                platformSubItemIndicator: true
                onClicked: viewMenu.open()
            }


        }
    }

    ContextMenu {
        id: viewMenu
        MenuLayout {
            MenuItem {
                text:  "List view"
                onClicked: movieStack.push(Qt.resolvedUrl("MovieView.qml"))

            }
            MenuItem {
                text:  "Coverflow view"
            }
        }
    }

    Cp.CoverFlow {
        color:  "black"
        listModel: movieModel
        anchors.fill: parent

//        onIndexChanged: {
//            myText.text = "Current index: " + index
//        }

        itemWidth: 120
        itemHeight: 240
    }
}
