import QtQuick 1.0
import "components" as Cp;

Item {
    id: root

    width: 360
    height: 640


    Rectangle {
        id: toolbar
        width: parent.width
        height: 80
    }

    Rectangle {
        id: rootRect
        color: "black"
        anchors { top: toolbar.bottom; bottom: parent.bottom; right: parent.right; left: parent.left }

        ListView {
            id: mockList
            anchors.fill: parent

            model: mockModel
            delegate: mockDelegate
        }

        Item {
            id: invRoot
            z: 5
            anchors.fill: parent
        }
    }

    ListModel {
        id: mockModel

        ListElement {
            image: "qrc:/defaultImages/album"
            title: "Lorem Ipsum 1 abcsekqsdflfmerflkùseflkqsmùk"
            subtitle: "lorem ipsum 1"
            titleR: "2010"
            subtitleR: "2h47"
        }

        ListElement {
            image: "qrc:/defaultImages/album"
            title: "Lorem Ipsum 2 abcsekqsdflfmerflkùseflkqsmùk"
        }

        ListElement {
            image: "qrc:/defaultImages/album"
            title: "Lorem Ipsum 2"
            subtitle: "lorem ipsum 2"
        }

        ListElement {
            image: "qrc:/defaultImages/album"
            title: "Lorem Ipsum 1 abcsekqsdflfmerflkùseflkqsmùk"
            subtitle: "lorem ipsum 1"
            subtitleR: "2h47"
        }
    }

    Component {
        id: mockDelegate

        Cp.Delegate {
            id: mockup

            image: model.image
            title: model.title
            subtitle: model.subtitle
            titleR: model.titleR
            subtitleR: model.subtitleR

            style: "bigHorizontal"

            onSelected: {
            }
        }

    }
}

