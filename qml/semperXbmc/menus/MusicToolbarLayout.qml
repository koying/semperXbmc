import QtQuick 1.0
import com.nokia.symbian 1.1

ToolBarLayout {
    id: layout
    property bool filterEnabled: false

    ToolButton {
        iconSource: "toolbar-back"
        onClicked: musicStack.pop()
        visible: musicStack.depth > 1
    }

    ToolButton {
        id: btFilter
//        text: "Filter"
        checkable: true
        iconSource: "../img/filter.svg"
        onClicked: {
            console.debug("filter clicked")
            layout.filterEnabled = !layout.filterEnabled
        }
    }

    ToolButton {
//        text:  "View"
        iconSource: "../img/switch_windows.svg"
        onClicked: viewMenu.open()
//        menu: viewMenu
    }

//    ToolButton {
//        text:  "Sort"
//        iconSource: "../img/shuffle.svg"
//        menu: sortMenu
//    }

    ToolButton {
//        text:  "Style"
        iconSource: "../img/template.svg"
        onClicked: styleMenu.open()
//        menu: styleMenu
    }

    ToolButton {
//        text:  "Refresh"
        iconSource: "../img/refresh.svg"
        onClicked: refresh()
    }

    ToolButton {
        MainTools {
            id: mainTools
        }

        iconSource: "toolbar-menu"
        onClicked: mainTools.menu.open()
    }
}
