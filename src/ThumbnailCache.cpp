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
    QPixmap pixmap;

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

ThumbnailCache::ThumbnailCache(QObject *parent)
    : QThread(parent)
    , cache(150)
    , cancelled(false)
{
    start(QThread::LowestPriority);
}

ThumbnailCache::~ThumbnailCache()
{
    {
        QMutexLocker locker(&mutex);

        cancelled = true;

        waitCondition.wakeOne();
    }
    wait();
}

QPixmap ThumbnailCache::thumbnail(const QUrl &url, const QModelIndex& index)
{
    QMutexLocker locker(&mutex);

    if (Thumbnail *thumbnail = cache.object(url)) {
        return thumbnail->pixmap;
    } else {
        pendingUrls.enqueue(url);

        cache.insert(url, new Thumbnail(url, index));

        waitCondition.wakeOne();

        return QPixmap();
    }
}

bool ThumbnailCache::event(QEvent *event)
{
    if (event->type() == QEvent::User) {
        ThumbnailEvent *thumbnailEvent = static_cast<ThumbnailEvent *>(event);

        QMutexLocker locker(&mutex);

        if (Thumbnail *thumbnail = cache.object(thumbnailEvent->url)) {
            thumbnail->pixmap = QPixmap::fromImage(thumbnailEvent->image);

            locker.unlock();

            emit thumbnailReady(thumbnail->index);
        }
        return true;
    } else {
        return QThread::event(event);
    }
}

void ThumbnailCache::run()
{
    QMutexLocker locker(&mutex);

    netmanager = new QNetworkAccessManager();
    connect(netmanager, SIGNAL(finished(QNetworkReply*)), SLOT(requestFinished(QNetworkReply*)));

    while(!cancelled) {
        if (!pendingUrls.isEmpty()) {
            const QUrl url = pendingUrls.dequeue();

            if (cache.contains(url)) {
                locker.unlock();
                QImage image = getImage(url);
                locker.relock();

                if (!image.isNull())
                    QCoreApplication::postEvent(this, new ThumbnailEvent(url, image));
            }
        } else {
            waitCondition.wait(&mutex);
        }
    }

    delete netmanager;
}

QImage ThumbnailCache::loadImage(QImageReader &reader) const
{
    reader.setQuality(25);

    if (reader.supportsOption(QImageIOHandler::Size)) {
        QSize size = reader.size();

        if (!reader.supportsOption(QImageIOHandler::ScaledSize)
                && (size.width() > 1280 || size.height() > 1280)) {
            return QImage();
        }

        if (size.width() > VariantModel::thumbnailSize.width()
                || size.height() > VariantModel::thumbnailSize.height()) {
            size.scale(VariantModel::thumbnailSize, Qt::KeepAspectRatio);
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

void ThumbnailCache::requestFinished(QNetworkReply *reply)
{
    if (reply->error() != QNetworkReply::NoError)
        return;

    QImageReader reader(reply);
    QImage image = loadImage(reader);
    if (!image.isNull())
        QCoreApplication::postEvent(this, new ThumbnailEvent(reply->url(), image));
}
