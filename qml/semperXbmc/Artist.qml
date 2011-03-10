import Qt 4.7
import "components" as Cp;

Component {
    id: artistDelegate

    Cp.Row {
        id: content
        text: name
        source: "img/user.svg"
        selected: selected
        function clicked(id) {
            console.log("artist clicked" + id);
            //artistComponent.clicked(id);
            container.state = 'album';
            $().library.loadAlbums(id);
        }
    }
}
