import QtQuick 1.0
import com.nokia.symbian 1.1

Rectangle {
    id: root

    gradient: Gradient {
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

    height: main.height / 3
    width: btMute.width + 10

    ToolButton {
        id: btMute
        iconSource: main.muted ? "img/mute.svg" : "img/volume.svg"
        anchors { top: parent.top }

        onClicked: {
            $().general.setMute(!main.muted)
        }
    }

    Slider {
        id: volSlider
        orientation: Qt.Vertical
        minimumValue: 0
        maximumValue: 100
        inverted: true
        stepSize: 5
        value: main.volume
        valueIndicatorVisible: true

        anchors { left: parent.left; right: parent.right; bottom: parent.bottom; top: btMute.bottom }

        onValueChanged: {
            if (!volSlider.pressed && !main.muted && volSlider.value != main.volume) {
                $().general.setVolume(volSlider.value)
            }
        }
    }


}
