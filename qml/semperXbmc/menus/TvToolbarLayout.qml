import QtQuick 1.0
import com.nokia.android 1.1

ToolBarLayout {
    id: layout
    property bool filterEnabled: false

    //        ToolButton {
    //            iconSource: "toolbar-back"
    //            onClicked: tvshowStack.pop()
    //            visible: tvshowStack.depth > 1
    //        }

    ToolButton {
        id: btFilter
        text: "Filter"
        checkable: true
        iconSource: "../img/filter.svg"
        onClicked: {
            console.debug("filter clicked")
            layout.filterEnabled = !layout.filterEnabled
        }
    }

    ToolButton {
        text:  "View"
        iconSource: "../img/switch_windows.svg"
        menu: viewMenu
    }

    ToolButton {
        text:  "Sort"
        iconSource: "../img/shuffle.svg"
        menu: sortMenu
    }

    ToolButton {
        text:  "Style"
        iconSource: "../img/template.svg"
        menu: styleMenu
    }

    ToolButton {
        text:  "Refresh"
        iconSource: "../img/refresh.svg"
        onClicked: refresh()
    }

    MainTools {}

    //        ToolButton {
    //            iconSource: "toolbar-menu"
    //            onClicked: pgMenu.open()
    //        }
}
