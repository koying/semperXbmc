import Qt 4.7


Rectangle {
	property alias text: title.text
	property alias source: image.source
	property alias fancy: base.state;
	property bool button: false;

	width: 200
	height: 400
	id: base;
	color: "transparent"
	Item {
		width: parent.width;
		height: parent.height
		clip: true;

		Rectangle {
			id: border
			color: "black"
			width: parent.width;
			height: parent.width
			Image {
				x: -2
				y: -2
				id: image
				width: parent.width;
				height: parent.width
				fillMode:Image.PreserveAspectFit
			}
		}

		Item {
			id: mirror
			width: image.width;
			height: image.height * 1.3
			anchors.top: border.bottom
			Image {
				opacity: 0.3
				y: image.height + 10
				z: 1

				width: image.width;
				height: image.height
				source: image.source
				fillMode:Image.PreserveAspectFit
				transform: Rotation { origin.x: 0; origin.y: 0; angle: 180; axis { x: 1; y: 0; z: 0 }}

			}
			Rectangle {
				anchors.fill: parent
				z: 2
				gradient: Gradient {
					GradientStop { position: 0.0; color: "#00000000" }
					GradientStop { position: 0.7; color: "#FF000000" }
				}
			}
		}
		transform: Rotation { id: rotation; origin.x: 0; origin.y: 0; angle: 30; axis { x: 0; y: 1; z: 0 }}
	}
	Text {
		id: title
		color: "white"
		font.pointSize: 12
		y: image.height + 20
		anchors.horizontalCenter: base.horizontalCenter
		horizontalAlignment: Text.AlignHCenter;
	}

	MouseArea {
		id: mouseArea
		anchors.fill: parent;
		onClicked: {
			if (button) {
				base.clicked();
			}
		}
	}

	states: [
		State {
			name: "false"
			PropertyChanges {
				target: mirror
				visible: false
			}
			PropertyChanges {
				target: rotation
				angle: 0
			}
		}
	]



}

