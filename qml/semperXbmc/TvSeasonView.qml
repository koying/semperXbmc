import Qt 4.7
import com.nokia.symbian 1.0
import "components" as Cp;

import "js/Utils.js" as Utils

Page {
    property int serieId

    tools:  tvshowStack.depth > 1 ? pgTools : null

    ToolBarLayout {
        id: pgTools

        ToolButton {
            iconSource: "toolbar-back"
            onClicked: tvshowStack.pop()
            visible: tvshowStack.depth > 1
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
        id: tvSeasonList
        anchors.fill: parent
        clip: true

        model: seasonModel
        delegate: seasonDelegate
    }

    ScrollDecorator {
        id: scrolldecorator
        flickableItem: tvSeasonList
    }

    Component {
        id: seasonDelegate

        Cp.Delegate {
            filtered: {
                          var ret = false;
                          ret = ret | (!globals.showViewed && model.playcount > 0 );
                          return ret;
                      }

            title: model.name
            subtitle: model.episodes + " episodes"
            image: model.thumb
            watched: model.playcount > 0
            banner: true

            onSelected:  {
                tvshowStack.push(Qt.resolvedUrl("TvEpisodeView.qml"), {seasonId: id})
            }
        }
    }

    onSerieIdChanged: {
        seasonModel.clear();
        $().library.loadSeasons(serieId);
    }
}
