import Qt 4.7
import com.nokia.symbian 1.0
import "components" as Cp;

import "js/Utils.js" as Utils

Page {
    id: page
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

        model: tvshowProxyModel
        delegate: tvshowDelegate
    }

    ScrollDecorator {
        id: scrolldecorator
        flickableItem: tvshowList
    }

    Component {
        id: tvshowDelegate

        Cp.Delegate {
            filtered: {
                          var ret = false;
                          ret = ret | (!globals.showViewed && model.playcount > 0 );
                          return ret;
                      }

            title: model.name
            subtitle: (model.genre != undefined ? model.genre : "")
            image: model.posterThumb
            watched: model.playcount > 0
            banner: true

            onSelected:  {
                tvshowStack.push(Qt.resolvedUrl("TvSeasonView.qml"), {serieId: model.id})
            }
        }
    }

    Cp.SearchDialog {
        id: searchDlg
        visible: btFilter.checked

        onApply: {
            tvshowProxyModel.filterRole = "name"
            tvshowProxyModel.filterRegExp = searchDlg.text
        }
        onCancel: {
            tvshowProxyModel.filterRole = ""
            tvshowProxyModel.filterRegExp = ""
        }
    }

    Component.onCompleted: {
        if (tvshowModel.count == 0)
            $().library.loadTVShows();
    }

}
