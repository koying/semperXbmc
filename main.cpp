#include <QtGui/QApplication>
#include <QtDeclarative>
#include <QFile>

#include "qmlapplicationviewer.h"
#include "networkaccessmanagerfactory.h"

#include "XbmcEventClient.h"
#include "XbmcTcpTransport.h"
#include "QFatFs.h"
#include "ThumbImageProvider.h"
#include "VariantModel.h"
#include "SortFilterModel.h"

#define QUOTE_(x) #x
#define QUOTE(x) QUOTE_(x)

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QFatFsHandler* fatHandler = new QFatFsHandler(50000, 8192);

    qmlRegisterType<XbmcEventClient>("com.semperpax.qmlcomponents", 1, 0, "XbmcEventClient");
    qmlRegisterType<XbmcTcpTransport>("com.semperpax.qmlcomponents", 1, 0, "XbmcJsonTcpClient");
    qmlRegisterType<VariantModel>("com.semperpax.qmlcomponents", 1, 0, "VariantModel");
    qmlRegisterType<SortFilterModel>("com.semperpax.qmlcomponents", 1, 0, "SortFilterModel");
//    qmlRegisterType<SortFilterModel>("com.semperpax.qmlcomponents", 1, 0, "SortFilterModel");

    NetworkAccessManagerFactory factory;

    QmlApplicationViewer* viewer = new QmlApplicationViewer;
    viewer->engine()->setNetworkAccessManagerFactory(&factory);

    QString thumbFile("fat:///c:/data/semperXbmcThumbs.fat#/");
    ThumbImageProvider* thumbProvider = new ThumbImageProvider(QDir(thumbFile), QSize(150, 150), Qt::KeepAspectRatioByExpanding);
//    ThumbImageProvider* thumbProvider = new ThumbImageProvider(QDir("fat:///" + QDesktopServices::storageLocation(QDesktopServices::DataLocation) + "/semperXbmcThumbs.fat#/"), QSize(100, 100), Qt::KeepAspectRatioByExpanding);
    viewer->rootContext()->setContextProperty("thumbFile", thumbFile);

    QString appVersion = QUOTE(APP_VERSION);
    viewer->rootContext()->setContextProperty("appVersion", appVersion);

    viewer->engine()->addImageProvider(QLatin1String("thumb"), static_cast<QDeclarativeImageProvider*>(thumbProvider));

    viewer->setMainQmlFile(QLatin1String("qml/semperXbmc/main.qml"));
    viewer->showExpanded();

    int retval = app.exec();

    // Clear the cache at exit
    viewer->engine()->networkAccessManager()->cache()->clear();

    viewer->engine()->removeImageProvider(QLatin1String("thumb"));

    delete viewer;
    delete fatHandler;

#ifndef Q_OS_SYMBIAN
//    QFat* fat = new QFat("c:/data/semperXbmcThumbs.fat");
//    fat->open();
//    qDebug() << fat->fileName();
//    qDebug() << fat->status();
//    fat->close();
//    delete fat;

//    QFile::remove("c:/data/semperXbmcThumbs.fat");
#endif

    return retval;
}
