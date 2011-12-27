import QtQuick 1.0
import com.nokia.symbian 1.1

Item {
    id: wrapper
    width: 300
    height: 300

    ListView {
        anchors.fill: parent
        model: errorModel
        delegate: errorDelegate

        visible: (errorModel.count > 0)
    }

    ListModel {
        id: errorModel

//        ListElement { icon: "warning"; message: "test"; info: "info" }
//        ListElement { icon: "error"; message: "test2";  }
    }

    Component {
        id: errorDelegate

        Rectangle {
            id: cpWrapper
            width: wrapper.width
            height: 0

            gradient: normal
            Gradient {
                id: normal
                GradientStop { position: 0.0; color: "#555" }
                GradientStop { position: 1.0; color: "#000" }
            }

            Behavior on height {
                NumberAnimation { duration: 500 }
            }

            Item {
                id: listItem1
                anchors.fill: parent
                anchors.margins: platformStyle.paddingMedium
                opacity: 0

                Behavior on opacity {
                    NumberAnimation { duration: 500 }
                }

                Row {
                    spacing: platformStyle.paddingLarge
                    anchors.fill: parent

                    Image {
                        id: imgType
                        source: model.icon
                        smooth: true
                    }

                    Column {
                        spacing: platformStyle.paddingSmall
                        width: parent.width - imgType.width - (platformStyle.paddingLarge)

                        ListItemText {
                            text: model.message
                            role: "Title"

                        }
                        ListItemText {
                            id: txInfo
                            text: (model.info != undefined ? model.info : "")
                            role: "Subtitle"
                            visible: text != ""
                        }
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    cpWrapper.state = ""
                    errorModel.remove(index);
                }
            }

            Timer {
                id: timer
                interval: 5000
                onTriggered: errorModel.remove(index)
            }

            states: [
                State {
                    name: "show"
                    PropertyChanges {
                        target: cpWrapper
                        height: 70 - (!txInfo.visible ? 12 : 0)
                    }
                    PropertyChanges {
                        target: listItem1
                        opacity: 1
                    }
                    PropertyChanges {
                        target: timer
                        running: true
                    }
                }
            ]

            Component.onCompleted: {
                state = "show"
            }
        }
    }

    function addError(type, message, info) {
        errorModel.append({"icon": "img/dialog-"+type+".png", "message":message, "info":info});
    }

}
