#include <QtGui/QApplication>
#include <QtDeclarative>
#include <QFile>

#include "qmlapplicationviewer.h"
#include "networkaccessmanagerfactory.h"

#include "XbmcEventClient.h"
#include "QFatFs.h"
#include "ThumbImageProvider.h"
#include "VariantModel.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QFatFsHandler* fatHandler = new QFatFsHandler(50000, 8192);

    qmlRegisterType<XbmcEventClient>("com.semperpax.qmlcomponents", 1, 0, "XbmcClient");
    qmlRegisterType<VariantModel>("com.semperpax.qmlcomponents", 1, 0, "VariantModel");
//    qmlRegisterType<SortFilterModel>("com.semperpax.qmlcomponents", 1, 0, "SortFilterModel");

    NetworkAccessManagerFactory factory;

    QmlApplicationViewer viewer;
    viewer.engine()->setNetworkAccessManagerFactory(&factory);
#ifdef Q_OS_SYMBIAN
    ThumbImageProvider* thumbProvider = new ThumbImageProvider(QDir("fat:///c:/data/semperXbmcThumbs.fat#/"), QSize(150, 150), Qt::KeepAspectRatioByExpanding);
//    ThumbImageProvider* thumbProvider = new ThumbImageProvider(QDir("fat:///" + QDesktopServices::storageLocation(QDesktopServices::DataLocation) + "/semperXbmcThumbs.fat#/"), QSize(100, 100), Qt::KeepAspectRatioByExpanding);
#else
    ThumbImageProvider* thumbProvider = new ThumbImageProvider(QDir("fat:///c:/semperXbmcThumbs.fat#/"), QSize(150, 150), Qt::KeepAspectRatioByExpanding);
#endif
    viewer.engine()->addImageProvider(QLatin1String("thumb"), static_cast<QDeclarativeImageProvider*>(thumbProvider));

    viewer.setMainQmlFile(QLatin1String("qml/semperXbmc/main.qml"));
    viewer.showExpanded();

    int retval = app.exec();

    // Clear the cache at exit
    viewer.engine()->networkAccessManager()->cache()->clear();

    viewer.engine()->removeImageProvider(QLatin1String("thumb"));
//    delete thumbProvider;
//    delete fatHandler;

//#ifdef Q_OS_SYMBIAN
//    QFile::remove("c:/data/semperXbmcThumbs.fat");
//#else
//    QFile::remove("c:/semperXbmcThumbs.fat");
//#endif

//#ifndef Q_OS_SYMBIAN
//    QFat* fat = new QFat("c:/semperXbmcThumbs.fat");
//    fat->open();
//    qDebug() << fat->fileName();
//    qDebug() << fat->status();
//    fat->close();
//#endif

    return retval;
}
