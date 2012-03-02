// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.semperpax.qmlcomponents 1.0

import "js/Utils.js" as Utils

XbmcJsonTcpClient {

    onNotificationReceived: {
        console.debug(jsonMsg)
        var oJSON = JSON.parse(jsonMsg);
        var error = oJSON.error;
        if (error) {
            console.debug(Utils.dumpObj(error, "Error", "", 0));
            return;
        }
//            console.debug(Utils.dumpObj(oJSON, "Notif", "", 0));

        var method = oJSON.method;
//            console.debug(method);
        if (!method) {
//                console.debug("no method");
            return;
        }

        var data = oJSON.params.data;
        if (!data) {
//                console.debug("No data");
            return;
        }
        var item = data.item;
        if (item) {
            for (var attrname in item) { data[attrname] = item[attrname]; }
        }

//            console.debug(Utils.dumpObj(data, "data", "", 0));

        switch (method) {
        case "VideoLibrary.OnUpdate":
            switch(data.type) {
            case "movie":
                movieModel.update(data);
                break;

            case "episode":
                episodeModel.update(data);
                break;
            }

            break;

        case "VideoLibrary.OnRemove":
            switch(data.type) {
            case "movie":
                movieModel.remove(data);
                break;

            case "episode":
                episodeModel.remove(data);
                break;
            }

            break;

        case "AudioLibrary.OnUpdate":
            break;

        case "AudioLibrary.OnRemove":
            break;

//        case "Player.OnPlay":
//            switch(data.type) {
//            case "song":
//                playlistView.front.player.playing = true
//                playlistView.front.player.paused = false
//                break;
//            case "movie":
//            case "episode":
//                playlistView.back.player.playing = true
//                playlistView.back.player.paused = false
//                break;
//            }
//            break;


//        case "Player.OnPause":

//            switch(data.type) {
//            case "song":
//                playlistView.front.player.playing = false
//                playlistView.front.player.paused = true
//                break;
//            case "movie":
//            case "episode":
//                playlistView.back.player.playing = false
//                playlistView.back.player.paused = true
//                break;
//            }
//            break;

//        case "Player.OnStop":

//            switch(data.type) {
//            case "song":
//                playlistView.front.player.playing = false
//                playlistView.front.player.paused = false
//                break;
//            case "movie":
//            case "episode":
//                playlistView.back.player.playing = false
//                playlistView.back.player.paused = false
//                break;
//            }
//            break;

        }

    }

    onErrorDetected: {
        errorView.addError(type, msg, info);
    }
}
