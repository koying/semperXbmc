import QtQuick 1.0
import com.semperpax.qmlcomponents 1.0
import com.nokia.symbian 1.0

import "js/Utils.js" as Utils

Item {
    id: wrapper

    anchors.fill: parent

    property url url
    signal urlModified

    onUrlChanged: { webView.url = url }

    ToolBar {
        id: buttons
        anchors { top: parent.top; left: parent.left; right: parent.right; }

        tools: Row {
            anchors.centerIn: parent
            spacing: platformStyle.paddingMedium

            ToolButton {
                iconSource: "toolbar-back"
                onClicked: webView.back.trigger();
            }

            ToolButton {
                iconSource: "toolbar-home"
                onClicked: webView.url = wrapper.url
                onPlatformPressAndHold: {
                    url = webView.url
                    urlModified();
                }
            }
            ToolButton {
                iconSource: "toolbar-search"
                onClicked: webView.url = "http://m.google.com/?q=" + model.originaltitle.replace(" ", "+")
            }
        }
    }

    BrowserView {
        id: webView
        anchors { top: buttons.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }

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
