import Qt 4.7

Item {
	width: musicComponent.width
	height: musicComponent.height
	id: albumComponent

	GridView {
		id: albumView
		anchors.top: parent.top
		anchors.topMargin: 20
		width: parent.width
		height: parent.height - 20
		cellWidth: 200
		cellHeight: 220
		model: albumModel
		delegate: albumDelegate
		//clip: true;
	}
	Component {
		id: albumDelegate
		Album {
		}
	}
}
