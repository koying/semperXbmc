import QtQuick 1.0
import com.nokia.symbian 1.0
import "components" as Cp;

import "js/Utils.js" as Utils

Page {
    id: page

    tools:  ToolBarLayout {

        ToolButton {
            iconSource: "toolbar-back"
            onClicked: musicStack.pop()
            visible: musicStack.depth > 1
        }

        ToolButton {
            id: btFilter
            checkable: true
            iconSource: "img/filter.svg"
        }

        ToolButton {
            visible: false
        }

    }

    ListView {
        id: musicArtistList
        anchors.fill: parent
        clip: true
        highlightMoveDuration: 300

        model: artistProxyModel
        delegate: artistDelegate
    }

    ScrollDecorator {
        id: scrolldecorator
        flickableItem: musicArtistList
    }

    Component {
        id: artistDelegate

        Cp.Delegate {
            title: model.name
            image: model.posterThumb

            onSelected: {
                musicStack.push(Qt.resolvedUrl("MusicAlbumView.qml"), {artistId: model.id})
            }
        }
    }

    Cp.SearchDialog {
        id: searchDlg
        visible: btFilter.checked

        onApply: {
            artistProxyModel.filterRole = "name"
            artistProxyModel.filterRegExp = searchDlg.text
        }
        onCancel: {
            artistProxyModel.filterRole = ""
            artistProxyModel.filterRegExp = ""
        }
    }

    Component.onCompleted: {
        if (artistModel.count == 0)
            $().library.loadArtists();
    }

}
