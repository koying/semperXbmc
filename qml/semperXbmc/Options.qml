import QtQuick 1.0
import com.nokia.symbian 1.0

CommonDialog {
    id: dialog

    titleText: "DISPLAY OPTIONS"

    content: Flickable {
        anchors { left: parent.left; right: parent.right; top: parent.top; }
        anchors.margins: platformStyle.paddingMedium
        height: 220

        Grid {
            id: grid
            anchors.horizontalCenter: parent.horizontalCenter

            columns: 2
            spacing: platformStyle.paddingMedium

            Text {
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeLarge
                color: platformStyle.colorNormalLight
                height: swCacheThumbnails.height
                verticalAlignment: Text.AlignVCenter

                text: "Cache thumbnails"
            }

            Switch {
                id: swCacheThumbnails
            }

            Text {
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeLarge
                color: platformStyle.colorNormalLight
                height: swShowViewd.height
                verticalAlignment: Text.AlignVCenter

                text: "Show viewed items"
            }

            Switch {
                id: swShowViewd
            }

            Text {
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeLarge
                color: platformStyle.colorNormalLight
                height: swShowViewd.height
                verticalAlignment: Text.AlignVCenter

                    text: "Sort ascending (not names)"
            }

            Switch {
                id: swSortAscending
            }

            Text {
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeLarge
                color: platformStyle.colorNormalLight
                height: swShowSplash.height
                verticalAlignment: Text.AlignVCenter

                text: "Show splashscreen"
            }

            Switch {
                id: swShowSplash
            }
        }

    }

    buttons: ToolBar {
        id: buttons
        width: parent.width
        height: privateStyle.toolBarHeightLandscape + 2 * platformStyle.paddingSmall

        tools: Row {
            anchors.centerIn: parent
            spacing: platformStyle.paddingMedium

            ToolButton {
                text: "Ok"
                width: (buttons.width - 3 * platformStyle.paddingMedium) / 2
                onClicked: dialog.accept()
            }

            ToolButton {
                text: "Cancel"
                width: (buttons.width - 3 * platformStyle.paddingMedium) / 2
                onClicked: dialog.reject()
            }
        }
    }

    function setup() {
        swShowSplash.checked = globals.showSplash
        swShowViewd.checked = globals.showViewed
        swSortAscending.checked = globals.sortAscending
        swCacheThumbnails.checked = globals.cacheThumbnails
    }

    onAccepted: {
        globals.showSplash = swShowSplash.checked;
        globals.showViewed = swShowViewd.checked;
        globals.sortAscending = swSortAscending.checked;
        globals.cacheThumbnails = swCacheThumbnails.checked;

        globals.save();
    }

    Component.onCompleted: setup()
}
