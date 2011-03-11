#include <QtGui/QApplication>
#include "qmlapplicationviewer.h"

#include "XbmcEventClient.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    qmlRegisterType<XbmcEventClient>("XbmcEvents", 1, 0, "XbmcClient");

    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/semperXbmc/main.qml"));
    viewer.showExpanded();

    return app.exec();
}
