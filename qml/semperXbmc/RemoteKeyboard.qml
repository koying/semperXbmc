import QtQuick 1.0
import com.nokia.symbian 1.1

CommonDialog {
    id: dialog

    property alias value: txLine.text

    titleText: "KEYBOARD INPUT"
    buttonTexts: ["OK", "Cancel"]

    content:
    TextField {
        id: txLine
        width: parent.width
    }

    onAccepted: {
        var doc = new globals.getJsonXMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.DONE) {
                console.debug(doc.responseText)
            }
        }

        var o = { jsonrpc: "2.0", method: "Input.SendText", params: { text: txLine.text, done: true }, id:1}
        var cmd = JSON.stringify(o)
        console.debug(cmd)
        doc.send(cmd);
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
}
