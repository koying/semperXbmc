import Qt 4.7
import "components" as Cp;

Component {
    id: artistDelegate

    Cp.Row {
        id: content
        width: ListView.view.width;
        height: 80

        text: name
        source: thumb
        selected: selected
        function clicked(id) {
            musicStack.push(Qt.resolvedUrl("MusicAlbumView.qml"), {artistId: id})
        }
    }
}
