import QtQuick 1.0
import com.nokia.symbian 1.1

CommonDialog {
    id: dialog
    height: platformContentMaximumHeight

    titleText: "DISPLAY OPTIONS"
    buttonTexts: ["OK", "Cancel"]

    content: Flickable {
        anchors.fill: parent
        anchors.margins: platformStyle.paddingMedium

        contentHeight: grid.height
        boundsBehavior: Flickable.StopAtBounds

        Grid {
            id: grid
            property int lineWidth: (width - platformStyle.paddingMedium*2)

            anchors.horizontalCenter: parent.horizontalCenter
            spacing: platformStyle.paddingMedium
            columns: 2

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
                height: swShowBanners.height
                verticalAlignment: Text.AlignVCenter

                text: "Show Banners"
            }

            Switch {
                id: swShowBanners
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
                height: swShowSplash.height
                verticalAlignment: Text.AlignVCenter

                text: "Show splashscreen"
            }

            Switch {
                id: swShowSplash
            }
        }

    }

    function setup() {
        swShowSplash.checked = globals.showSplash
        swShowViewd.checked = globals.showViewed
        swSortAscending.checked = globals.sortAscending
        swCacheThumbnails.checked = globals.cacheThumbnails
        swShowBanners.checked = globals.showBanners
    }

    onAccepted: {
        globals.showSplash = swShowSplash.checked;
        globals.showViewed = swShowViewd.checked;
        globals.sortAscending = swSortAscending.checked;
        globals.cacheThumbnails = swCacheThumbnails.checked;
        globals.showBanners = swShowBanners.checked

        globals.save();
    }

    onButtonClicked: {
        switch (index) {
        case 0: //OK
            dialog.accept()
            break;
        case 1: // Cancel
            dialog.reject()
            break;
        }
    }

    Component.onCompleted: setup()
}
