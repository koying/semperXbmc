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
        if (data) {
            var item = data.item;
            if (item) {
                for (var attrname in item) { data[attrname] = item[attrname]; }
            }
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

        case "Playlist.OnAdd":
        case "Playlist.OnRemove":
        case "Playlist.OnClear":
            switch (data.playlistid) {
            case $().playlist.audioPlId:
                playlistTab.audioPage().refresh()
                break
            case $().playlist.videoPlId:
                playlistTab.videoPage().refresh()
                break
            }

            break;

        case "Input.OnInputRequested":
            remoteTab.keyboardRequest(data.title, data.value)
            break;

        case "Input.OnInputFinished":
            remoteTab.keyboardDone()
            break;

        case "Player.OnPlay":
        case "Player.OnPause":
            switch(data.type) {
            case "song":
                playlistTab.audioPlayer().refresh()
                break;
            case "movie":
            case "episode":
                playlistTab.videoPlayer().refresh()
                break;
            }
            break;

        case "Player.OnStop":
            switch(data.type) {
            case "song": {
                playlistTab.audioPlayer().position = -1;
                playlistTab.audioPlayer().percentage = -1;
                playlistTab.audioPlayer().speed = -255;

                break;
            }
            case "movie":
            case "episode": {
                playlistTab.videoPlayer().position = -1;
                playlistTab.videoPlayer().percentage = -1;
                playlistTab.videoPlayer().speed = -255;

                break;
            }
            }
            break;
        }

    }

    onErrorDetected: {
        errorView.addError(type, msg, info);
    }
}
