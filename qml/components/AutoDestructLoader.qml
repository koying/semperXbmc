import QtQuick 1.0

Item {
    id: wrapper
    property alias item: ldr.item
    property url sourceUrl
    property int duration: 0

    height: ldr.item ? ldr.item.height : 0
    width:  ldr.item ? ldr.item.width : 0
    opacity:  0

    signal loaded
    signal destruction

    Loader {
        id: ldr
        anchors.fill:  parent

        onLoaded: {
            wrapper.state = "show"
            wrapper.loaded();
        }

        onSourceChanged: {
            if (source == "") {
//                console.debug("destroyed");
                destruction();
            }
        }
    }

    onSourceUrlChanged: {
//        console.debug("changed: "+sourceUrl);
        if (sourceUrl && sourceUrl != "") {
            ldr.source = sourceUrl;
        } else {
            wrapper.state = ""
        }
    }

    Timer {
        id: timer
        interval: wrapper.duration
        onTriggered: wrapper.state = ""
    }

    states: [
        State {
            name: "show"
            PropertyChanges {
                target: wrapper
                opacity: 1
            }
            PropertyChanges {
                target: timer
                running: duration > 0 ? true : false
            }
        }
    ]

    transitions: [
        Transition {
            from:  "show"
            SequentialAnimation {
                NumberAnimation { properties: "opacity"; duration: 300; }
                PropertyAction { target: ldr; property: "source"; value: "" }
            }
        }
    ]
}
