/****************************************************************************
 **
 ** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
 ** All rights reserved.
 ** Contact: Nokia Corporation (qt-info@nokia.com)
 **
 ** This file is part of the examples of the Qt Mobility Components.
 **
 ** $QT_BEGIN_LICENSE:BSD$
 ** You may use this file under the terms of the BSD license as follows:
 **
 ** "Redistribution and use in source and binary forms, with or without
 ** modification, are permitted provided that the following conditions are
 ** met:
 **   * Redistributions of source code must retain the above copyright
 **     notice, this list of conditions and the following disclaimer.
 **   * Redistributions in binary form must reproduce the above copyright
 **     notice, this list of conditions and the following disclaimer in
 **     the documentation and/or other materials provided with the
 **     distribution.
 **   * Neither the name of Nokia Corporation and its Subsidiary(-ies) nor
 **     the names of its contributors may be used to endorse or promote
 **     products derived from this software without specific prior written
 **     permission.
 **
 ** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 ** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 ** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 ** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 ** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 ** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 ** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 ** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 ** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 ** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 ** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
 ** $QT_END_LICENSE$
 **
 ****************************************************************************/

#include "thumbnailcache.h"

#include "VariantModel.h"

#include <QtCore/qcryptographichash.h>
#include <QtCore/qcoreapplication.h>
#include <QtCore/qcoreevent.h>

#include <QtCore/qdir.h>
#include <QtCore/qurl.h>
#include <QtGui/qimagereader.h>
#include <QtGui/qpixmap.h>

#if (QT_VERSION < QT_VERSION_CHECK(4, 7, 0))
uint qHash(const QUrl &url) { return qHash(url.toString()); }
#endif

class Thumbnail
{
public:
    Thumbnail(const QUrl &url, const QModelIndex& index)
        : url(url), index(index)
    {
    }

    const QUrl url;
    const QModelIndex index;

private:
    ThumbnailCache *cache;
};

class ThumbnailEvent : public QEvent
{
public:
    ThumbnailEvent(const QUrl &url, const QImage &image)
        : QEvent(QEvent::User)
        , url(url)
        , image(image)
    {
    }

    const QUrl url;
    const QImage image;
};

ThumbnailCache::ThumbnailCache(const QString& thumbDir, QObject *parent)
    : QObject(parent)
    , m_thumbDir(thumbDir)
{
    netmanager = new QNetworkAccessManager();
    connect(netmanager, SIGNAL(finished(QNetworkReply*)), this, SLOT(onRequestFinished(QNetworkReply*)), Qt::QueuedConnection);

    connect(this, SIGNAL(thumbnailRequested()), this, SLOT(onThumbnailRequested()), Qt::QueuedConnection);
}

ThumbnailCache::~ThumbnailCache()
{
    delete netmanager;
}

QString ThumbnailCache::thumbnail(const QUrl &url, const QModelIndex& index)
{
    QMutexLocker locker(&mutex);

    QString fn;
    QUrl u(url);
    if (u.isValid() && u.scheme() == "qrc")
        return url.toString();

    if (u.isValid() && !u.scheme().isEmpty() && u.scheme()!= "file") {
        fn = u.toString(QUrl::RemoveScheme | QUrl::RemoveUserInfo).replace(":", "/");
    } else {
        fn = url.toString();
    }

    QFile f(m_thumbDir + fn);
    if (!f.exists()) {
        pendingUrls.enqueue(url);

        cache.insert(url, new Thumbnail(url, index));

        emit thumbnailRequested();

        return "";
    } else
        return QString("image://thumb/%1").arg(url.toString());
}

bool ThumbnailCache::saveThumb(const QUrl& url, const QImage& image)
{
    if (Thumbnail *thumbnail = cache.object(url)) {
        QMutexLocker locker(&mutex);

        QString fn;
        QUrl u(thumbnail->url);
        if (u.isValid() && !u.scheme().isEmpty() && u.scheme()!= "file") {
            fn = u.toString(QUrl::RemoveScheme | QUrl::RemoveUserInfo).replace(":", "/");
        } else {
            fn = u.toString();
        }

        QStringList levels = fn.split("/");
        QString name = levels.takeLast();
        if (name.isEmpty())
            return true;

        QString path = levels.join("/");

        QDir d(m_thumbDir + path);
        if (!d.exists())
            d.mkpath(m_thumbDir + path);

        QFile f(m_thumbDir + fn);
        if (!f.open(QIODevice::WriteOnly))
            qDebug() << "Error writing thumb to " << m_thumbDir + fn;
        else {
            QBuffer buf;
            buf.open(QIODevice::WriteOnly);
            image.save(&buf, "JPG");
            f.write(buf.buffer());
            //        qDebug() << id << " : " << buf.data().size();
            f.close();

            emit thumbnailReady(thumbnail->index);
        }
    }
    return true;
}

void ThumbnailCache::onThumbnailRequested()
{
    if (!pendingUrls.isEmpty()) {
        const QUrl url = pendingUrls.dequeue();

        if (cache.contains(url)) {
            QImage image = getImage(url);
            if (!image.isNull())
                saveThumb(url, image);
        }
    }

}

QImage ThumbnailCache::loadImage(QImageReader &reader) const
{
//    reader.setQuality(75);

    if (reader.supportsOption(QImageIOHandler::Size)) {
        QSize size = reader.size();

        if (!reader.supportsOption(QImageIOHandler::ScaledSize)
                && (size.width() > 1280 || size.height() > 1280)) {
            return QImage();
        }

        if (size.width() > VariantModel::thumbnailSize.width()
                || size.height() > VariantModel::thumbnailSize.height()) {
            size.scale(VariantModel::thumbnailSize, Qt::KeepAspectRatioByExpanding);
        }

        reader.setScaledSize(size);
    } else {
        reader.setScaledSize(VariantModel::thumbnailSize);
    }

    return reader.read();
}

QImage ThumbnailCache::getImage(const QUrl &url) const
{
    if (url.scheme().isEmpty() || url.scheme() == "file") {
        const QString fileName = url.toLocalFile();
        QImageReader reader(fileName);

        return loadImage(reader);
    } else {
        netmanager->get(QNetworkRequest(url));
        return QImage();
    }
}

void ThumbnailCache::onRequestFinished(QNetworkReply *reply)
{
    if (reply->error() != QNetworkReply::NoError)
        return;

//    QList<QNetworkReply::RawHeaderPair> rawH =  reply->rawHeaderPairs();
//    foreach (QNetworkReply::RawHeaderPair p, rawH)
//        qDebug() << p.first << " : " << p.second;
    QImageReader reader(reply);
    QImage image = loadImage(reader);
    if (!image.isNull())
        saveThumb(reply->url(), image);
}

/************* ThumbnailCacheThread ************************/

ThumbnailCacheThread::ThumbnailCacheThread(const QString &thumbDir, QObject *parent)
    : QThread(parent)
    , m_thumbDir(thumbDir)
{
}

void ThumbnailCacheThread::run()
{
    m_cache = new ThumbnailCache(m_thumbDir);
    connect(m_cache, SIGNAL(thumbnailReady(QModelIndex)), this, SIGNAL(thumbnailReady(QModelIndex)), Qt::QueuedConnection);

    QThread::run();

    delete m_cache;
}

QString ThumbnailCacheThread::thumbnail(const QUrl &url, const QModelIndex& index)
{
    return m_cache->thumbnail(url, index);
}
