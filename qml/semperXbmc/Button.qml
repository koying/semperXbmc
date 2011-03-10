import Qt 4.7


Rectangle {
	property alias source:img.source
	property alias text:text.text
	id: base
	height: 80
	width: 80
	color: source ? "transparent" : "blue"
	radius: 10
	 Behavior on color { ColorAnimation { duration: 100}}
	Image {
		x: parent.height / 16
		y: parent.width / 16
		z: 1
		height: parent.height - 10
		width: parent.width - 10
		id: img
	}
	Text {
		id: text
		x: parent.height / 16
		y: parent.width / 16
		z: 2
		height: parent.height - 10
		width: parent.width - 10
		color: "#ffffff"
		elide: Text.ElideRight
		verticalAlignment :Text.AlignVCenter
		horizontalAlignment : Text.AlignHCenter
	}

	MouseArea {
		anchors.fill: parent;
		onClicked: {
			timer.start()
			base.state = "pressed"
			base.clicked();
		}
	}
	states: [
		State {
			name: "normal"
			PropertyChanges {
				target: base
				color: "transparent"
			}
		},
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
		onTriggered: base.state = "normal"

	}

}
