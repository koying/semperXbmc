import QtQuick 1.0
import com.nokia.symbian 1.1

import "js/Utils.js" as Utils

CommonDialog {
    id: dialog

    titleText: "REMOVE ITEM"
    buttonTexts: ["Yes", "No", "Cancel"]

    content: Text {
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        font.family: platformStyle.fontFamilyRegular
        font.pixelSize: platformStyle.fontSizeLarge
        color: platformStyle.colorNormalLight

        text: "Also remove file?"
    }

    onButtonClicked: {
        switch (index) {
        case 0: //Yes
            dialog.accept()
            break;
        case 1: // No
            dialog.reject()
            break;
        case 2: // Cancel
            dialog.close()
            break;
        }
    }
}
