import Qt 4.7
import com.nokia.symbian 1.0
import "components" as Cp;

import "js/Utils.js" as Utils

Page {
    property int seasonId: -99

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
        id: tvEpisodeList
        anchors.fill: parent
        clip: true

        model: episodeModel
        delegate: episodeDelegate
    }

    ScrollDecorator {
        id: scrolldecorator
        flickableItem: tvEpisodeList
    }

    Component {
        id: episodeDelegate

        Cp.Delegate {
            filtered: {
                          var ret = false;
                          ret = ret | (!globals.showViewed && model.playcount > 0 );
                          return ret;
                      }

            title: (model.number > 0 ? model.number + ". " : "") + model.name
            subtitle: (model.duration > 0 ? Utils.secToMinutes(model.duration) : "")
            image: model.thumb
            watched: model.playcount > 0
            banner: true

            onSelected: {
//                console.log("episode clicked" + id);
                $().playlist.videoClear();
                xbmcEventClient.actionButton("Stop");
                $().playlist.addEpisode(id);
                mainTabGroup.currentTab = remoteTab
            }
        }

    }

    onSeasonIdChanged: {
        episodeModel.clear();
        $().library.loadEpisodes(seasonId);
    }
}
