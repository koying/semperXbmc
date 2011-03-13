import Qt 4.7
import "js/Utils.js" as Utils

Rectangle {
    color:  "black"
    width: root.width
    height: root.height

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
            subtitle: genre + "\n" + (duration > 0 ? Utils.secToHours(duration) : runtime)
            source: thumb
            selected: selected
            portrait: true
            watched: playcount > 0
            function clicked(id) {
                $().playlist.videoClear();
                $().playlist.addMovie(id);
                main.state = ""
            }
        }
    }
}
