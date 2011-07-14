import QtQuick 1.0

Rectangle {
    id: coverFlow

    property int itemHeight: height-60
    property int itemWidth: itemHeight*0.67
    property int currentCardIndex: 0

    property ListModel listModel

    signal indexChanged(int index)

    Component {
        id: appDelegate

        Image {
            id: myIcon
            source: model.thumb
            smooth: true
            width: itemWidth; height: itemHeight

            transform: Rotation {
                origin.x: myIcon.width/2; origin.y: myIcon.height/2
                axis.x: 0; axis.y: 1; axis.z: 0     // rotate around y-axis
                angle: PathView.cardAngle
            }
        }
    }

    PathView {
         id: deckPathView
         x: 0; y: 0
         height: parent.height
         width: parent.width
         pathItemCount: 7
         model: listModel
         delegate: appDelegate
         preferredHighlightBegin: 0.35
         preferredHighlightEnd: 0.65
         highlightRangeMode: PathView.StrictlyEnforceRange
         highlightMoveDuration: 100
         dragMargin: parent.height/3
         opacity: 1.0

         path: Path {
             startX:  10; startY: coverFlow.height/2
             PathPercent { value: 0.0 }
             PathAttribute { name: "cardScaling"; value:  0.6 }
             PathAttribute { name: "cardAngle"; value:  70 }

             PathLine { x: (coverFlow.width*0.25); y: coverFlow.height/2 }
             PathPercent { value: 0.35 }
             PathAttribute { name: "cardScaling"; value:  0.75 }
             PathAttribute { name: "cardAngle"; value:  70 }

             PathLine { x: coverFlow.width/2; y: coverFlow.height/2 }
             PathPercent { value: 0.5 }
             PathAttribute { name: "cardScaling"; value:  1.0 }
             PathAttribute { name: "cardAngle"; value:  0 }

             PathLine { x: (coverFlow.width*0.75); y: coverFlow.height/2 }
             PathPercent { value: 0.65 }
             PathAttribute { name: "cardScaling"; value:  0.75 }
             PathAttribute { name: "cardAngle"; value:  -70 }

             PathLine { x: coverFlow.width; y: coverFlow.height/2 }
             PathPercent { value: 1.0 }
             PathAttribute { name: "cardScaling"; value:  0.6 }
             PathAttribute { name: "cardAngle"; value:  -70 }
         }
         onCurrentIndexChanged: {
             currentCardIndex = currentIndex;
             if (currentCardIndex === listModel.count) {
                 currentCardIndex = 0;
             }
             console.log("Current index changed: " + currentIndex);
         }

     }
}


//import Qt 4.7

//Item {
//    id: container

//    signal cardClicked(string cardValue);

//    property int cardHeight: height-60
//    property int cardWidth: cardHeight*0.67
//    property int currentCardIndex: 0

//    property string themeName: ""
//    property bool zoomed: false;

//    // Handle orientation switching
//    // Connect the the orientation sensor signal from C++ to our handler function
//    Connections {
//        id: orient
//        property int rotation
//        target: filter // this is available only on device, on desktop you get warnings
//        onOrientationChanged: {
//        console.log("ORIENT: " + orientation);
//            if (orientation === 1) {
//                console.log("Orientation TOP POINTING UP");
//                zoomedCard.x = container.width/3
//                zoomedCard.y = container.height/6
//                zoomedCard.width = cardWidth
//                zoomedCard.height = cardHeight
//                zoomedCard.value = deck.get(currentCardIndex+1).cardValue;
//                zoomed = true;
//            } else {
//                console.log("Some other orientation");
//                zoomed = false;
//            }
//        }
//    }

//    // Model for the deck
//    DeckModel {
//        id: deck
//    }

//    PathView {
//        id: deckPathView
//        x: 0; y: 0
//        height: parent.height
//        width: parent.width
//        pathItemCount: 7
//        model: deck
//        delegate: cardDelegate
//        preferredHighlightBegin: 0.35
//        preferredHighlightEnd: 0.65
//        highlightRangeMode: PathView.StrictlyEnforceRange
//        highlightMoveDuration: 100
//        dragMargin: parent.height/3
//        opacity: 1.0

//        path: Path {
//            startX:  10; startY: container.height/2
//            PathPercent { value: 0.0 }
//            PathAttribute { name: "cardScaling"; value:  0.6 }
//            PathAttribute { name: "cardAngle"; value:  70 }

//            PathLine { x: (container.width*0.25); y: container.height/2 }
//            PathPercent { value: 0.35 }
//            PathAttribute { name: "cardScaling"; value:  0.75 }
//            PathAttribute { name: "cardAngle"; value:  70 }

//            PathLine { x: container.width/2; y: container.height/2 }
//            PathPercent { value: 0.5 }
//            PathAttribute { name: "cardScaling"; value:  1.0 }
//            PathAttribute { name: "cardAngle"; value:  0 }

//            PathLine { x: (container.width*0.75); y: container.height/2 }
//            PathPercent { value: 0.65 }
//            PathAttribute { name: "cardScaling"; value:  0.75 }
//            PathAttribute { name: "cardAngle"; value:  -70 }

//            PathLine { x: container.width; y: container.height/2 }
//            PathPercent { value: 1.0 }
//            PathAttribute { name: "cardScaling"; value:  0.6 }
//            PathAttribute { name: "cardAngle"; value:  -70 }
//        }
//        onCurrentIndexChanged: {
//            currentCardIndex = currentIndex;
//            if (currentCardIndex === deck.count) {
//                currentCardIndex = 0;
//            }
//            console.log("Current index changed: " + currentIndex + ": " + deck.get(currentIndex).cardValue);
//        }

//    }

//    Component {
//        id: cardDelegate
//        Card {
//            id: card
//            scale: PathView.cardScaling
//            height: cardHeight
//            width: cardWidth
//            value: cardValue
//            theme: container.themeName

//            transform: Rotation {
//                origin.x: card.width/2; origin.y: card.height/2
//                axis.x: 0; axis.y: 1; axis.z: 0     // rotate around y-axis
//                angle: PathView.cardAngle
//            }
//        }
//    }

//    Card {
//        id: zoomedCard
//        opacity: 0.0
//        z: 100
//        theme: container.themeName
//        onClicked: container.zoomed = false;
//    }

//    states: [
//        State {
//            name: "zoomedState"
//            when: container.zoomed
//            PropertyChanges {
//                target: zoomedCard
//                opacity: 1.0
//                scale: 1.5
//                rotation: -90
//                x: container.width/2 - zoomedCard.width/2
//                y: container.height/2 - zoomedCard.height/2
//                disableFlip: true
//            }
//            PropertyChanges {
//                target: deckPathView
//                opacity: 0.0
//            }
//        }
//    ]

//    transitions: [
//        Transition {
//            from: ""
//            to: "zoomedState"
//            ParallelAnimation {
//                PropertyAnimation {
//                    target: deckPathView
//                    properties: "opacity"
//                    duration: 400
//                }
//                PropertyAnimation {
//                    target: zoomedCard
//                    properties:  "opacity"
//                    duration: 500
//                }
//                PropertyAnimation {
//                    target: zoomedCard
//                    properties:  "width, height, x, y, scale, rotation"
//                    duration: 500
//                }
//            }
//        },
//        Transition {
//            from: "zoomedState"
//            to: ""
//            ParallelAnimation {
//                PropertyAnimation {
//                    target: zoomedCard
//                    properties:  "width, height, x, y, scale, rotation"
//                    duration: 500
//                }
//                PropertyAnimation {
//                    target: zoomedCard
//                    properties:  "opacity"
//                    duration: 500
//                }
//                PropertyAnimation {
//                    target: deckPathView
//                    properties: "opacity"
//                    duration: 600
//                }
//            }
//        }
//    ]
//}
