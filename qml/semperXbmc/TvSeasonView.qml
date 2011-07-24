import Qt 4.7
import com.nokia.symbian 1.0
import "components" as Cp;

import "js/Utils.js" as Utils

Page {
    id: page
    property int serieId

    tools:  pgTools

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

            MenuItem {
                text:  "Style"
                platformSubItemIndicator: true
                onClicked: styleMenu.open()
            }
            MenuItem {
                text:  "Refresh"
                onClicked: refresh()
            }
        }
    }

    ContextMenu {
        id: styleMenu
        MenuLayout {
            MenuItem {
                text:  "Small Horizontal"
                onClicked: {
                    globals.styleTvShowSeasons = "smallHorizontal"
                }
            }
            MenuItem {
                text:  "Big Horizontal"
                onClicked: {
                    globals.styleTvShowSeasons = "bigHorizontal"
                }
            }
            MenuItem {
                text:  "Vertical"
                onClicked: {
                    globals.styleTvShowSeasons = "vertical"
                }
            }
        }
    }

    ListView {
        id: tvSeasonList
        anchors.fill: parent
        clip: true

        model: seasonProxyModel
        delegate: seasonDelegate
    }

    ScrollDecorator {
        id: scrolldecorator
        flickableItem: tvSeasonList
    }

    Component {
        id: seasonDelegate

        Cp.Delegate {
            title: model.name
            subtitle:  model.showtitle
            subtitleR: model.episodes + " ep"
            image: model.poster
            watched: model.playcount > 0

            style: globals.styleTvShowSeasons
            banner: globals.showBanners
            type: "header"

            subComponentSource: "TvEpisodeComponent.qml"

            Connections {
                target: subComponent
                onLoaded: subComponent.item.seasonId = model.id
            }

            onSelected:  {
//                tvshowStack.push(Qt.resolvedUrl("TvEpisodeView.qml"), {seasonId: id})
                if (style == globals.styleTvShowSeasons)
                    style = "full"
                else
                    style = globals.styleTvShowSeasons
            }
        }
    }

    function refresh() {
        $().library.loadSeasons(serieId);
    }

    onSerieIdChanged: {
        $().library.loadSeasons(serieId);
    }
}
