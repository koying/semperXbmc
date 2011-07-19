import QtQuick 1.0

Item {
    id: wrapper
    width:  parent.width
    height: filtered ? 0 : 80
    visible: !filtered

    property url image
    property string title
    property string subtitle
    property string titleR
    property string subtitleR

    property bool watched: false
    property bool banner:  false
    property bool filtered: false
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

            gradient:  (wrapper.type == "normal") ? normal : ((wrapper.type == "header") ? header : highlight)
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

            Item {
                id: imageRect
                width: height

                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.rightMargin: 5

                Image {
                    id: rowImage
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    source: wrapper.image
                    smooth: true
                    asynchronous: true
                    onStatusChanged: {
                        if (rowImage.status == Image.Ready) {
                            if (rowImage.sourceSize.width > rowImage.sourceSize.height*2 && wrapper.banner) {   // banner
//                                details.visible = false;
//                                grid.anchors.fill = content
                                imageRect.width = wrapper.width
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

            Text {
                id: txTitle
                color: "#ffffff"
                text: wrapper.title
                elide: Text.ElideRight

                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.leftMargin: 10
                anchors.left: imageRect.right
                anchors.right: wrapper.titleR ? txTitleR.left : undefined
                anchors.rightMargin: 5
                font.pixelSize: 25
            }
            Text {
                id: txTitleR
                color: "#ffffff"
                text: wrapper.titleR

                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.rightMargin: 5
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
                anchors.leftMargin: 10
                anchors.left: imageRect.right
                anchors.right: wrapper.subtitleR ? txSubtitleR.left : undefined
                anchors.rightMargin: 5
                font.pixelSize: 18
            }

            Text {
                id: txSubtitleR
                color: "#999999"
                text: wrapper.subtitleR
                elide: Text.ElideRight

                anchors.top: txTitle.bottom
                anchors.topMargin: 10
                anchors.rightMargin: 5
                anchors.right: parent.right
                font.pixelSize: 15
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    selected();
//                    if (wrapperItem.state == "") {
//                        if (wrapper.subComponent != "")
//                            wrapperItem.state = "full"
//                        else
//                            wrapperItem.state = "full"
//                    } else
//                        wrapperItem.state = ""
                }
            }
        }

        Loader {
            id: subComponent
            anchors { top: mainRect.bottom; topMargin: 10; bottom: parent.bottom; right: parent.right; left: parent.left }
        }

        states: [
            State {
                name: "bigHorizontal"

                PropertyChanges {
                    target: imageRect
                    width: 150
                    height: 150
                }

                PropertyChanges {
                    target: wrapper
                    height: 5 + 150 + 5
                }
            },
            State {
                name: "iterimVert"

                PropertyChanges {
                    target: imageRect
                    width: 150
                    height: 150
                }
                AnchorChanges {
                    target: imageRect
                    anchors.bottom: undefined
                    anchors.right: parent.right
                }

                AnchorChanges {
                    target: txTitle
                    anchors.top: imageRect.bottom
                    anchors.left: wrapper.titleR ? parent.left : undefined
                    anchors.horizontalCenter: wrapper.titleR ? undefined : parent.horizontalCenter
                }
                AnchorChanges {
                    target: txTitleR
                    anchors.top: imageRect.bottom
                }
                AnchorChanges {
                    target: txSubtitle
                    anchors.left: wrapper.subtitleR ? parent.left : undefined
                    anchors.horizontalCenter: wrapper.subtitleR ? undefined : parent.horizontalCenter
                }

                PropertyChanges {
                    target: txSubtitle
                    anchors.topMargin: 5
                }
            },

            State {
                name: "vertical"
                extend: "iterimVert"

                PropertyChanges {
                    target: wrapper
                    height: 5 + 150 + 10 + txTitle.height + 10 + txSubtitle.height + 5
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
                    source: wrapper.subComponentSource
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
                    NumberAnimation { properties: "x,y, width, height, opacity"; duration: 500; }
                    AnchorAnimation { duration: 500; }
                }
            },
            Transition {
                to: "full"
                reversible: true

                ParentAnimation {
//                    via: invRoot
                    NumberAnimation { properties: "x,y, width, height, opacity"; duration: 500; }
                }
                AnchorAnimation { duration: 500; }
            }
        ]

    }
}
