import QtQuick 1.0

Item {

    signal prefClicked
    signal quitClicked

    Rectangle {
        id: container
        anchors.fill: parent; color: "#343434";

        property string text: "TITLE"
        property string fontName: "Helvetica"
        property int fontSize: 18
        property color fontColor: "lightgray"
        property bool fontBold: false

        Text {
            id: titleText
            smooth: true
            clip: true
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left; leftMargin: 10;
            }
            color: container.fontColor

            font {
                bold: container.fontBold
                family: container.fontName
                pointSize: container.fontSize
            }

            text: container.text
            elide: Text.ElideLeft
            textFormat: Text.RichText
            wrapMode: Text.Wrap
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        Button {
            id: quitButton
            anchors.right: parent.right; anchors.rightMargin: 10;
            width: parent.height-4
            height: parent.height-4
            anchors.verticalCenter: parent.verticalCenter
            onClicked: quitClicked()
            imageSource: "img/delete_48.png"
        }

        Button {
            id: prefButton
            anchors.right: quitButton.left; anchors.rightMargin: 10
            width: parent.height-4
            height: parent.height-4
            anchors.verticalCenter: parent.verticalCenter
            onClicked: prefClicked()
            imageSource: "img/gear_48.png"
        }
    }
}
