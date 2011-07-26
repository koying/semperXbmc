import QtQuick 1.0
import com.nokia.symbian 1.0

Item {
    id: wrapper
    width:  parent.width
    height: 80

    property url image
    property string title
    property string subtitle
    property string titleR
    property string subtitleR

    property bool watched: false
    property bool banner:  false
    property bool current:  false

    property string type: "normal"

    property url subComponentSource: ""
    property alias subComponent: subComponent
    property alias style: wrapperItem.state

    signal selected

    Rectangle {
        id: wrapperItem
        width: parent.width
        height: parent.height
        color: "black"
        state:  "smallHorizontal"

        Rectangle {
            id: mainRect
            width: parent.width
            height: parent.height

            gradient:  current ? highlight : (wrapper.type == "header") ? header : normal
            Gradient {
                id: normal
                GradientStop {
                    position: 0
                    color: "#545454"
                }

                GradientStop {
                    position: 0.15
                    color: "#343434"
                }

                GradientStop {
                    position: 0.85
                    color: "#242424"
                }

                GradientStop {
                    position: 1
                    color: "#211919"
                }
            }

            Gradient {
                id: highlight

                GradientStop {
                    position: 0
                    color: "#b0b0bc"
                }

                GradientStop {
                    position: 0.01
                    color: "#616177"
                }

                GradientStop {
                    position: 0.5
                    color: "#262650"
                }

                GradientStop {
                    position: 0.95
                    color: "#282852"
                }

                GradientStop {
                    position: 1
                    color: "#28283c"
                }
            }

            //    color: "#336"

            Gradient {
                id: header

                GradientStop {
                    position: 0
                    color: "#281b18"
                }

                GradientStop {
                    position: 0.15
                    color: "#503730"
                }

                GradientStop {
                    position: 0.85
                    color: "#382520"
                }

                GradientStop {
                    position: 1
                    color: "#32201b"
                }
            }

            ListItem {
                id: li
                anchors.fill: parent

                Item {
                    id: imageRect

                    //                border.width: 1
                    //                border.color: "blue"
                    //                color: "transparent"

                    width: rowImage.isBannered ? parent.width : height

                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 5
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    anchors.rightMargin: 5

                    Image {
                        id: rowImage

                        property bool isBannered: false

                        anchors.fill: parent
                        fillMode: rowImage.isBannered ? Image.Stretch: Image.PreserveAspectFit
                        source: wrapper.image
                        smooth: true
                        asynchronous: true
                        onStatusChanged: {
                            if (rowImage.status == Image.Ready) {
                                if (rowImage.sourceSize.width > rowImage.sourceSize.height*2 && wrapper.banner) {   // banner
                                    rowImage.isBannered = true;
                                    rowImage.fillMode = Image.Stretch;
                                }
                            }
                        }

                        Image {
                            source: "../img/checkmark_48.png"
                            smooth: true
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            anchors.rightMargin: 10
                            visible: wrapper.watched
                        }
                    }
                }

                Item {
                    id: details

//                                    border.width: 1
//                                    border.color: "red"
//                                    color: "transparent"

                    anchors.top: parent.top
                    anchors.topMargin: 5
                    anchors.leftMargin: 5
                    anchors.left: rowImage.isBannered ? parent.left : imageRect.right
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 5

                    visible: !rowImage.isBannered;

                    Item {
                        //                    border.width: 1
                        //                    border.color: "green"
                        //                    color: "transparent"

                        width: parent.width
                        height: {
                            var h = 0;
                            if ((wrapper.title || wrapper.titleR))
                                h += txTitle.height;
                            if ((wrapper.subtitle || wrapper.subtitleR))
                                h += txSubtitle.height;
                            if ((wrapper.title || wrapper.titleR) && (wrapper.subtitle || wrapper.subtitleR))
                                h+= 10;

                            return h;
                        }

                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            id: txTitle
                            color: "#ffffff"
                            text: wrapper.title
                            elide: Text.ElideRight

                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: wrapper.titleR ? txTitleR.left : parent.right
                            font.pixelSize: 25
                        }
                        Text {
                            id: txTitleR
                            color: "#ffffff"
                            text: wrapper.titleR

                            anchors.top: parent.top
                            anchors.right: parent.right
                            font.pixelSize: 20
                        }

                        Text {
                            id: txSubtitle
                            color: "#999999"
                            text: wrapper.subtitle
                            elide: Text.ElideRight

                            anchors.top: txTitle.bottom
                            anchors.topMargin: 10
                            anchors.left: parent.left
                            anchors.right: wrapper.subtitleR ? txSubtitleR.left : parent.right
                            font.pixelSize: 18
                        }

                        Text {
                            id: txSubtitleR
                            color: "#999999"
                            text: wrapper.subtitleR
                            elide: Text.ElideRight

                            anchors.top: txTitle.bottom
                            anchors.topMargin: 10
                            anchors.right: parent.right
                            font.pixelSize: 15
                        }
                    }
                }

                onClicked: selected()
            }
        }

        Loader {
            id: subComponent
            property url sourceUrl
            z:5
            anchors { top: mainRect.bottom; topMargin: 10; bottom: parent.bottom; right: parent.right; left: parent.left }

            onSourceUrlChanged: source = sourceUrl
        }

        states: [
            State {
                name: "bigHorizontal"

                PropertyChanges {
                    target: imageRect
//                    width: 150
                    height: 150
                }

                PropertyChanges {
                    target: wrapper
                    height: 5 + 150 + 5
                }
            },
            State {
                name: "vertical"

                PropertyChanges {
                    target: imageRect
//                    width: 150
                    height: (rowImage.isBannered ? 80 : 150)
                }
                AnchorChanges {
                    target: imageRect
                    anchors.bottom: undefined
                    anchors.right: parent.right
                }

                AnchorChanges {
                    target: details
                    anchors.top: imageRect.bottom
                    anchors.left: parent.left
                }
                PropertyChanges {
                    target: details
                    visible: true
                }
                AnchorChanges {
                    target: txTitle
                    anchors.left: wrapper.titleR ? parent.left : undefined
                    anchors.right: wrapper.titleR ? txTitleR.left : undefined
                    anchors.horizontalCenter: wrapper.titleR ? undefined : parent.horizontalCenter
                }
                PropertyChanges {
                    target: txTitle
                    horizontalAlignment: wrapper.titleR ? Text.AlignLeft : Text.AlignHCenter
                }

                AnchorChanges {
                    target: txSubtitle
                    anchors.left: wrapper.subtitleR ? parent.left : undefined
                    anchors.right: wrapper.subtitleR ? txSubtitleR.left : undefined
                    anchors.horizontalCenter: wrapper.subtitleR ? undefined : parent.horizontalCenter
                }
                PropertyChanges {
                    target: txSubtitle
                    horizontalAlignment: wrapper.subtitleR ? Text.AlignLeft : Text.AlignHCenter
                }

                PropertyChanges {
                    target: wrapper
                    height: (rowImage.isBannered ? 5 + 80 + 10 + txTitle.height + 10 + txSubtitle.height + 5 :  5 + 150 + 10 + txTitle.height + 10 + txSubtitle.height + 5)
                }

            },

            State {
                name: "full"

                PropertyChanges {
                    target: mainRect
                    height: 80
                }

                PropertyChanges {
                    target: subComponent
                    sourceUrl: wrapper.subComponentSource
                }

                ParentChange {
                    target: wrapperItem
                    parent: page
                    x:0; y:0
                    width: root.width; height: root.height
                }
            }
        ]

        transitions: [
            Transition {
                reversible: true

                ParallelAnimation {
                    ParentAnimation {
                        //                    via: invRoot
                        NumberAnimation { properties: "x,y, width, height, opacity"; duration: 500; }
                    }
                    NumberAnimation { properties: "x,y, width, height, opacity"; duration: 500; }
                    AnchorAnimation { duration: 500; }
                }
            }
        ]

    }
}
