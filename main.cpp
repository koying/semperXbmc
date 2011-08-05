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
#ifndef __NOWEBKIT
#include "BrowserView.h"
#endif
#include "Haptics.h"

#define QUOTE_(x) #x
#define QUOTE(x) QUOTE_(x)

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QString appVersion = QUOTE(APP_VERSION);

    QCoreApplication::setApplicationName("semperXbmc");
    QCoreApplication::setOrganizationName("SemperPax");
    QCoreApplication::setOrganizationDomain("semperpax.com");
    QCoreApplication::setApplicationVersion(appVersion);

    QFatFsHandler* fatHandler = new QFatFsHandler(50000, 8192);

#ifndef __NOWEBKIT
    //    QWebSettings::globalSettings()->setObjectCacheCapacities(128*1024, 1024*1024, 1024*1024);
    QWebSettings::globalSettings()->setMaximumPagesInCache(3);
    QWebSettings::globalSettings()->setAttribute(QWebSettings::JavascriptEnabled, true);
    QWebSettings::globalSettings()->setAttribute(QWebSettings::PluginsEnabled, true);
    //    QWebSettings::globalSettings()->setAttribute(QWebSettings::TiledBackingStoreEnabled, true);
    QWebSettings::globalSettings()->setAttribute(QWebSettings::FrameFlatteningEnabled, true);
    QWebSettings::globalSettings()->setFontSize(QWebSettings::MinimumFontSize, 10);
    QWebSettings::globalSettings()->enablePersistentStorage();

    qmlRegisterType<BrowserView>("com.semperpax.qmlcomponents", 1, 0, "BrowserView");
#else
#endif
    qmlRegisterType<XbmcEventClient>("com.semperpax.qmlcomponents", 1, 0, "XbmcEventClient");
    qmlRegisterType<XbmcTcpTransport>("com.semperpax.qmlcomponents", 1, 0, "XbmcJsonTcpClient");
    qmlRegisterType<VariantModel>("com.semperpax.qmlcomponents", 1, 0, "VariantModel");
    qmlRegisterType<SortFilterModel>("com.semperpax.qmlcomponents", 1, 0, "SortFilterModel");
    qmlRegisterType<Haptics>("com.semperpax.qmlcomponents", 1, 0, "Haptics");

#ifdef __ING
    QNetworkProxy myProxy(QNetworkProxy::HttpProxy, "localhost", 8888);
    QNetworkProxy::setApplicationProxy(myProxy);
#endif
    QmlApplicationViewer* viewer = new QmlApplicationViewer;

    //Find FAT file
    QString fatFilename;
    if (QFile::exists("e:/semperXbmc.fat"))
        fatFilename = "e:/semperXbmc.fat";
    else if (QFile::exists("c/data:/semperXbmc.fat"))
        fatFilename = "c/data:/semperXbmc.fat";
    else if (QFile::exists("c/data:/semperXbmcThumbs.fat"))
        fatFilename = "c/data:/semperXbmcThumbs.fat";

    //Not found? create one...
    if (fatFilename.isEmpty()) {
        if (QDir("e:/").exists())
            fatFilename = "e:/semperXbmc.fat";
        else
            fatFilename = "c/data:/semperXbmc.fat";
    }
    QString fatFile = QString("fat:///%1#/").arg(fatFilename);

    ThumbImageProvider* thumbProvider = new ThumbImageProvider(QDir(fatFile), QSize(150, 150), Qt::KeepAspectRatioByExpanding);
//    ThumbImageProvider* thumbProvider = new ThumbImageProvider(QDir("fat:///" + QDesktopServices::storageLocation(QDesktopServices::DataLocation) + "/semperXbmcThumbs.fat#/"), QSize(100, 100), Qt::KeepAspectRatioByExpanding);

    viewer->rootContext()->setContextProperty("ctxFatFile", fatFile);
    viewer->rootContext()->setContextProperty("ctxAppVersion", appVersion);
#ifndef __NOWEBKIT
    viewer->rootContext()->setContextProperty("ctxHasBrowser", true);
#else
    viewer->rootContext()->setContextProperty("ctxHasBrowser", false);
#endif

    viewer->engine()->addImageProvider(QLatin1String("thumb"), static_cast<QDeclarativeImageProvider*>(thumbProvider));

    viewer->setMainQmlFile(QLatin1String("qml/semperXbmc/main.qml"));
    viewer->showExpanded();

    int retval = app.exec();

    viewer->engine()->removeImageProvider(QLatin1String("thumb"));

    delete viewer;
    delete fatHandler;

//#ifndef Q_OS_SYMBIAN
//    QFat* fat = new QFat("c:/data/semperXbmcThumbs.fat");
//    fat->open();
//    qDebug() << fat->fileName();
//    qDebug() << fat->status();
//    fat->close();
//    delete fat;
//#endif

    return retval;
}
