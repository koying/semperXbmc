import QtQuick 1.0
import com.nokia.symbian 1.0

import "js/Utils.js" as Utils

QueryDialog {
    property int position
    property int total

    anchors.centerIn: parent

    titleText: "BOOKMARK FOUND"
    message: "Resume at " + (position/total*100).toFixed(0) + "%?"
    acceptButtonText: "Yes"
    rejectButtonText: "No"
}
