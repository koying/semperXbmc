import Qt 4.7
import com.nokia.symbian 1.0
import "components" as Cp;

import "js/Utils.js" as Utils

Page {
    id: page
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
            subtitle:  model.showtitle
            subtitleR: model.episodes + " ep"
            image: model.thumb
            watched: model.playcount > 0
            banner: true

            style: "bigHorizontal"
            type: "header"

            subComponentSource: "TvEpisodeComponent.qml"

            Connections {
                target: subComponent
                onLoaded: subComponent.item.seasonId = model.id
            }

            onSelected:  {
//                tvshowStack.push(Qt.resolvedUrl("TvEpisodeView.qml"), {seasonId: id})
                if (style == "bigHorizontal")
                    style = "full"
                else
                    style = "bigHorizontal"
            }
        }
    }

    onSerieIdChanged: {
        seasonModel.clear();
        $().library.loadSeasons(serieId);
    }
}
