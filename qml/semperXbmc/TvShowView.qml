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
            iconSource: "toolbar-menu"
            onClicked: pgMenu.open()
        }
    }

    Menu {
        id: pgMenu
        content: MenuLayout {

            CheckBox {
                text:  "Show viewed items"
                checked: globals.showViewed
                onClicked: globals.showViewed = checked
            }

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

        Cp.Row {
            filtered: {
                          var ret = false;
                          ret = ret | (!globals.showViewed && model.playcount > 0 );
                          return ret;
                      }

            text: model.name
            subtitle: (model.genre != undefined ? model.genre : "")
            source: model.posterThumb
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

        onTextChanged: {
            tvshowProxyModel.filterRole = "name"
            tvshowProxyModel.filterRegExp = searchDlg.text
        }
        onVisibleChanged: {
            if (searchDlg.visible) {
                tvshowProxyModel.filterRole = "name"
                tvshowProxyModel.filterRegExp = searchDlg.text
            } else {
                tvshowProxyModel.filterRole = ""
                tvshowProxyModel.filterRegExp = ""
            }
        }
    }

    Component.onCompleted: {
        if (tvshowModel.count == 0)
            $().library.loadTVShows();
    }

}
