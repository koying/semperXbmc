#include <QtGui/QApplication>
#include "qmlapplicationviewer.h"

#include <QtDeclarative/QDeclarativeComponent>
#include <QtDeclarative/QDeclarativeEngine>
#include <QtDeclarative/QDeclarativeContext>

#include <QSettings>
#include "src/config.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QSettings settings("xbmc", "remote");
    if (!(settings.contains("server") && settings.contains("port"))) {
        Config *config = new Config();
        if (config->exec()) {
            settings.setValue("server", config->getServer());
            settings.setValue("port", config->getPort());
        }
        else {
            exit(1);
        }
    }

    QmlApplicationViewer viewer;
    viewer.engine()->rootContext()->setContextProperty("_server", settings.value("server", "127.0.0.1").toString());
    viewer.engine()->rootContext()->setContextProperty("_port", settings.value("port", 6780).toInt());
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/semperXbmc/remote.qml"));
    viewer.showExpanded();

    return app.exec();
}
