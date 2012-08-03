import QtQuick 1.0
import com.semperpax.qmlcomponents 1.0
import com.nokia.symbian 1.1

import "js/Utils.js" as Utils

Item {
    id: wrapper

    property int episodeId

    anchors.fill: parent

    Row {
        id: flagRow

        Image {
            id: imHD
            height: 48
            fillMode: Image.PreserveAspectFit
        }
        Image {
            id: imAspect
            height: 48
            fillMode: Image.PreserveAspectFit
        }
        Image {
            id: imCodec
            height: 48
            fillMode: Image.PreserveAspectFit
        }
    }

    Flickable {
        anchors {bottom: parent.bottom; right: parent.right; left: parent.left; top: flagRow.bottom }
        contentWidth: plot.width; contentHeight:  plot.height
        clip: true

        Text {
            id: plot
            width: wrapper.width

            color: "#ffffff"
            font.pixelSize: 18
            wrapMode: Text.WordWrap
        }
    }


    onEpisodeIdChanged: {
        var doc = new globals.getJsonXMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.DONE) {
//                console.debug(doc.responseText)
                var oJSON = JSON.parse(doc.responseText);

                var result = oJSON.result
                var details = result.episodedetails

                plot.text = details.plot
                if (details.streamdetails && details.streamdetails.video) {
                    var asp = details.streamdetails.video[0].aspect;
                    if (asp < 1.66)
                        imAspect.source = "flagging/aspectratio/1.33.png"
                    else if (asp < 1.78)
                        imAspect.source = "flagging/aspectratio/1.66.png"
                    else if (asp < 1.85)
                        imAspect.source = "flagging/aspectratio/1.78.png"
                    else if (asp < 2.0)
                        imAspect.source = "flagging/aspectratio/1.85.png"
                    else if (asp < 2.3)
                        imAspect.source = "flagging/aspectratio/2.20.png"
                    else if (asp < 2.5)
                        imAspect.source = "flagging/aspectratio/2.35.png"
                    imHD.source = details.streamdetails.video[0].height >= 530 ? "flagging/lists/720.png" : "flagging/lists/480.png"
                    if (details.streamdetails.video[0].codec && details.streamdetails.video[0].codec != "")
                        imCodec.source = "flagging/video/" + details.streamdetails.video[0].codec + ".png"
                }
            }
        }

        var o = { jsonrpc: "2.0", method: "VideoLibrary.GetEpisodeDetails", params: { episodeid: wrapper.episodeId, properties: ["streamdetails", "plot"] }, id:1}
        var cmd = JSON.stringify(o)
        console.debug(cmd)
        doc.send(cmd);
    }
}
