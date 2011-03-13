#include <QtGui/QApplication>
#include <QtDeclarative>

#include "qmlapplicationviewer.h"
#include "networkaccessmanagerfactory.h"

#include "XbmcEventClient.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    qmlRegisterType<XbmcEventClient>("XbmcEvents", 1, 0, "XbmcClient");

    NetworkAccessManagerFactory factory;

    QmlApplicationViewer viewer;
    viewer.engine()->setNetworkAccessManagerFactory(&factory);

    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockPortrait);
    viewer.setMainQmlFile(QLatin1String("qml/semperXbmc/main.qml"));
    viewer.showExpanded();

    int retval = app.exec();

    // Clear the cache at exit
    viewer.engine()->networkAccessManager()->cache()->clear();

    return retval;
}
