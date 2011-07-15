#ifndef THUMBIMAGEPROVIDER_H
#define THUMBIMAGEPROVIDER_H

#include <QDeclarativeImageProvider>

#include <QDir>
#include <QtNetwork>

class ThumbImageProvider : public QObject, public QDeclarativeImageProvider
{
    Q_OBJECT
public:
    ThumbImageProvider(const QDir& basedir, const QSize& thumbSize, Qt::AspectRatioMode aspectRatioMode);

    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize);

    bool sendBlockingNetRequest(const QUrl &theUrl, QByteArray &reply);
protected:
    QString m_baseDir;
    QSize m_thumbSize;
    Qt::AspectRatioMode m_thumbAspect;
    QNetworkAccessManager* m_netmanager;
};

#endif // THUMBIMAGEPROVIDER_H
