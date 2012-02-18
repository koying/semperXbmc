import QtQuick 1.0
import com.nokia.symbian 1.1

Rectangle {
    id: searchDlg

    property alias text: txFilter.text

    signal apply
    signal cancel

    visible: menuLayout.filterEnabled
    gradient: Gradient {
        GradientStop { position: 0.0; color: "#333" }
        GradientStop { position: 1.0; color: "#000" }
    }

    anchors {right: parent.right; left: parent.left; bottom: parent.bottom }
    height: platformStyle.graphicSizeMedium

    Row {
        TextField {
            id: txFilter
            height: searchDlg.height - platformStyle.paddingMedium
            width: searchDlg.width - platformStyle.paddingMedium
            placeholderText: "Filter..."

            Image {
                id: applyText
                property bool applied:  false

                anchors { top: parent.top; right: parent.right; margins: platformStyle.paddingMedium }
                fillMode: Image.PreserveAspectFit
                smooth: true; visible: txFilter.text
                source: "img/checkmark_24.png"
                height: parent.height - platformStyle.paddingMedium * 2
                width: parent.height - platformStyle.paddingMedium * 2

                MouseArea {
                    id: apply
                    anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
                    height: txFilter.height; width: txFilter.height
                    onClicked: {
                        if (!applyText.applied) {
                            searchDlg.apply();
                            applyText.applied = true
                            applyText.source = "img/stop_24.png"
                        } else {
                            searchDlg.cancel()
                            applyText.applied = false
                            applyText.source = "img/checkmark_24.png"
                            txFilter.text = ""
                        }
                    }
                }
            }
        }
    }

    Connections {
        target: menuLayout
        onFilterEnabledChanged: {
            if (!menuLayout.filterEnabled) {
                searchDlg.cancel()
                applyText.applied = false
                applyText.source = "img/checkmark_24.png"
            }
        }
    }
}
