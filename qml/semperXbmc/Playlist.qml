import Qt 4.7
import "components" as Cp;

Item {
	anchors.fill: parent
	id: playlistComponent

	Row {
		ListView {
			width: playlistComponent.width / 2
			height: playlistComponent.height
			//interactive: false;
			highlightRangeMode: ListView.StrictlyEnforceRange
			highlightFollowsCurrentItem: true
			//preferredHighlightBegin:0
			//preferredHighlightEnd : playlistComponent.height
			model: playlistModel
			currentIndex: 5
			delegate: Item {
				//height: 50
				height: parent.height
				width: parent.width;
				//clip: true
				Cp.Image {
					id: currentThumb
					anchors.top: parent.top;
					anchors.topMargin: 50
					anchors.horizontalCenter: parent.horizontalCenter
					width: 200
					height: 400
					source: thumb
					text: name +"\n" + artist + "  -  " + album
				}
			}
			highlight:highlight

		}

		ListView {
			id: playlistView
			width: playlistComponent.width / 2
			height: playlistComponent.height
			model: playlistModel
			delegate: playlistDelegate
		}
	}
	Component {
		 id: highlight
		 Rectangle {
			 width: 180; height: 40
			 color: "lightsteelblue"; radius: 5
			 y: list.currentItem.y
			 Behavior on y {
				 SpringAnimation {
					 spring: 3
					 damping: 0.2
				 }
			 }
		 }
	 }

	Component {
		id: playlistDelegate

		Cp.Row {
			id: content
			text: name
			selected: select
			function clicked(id) {
				$().playlist.cmd("Play", '"params" : ' + id);
				//{"jsonrpc": "2.0", "method": "AudioPlaylist.Play", "params": 1, "id": 1}
			}
		}
	}

	Timer {
		id: timer
		interval: 2000; running: true; repeat: true
		onTriggered: $().playlist.update(playlistModel);

	}
}
