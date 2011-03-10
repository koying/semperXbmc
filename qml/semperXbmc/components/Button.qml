import Qt 4.7


Rectangle {
	property alias source:img.source
	property alias text:text.text
	id: base
	height: 80
	width: 80
	color: "#fcfcfc"
	radius: 10
	border.color: "#5f5f5f"
	border.width: 3
	Behavior on color { ColorAnimation { duration: 100}}
	Image {
		anchors.verticalCenter: parent.verticalCenter
		anchors.horizontalCenter: parent.horizontalCenter
		z: 1
		height: parent.height - 10
		width: parent.width - 10
		id: img
	}
	Text {
		id: text
		anchors.verticalCenter: parent.verticalCenter
		anchors.horizontalCenter: parent.horizontalCenter
		z: 2
		height: parent.height - 10
		width: parent.width - 10
		color: "black"
		elide: Text.ElideRight
		verticalAlignment :Text.AlignVCenter
		horizontalAlignment : Text.AlignHCenter
	}

	MouseArea {
		anchors.fill: parent;
		onPressed: {
			base.state = "pressed"
		}
		onReleased: {
			timer.start()
		}

		onClicked: {
			timer.start()
			base.state = "pressed"
			base.clicked();
		}
	}
	states: [
		State {
			name: "pressed"
			PropertyChanges {
				target: base
				color: "#339"
			}
		}

	]
	Timer {
		id: timer
		interval: 350; running: false; repeat: false
		onTriggered: base.state = ""

	}

}
