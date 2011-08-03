import Qt 4.7
import com.semperpax.qmlcomponents 1.0

Item {
    id: container

    signal clicked

    // Symbian specific signals and properties
    signal platformReleased
    signal platformPressAndHold

    property string imageSourceRoot: "img/remote/remote_button"
    property string text
    property string iconSource: ""
    property bool autoRepeat: false

    width:  btUp.width; height:  btUp.height

    Timer {
        id: tapRepeatTimer

        interval: 60; running: false; repeat: true
        onTriggered: container.repeat()
    }

    function press() {
        btDn.visible = true;
    }

    function repeat() {
        haptics.sensitiveButtonClick();
        container.clicked();
    }

    function release() {
        if (tapRepeatTimer.running)
            tapRepeatTimer.stop()
        btDn.visible = false;
        container.platformReleased()
    }

    function click() {
        haptics.basicButtonClick();
        container.clicked();
    }

    Image {
        id: btUp
        source: imageSourceRoot + "_up.png"
        smooth: true
    }
    Image {
        id: btDn
        visible:  false
        source: imageSourceRoot + "_dn.png"
        width: container.width; height: container.height
        smooth: true
    }
    Image {
        id: icon
        source: container.iconSource
        fillMode: Image.PreserveAspectFit
        smooth: true
        anchors.centerIn: btUp;
        width: container.width-40; height: container.height-40
    }

    Text {
        color: "#aaaaaa"
        anchors.centerIn: btUp; font.bold: true
        text: container.text; /*style: Text.Raised; styleColor: "black"*/
        font.pointSize: 10
        visible: (container.iconSource=="")
    }

    MouseArea {
        id: mouseRegion
        anchors.fill: btUp

        onPressed: stateGroup.state = "Pressed"

        onReleased: stateGroup.state = ""

        onCanceled: {
            // Mark as canceled
            stateGroup.state = "Canceled"
            // Reset state. Can't expect a release since mouse was ungrabbed
            stateGroup.state = ""
        }

        onPressAndHold: {
            if (stateGroup.state != "Canceled" && autoRepeat)
                stateGroup.state = "AutoRepeating"
            container.platformPressAndHold()
        }

        onExited: stateGroup.state = "Canceled"
    }

    StateGroup {
        id: stateGroup

        states: [
            State { name: "Pressed" },
            State { name: "AutoRepeating" },
            State { name: "Canceled" }
        ]

        transitions: [
            Transition {
                to: "Pressed"
                ScriptAction { script: container.press() }
            },
            Transition {
                from: "Pressed"
                to: "AutoRepeating"
                ScriptAction { script: tapRepeatTimer.start() }
            },
            Transition {
                from: "Pressed"
                to: ""
                ScriptAction { script: container.release() }
                ScriptAction { script: container.click() }
            },
            Transition {
                from: "Pressed"
                to: "Canceled"
                ScriptAction { script: container.release() }
            },
            Transition {
                from: "AutoRepeating"
                ScriptAction { script: container.release() }
            }
        ]
    }
}
