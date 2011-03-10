import Qt 4.7

Item {
	width: videoComponent.width
	height: videoComponent.height
	//id: videoComponent

	ListView {
		id: movieView
		z: 1
		width: parent.width
		height: parent.height
		model: movieModel
		delegate: movieDelegate
	}

	Component {
		id: movieDelegate

		FRow {
			id: content
			text: name
			subtitle: genre + "\n" + duration
			source: thumb
			selected: selected
			portrait: true
			function clicked(id) {
				console.log("artist clicked" + id);
				$().playlist.addMovie(id);

			}
		}
	}
}
