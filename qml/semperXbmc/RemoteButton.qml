import Qt 4.7
import com.semperpax.qmlcomponents 1.0

Item {
    id: container

    signal clicked

    property string imageSourceRoot: "img/remote/remote_button"
    property string text
    property string iconSource: ""

    width:  buttonImage.width; height:  buttonImage.height

    Image {
        id: buttonImage
        source: imageSourceRoot + "_up.png"
        //visible: (container.imageSource=="")
        smooth: true
    }
    Image {
        id: pressed
        opacity: 0
        source: imageSourceRoot + "_dn.png"
        width: container.width; height: container.height
        //visible: (container.imageSource=="")
        smooth: true
    }
    Image {
        id: icon
        source: container.iconSource
        fillMode: Image.PreserveAspectFit
        smooth: true
        anchors.centerIn: buttonImage;
        width: container.width-40; height: container.height-40
    }
    MouseArea {
        id: mouseRegion
        anchors.fill: buttonImage
        onClicked: {
            haptics.basicButtonClick();
            container.clicked();
        }
    }
    Text {
        color: "#aaaaaa"
        anchors.centerIn: buttonImage; font.bold: true
        text: container.text; /*style: Text.Raised; styleColor: "black"*/
        font.pointSize: 10
        visible: (container.iconSource=="")
    }
    states: [
        State {
            name: "Pressed"
            when: mouseRegion.pressed == true
            PropertyChanges { target: pressed; opacity: 1 }
        }
    ]
}
