import Qt 4.7
import com.nokia.symbian 1.0
import "components" as Cp;

import "js/Utils.js" as Utils

Page {
    tools:  ToolBarLayout {

        ToolButton {
            iconSource: "toolbar-back"
            onClicked: tvshowStack.pop()
            visible: tvshowStack.depth > 1
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
        id: tvshowList
        anchors.fill: parent
        clip: true

        model: tvshowModel
        delegate: tvshowDelegate
    }

    Component {
        id: tvshowDelegate

        Cp.Row {
            filtered: btFilter.checked && new RegExp(searchDlg.text,"i").test(model.name) != true

            text: model.name
            subtitle: (model.genre != undefined ? model.genre : "")
            source: model.thumb
            watched: model.playcount > 0
            banner: true

            onSelected:  {
                tvshowStack.push(Qt.resolvedUrl("TvSeasonView.qml"), {serieId: id})
            }
        }
    }

    Cp.SearchDialog {
        id: searchDlg
        visible: btFilter.checked
    }

    Component.onCompleted: {
        $().library.loadTVShows();
    }
}
