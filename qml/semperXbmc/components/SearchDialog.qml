import QtQuick 1.0
import com.nokia.symbian 1.0

Rectangle {
    id: searchDlg

    property alias text: txFilter.text

    visible: btFilter.checked
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
        }
    }
}
