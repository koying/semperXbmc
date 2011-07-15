import QtQuick 1.0
import com.nokia.symbian 1.0
import com.semperpax.qmlcomponents 1.0
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
        MenuLayout {

            CheckBox {
                text:  "Show viewed items"
                checked: globals.showViewed
                onClicked: globals.showViewed = checked
            }

            MenuItem {
                text:  "View..."
                platformSubItemIndicator: true
                onClicked: viewMenu.open()
            }


        }
    }

    ContextMenu {
        id: viewMenu
        MenuLayout {
            MenuItem {
                text:  "List view"
            }
            MenuItem {
                text:  "Coverflow view"
                onClicked: movieStack.push(Qt.resolvedUrl("MovieViewCover.qml"))
            }
        }
    }

    ListView {
        id: movieList
        anchors.fill: parent
        clip: true

        model: movieModel
        delegate: movieDelegate
    }

    ScrollDecorator {
        id: scrolldecorator
        flickableItem: movieList
    }

    Component {
        id: movieDelegate

        Cp.Row {
            filtered: {
                          var ret = false;
                          ret = (btFilter.checked && new RegExp(searchDlg.text,"i").test(model.name) != true);
                          ret = ret | (!globals.showViewed && model.playcount > 0 );
                          return ret;
                      }

            text: model.name
            subtitle: (model.genre != undefined ? model.genre : "")
            duration:  model.duration > 0 ? Utils.secToHours(model.duration) : (model.runtime != undefined ? model.runtime : "")
            source: model.thumb
            watched: model.playcount > 0

            onSelected:  {
                $().playlist.videoClear();
                xbmcEventClient.actionButton("Stop");
                $().playlist.addMovie(id);
            }
        }
    }

    Cp.SearchDialog {
        id: searchDlg
        visible: btFilter.checked
    }

    Component.onCompleted: {
        if (movieModel.count == 0)
            $().library.loadMovies();
    }
}
