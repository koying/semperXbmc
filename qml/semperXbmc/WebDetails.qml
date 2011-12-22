import QtQuick 1.0
import com.semperpax.qmlcomponents 1.0
import com.nokia.symbian 1.0

import "js/Utils.js" as Utils

Item {
    id: wrapper

    anchors.fill: parent

    property url url
    property url bookmark:  ""
    property alias tools: webTools

    onUrlChanged: { webView.url = url }

    ToolBarLayout {
        id: webTools

        ToolButton {
            iconSource: "toolbar-back"
            onClicked: webView.back.trigger();
        }

        ToolButton {
            iconSource: (webView.progress != 0 && webView.progress != 100) ? "toolbar-mediacontrol-stop" : "toolbar-refresh"
            onClicked: (webView.progress != 0 && webView.progress != 100) ? webView.stop.trigger() : webView.reload.trigger()
        }

        ToolButton {
            iconSource: "toolbar-home"
            onClicked: webView.url = wrapper.url
        }
        ToolButton {
            iconSource: "toolbar-search"
            onClicked: webView.url = "http://www.google.com/m"
        }

        ToolButton {
            iconSource: "toolbar-menu"
            onClicked: webMenu.open()
        }
    }

    Menu {
        id: webMenu
        content: MenuLayout {

            MenuItem {
                text:  "Set Bookmark"
                onClicked: bookmark = webView.url
                visible:  bookmark == ""
            }

            MenuItem {
                text:  "Clear Bookmark"
                onClicked: bookmark = ""
                visible:  bookmark != ""
            }
        }
    }

    BrowserView {
        id: webView
        anchors.fill: parent
        focus: true

        ProgressBar {
            id: pb1
            anchors { top: parent.top; left: parent.left; right: parent.right; }
            anchors.margins: 5
            z:5

            minimumValue: 0
            maximumValue: 100
            value: webView.progress

            opacity: (value == 0 || value == 100) ? 0 : 0.50

            Behavior on opacity {
                NumberAnimation { duration: 300 }
            }
        }
    }
}
