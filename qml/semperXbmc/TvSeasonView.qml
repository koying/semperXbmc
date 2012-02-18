import Qt 4.7
import com.nokia.symbian 1.1
import "components/" as Cp;
import "menus/" as Menus

import "js/Utils.js" as Utils

Page {
    id: page
    focus: true

    property int serieId

    tools:  menuLayout

    Menus.TvToolbarLayout {
        id: menuLayout
    }

    Keys.onBackPressed: {
        tvshowStack.pop()
        event.accepted = true
    }

    ContextMenu {
        id: viewMenu
        MenuLayout {
            MenuItem {
                text:  "All"
            }
            MenuItem {
                text:  "Recent episodes"
                onClicked: {
                    globals.initialTvshowView = "TvShowRecentView.qml"
                    tvshowStack.clear();
                    tvshowStack.push(Qt.resolvedUrl(globals.initialTvshowView))
                }
            }
            MenuItem {
                text:  "By Genre"
                onClicked: {
                    tvshowProxyModel.clear();
                    globals.initialTvshowView = "TvShowGenreView.qml"
                    tvshowStack.clear();
                    tvshowStack.push(Qt.resolvedUrl(globals.initialTvshowView))
                }
            }
//            MenuItem {
//                text:  "Coverflow view"
//                onClicked: movieStack.push(Qt.resolvedUrl("MovieViewCover.qml"))
//            }
        }
    }

    Menus.TvStyleMenu {
        id: styleMenu
    }

    ListView {
        id: tvSeasonList
        anchors.fill: parent
        clip: true

        model: seasonProxyModel
        delegate: seasonDelegate
    }

    ScrollDecorator {
        flickableItem: tvSeasonList
    }

    Component {
        id: seasonDelegate

        Cp.Delegate {
            title: model.name
            subtitle:  model.showtitle
            subtitleR: model.episodes + " ep"
            image: model.poster != "" ? model.poster : "qrc:/defaultImages/tvshow"
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
