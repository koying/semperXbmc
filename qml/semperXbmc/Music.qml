import Qt 4.7

Item {
	anchors.fill: parent
	id: musicComponent

	Row {
		id: container
		Item {
			width: musicComponent.width
			height: musicComponent.height
			ArtistView {
				visible: !touch
			}
			AlbumGridView {
				id: albumComponent
				visible: touch
			}
		}
		AlbumView {
		}
		states: [
			State {
				name: "album"
				PropertyChanges {
					target: container
					x: -root.width;
				}
			}

		]
		transitions: Transition {
			PropertyAnimation {
				properties: "x";
				easing.type: Easing.InOutQuad
				duration: 500
			}
		}
	}

	function back() {
		if (container.state == "") {
			return true;
		}
		else {
			container.state = "";
			return false;
		}
	}


}
