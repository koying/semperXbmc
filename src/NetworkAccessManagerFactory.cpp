#include "networkaccessmanagerfactory.h"
#include <QtNetwork>
#include <QDesktopServices>

NetworkAccessManagerFactory::NetworkAccessManagerFactory() : QDeclarativeNetworkAccessManagerFactory()
{
}

QNetworkAccessManager* NetworkAccessManagerFactory::create(QObject* parent)
{
    QNetworkAccessManager* manager = new QNetworkAccessManager(parent);
    QNetworkDiskCache* diskCache = new QNetworkDiskCache(parent);

    // Get a default system directory for storing cache data
    QString dataPath =
        QDesktopServices::storageLocation(QDesktopServices::CacheLocation);

    // Make sure that the directory exists
    QDir().mkpath(dataPath);
    diskCache->setCacheDirectory(dataPath);

    // Set cache size to max 2 megabytes
    diskCache->setMaximumCacheSize(2*1024*1024);
    manager->setCache(diskCache);
    return manager;
}
