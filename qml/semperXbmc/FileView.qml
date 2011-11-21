import QtQuick 1.0
import com.nokia.symbian 1.0
import com.semperpax.qmlcomponents 1.0
import "components" as Cp;

import "js/Utils.js" as Utils

Page {
    id: page
    property string curDir

    tools:  ToolBarLayout {

        ToolButton {
            iconSource: "toolbar-back"
            onClicked: fileStack.pop()
            visible: fileStack.depth > 1
        }

//        ToolButton {
//            id: btFilter
//            checkable: true
//            iconSource: "img/filter.svg"
//        }

//        ToolButton {
//            iconSource: "toolbar-menu"
//            onClicked: pgMenu.open()
//        }
    }

//    Menu {
//        id: pgMenu
//        content: MenuLayout {

//            MenuItem {
//                text:  "View"
//                platformSubItemIndicator: true
//                onClicked: viewMenu.open()
//            }

//            MenuItem {
//                text:  "Style"
//                platformSubItemIndicator: true
//                onClicked: styleMenu.open()
//            }
//            MenuItem {
//                text:  "Refresh"
//                onClicked: refresh()
//            }
//        }
//    }

    ListView {
        id: fileList
        anchors.fill: parent
        clip: true
        highlightMoveDuration: 300

        model: fileModel
        delegate: fileDelegate

        cacheBuffer: 800
    }

    ScrollDecorator {
        id: scrolldecorator
        flickableItem: fileList
    }

    Component {
        id: fileDelegate

        Cp.Delegate {
            title: model.name
            image: model.filetype == "directory" ? "img/folder.png" : ""

            style: globals.styleFiles

            onSelected:  {
                if (model.filetype == "directory")
                    fileStack.push(Qt.resolvedUrl("FileView.qml"), {curDir: model.path})
                else {
                    $().videoplayer.playFile(model.path);
                    mainTabGroup.currentTab = remoteTab
                }
            }
        }
    }

    VariantModel {
        id: fileModel
        fields: [ "name", "path", "filetype" ]
    }

    onCurDirChanged: {
        albumModel.clear();
        console.debug(curDir);
        if (curDir != "/")
            $().library.loadFiles(fileModel, curDir);
        else
            $().library.loadSources(fileModel);
    }
}
