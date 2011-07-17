#include "ThumbImageProvider.h"

#include "QFat.h"

#include <QImageReader>

ThumbImageProvider::ThumbImageProvider(const QDir& basedir, const QSize& thumbSize, Qt::AspectRatioMode aspectRatioMode)
    : QDeclarativeImageProvider(QDeclarativeImageProvider::Image)
    , m_baseDir(basedir.path())
    , m_thumbSize(thumbSize)
    , m_thumbAspect(aspectRatioMode)
    , m_netmanager(new QNetworkAccessManager(this))
{
}

void showFatStatus(const QString& filename)
{
    FatError ret;

    QFat* fat = new QFat(filename);
    ret = fat->open();
    qDebug() << fat->status();
    fat->close();
}

QImage ThumbImageProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
    QImage pix;

    bool fromNetwork = false;
    QString fn;
    QUrl u(id);
    if (u.isValid() && !u.scheme().isEmpty() && u.scheme()!= "file") {
        fn = u.toString(QUrl::RemoveScheme).replace(":", "/");
        fromNetwork = true;
    } else {
        fn = id;
    }

    QStringList levels = fn.split("/");
    QString name = levels.takeLast();
    if (name.isEmpty())
        return pix;

    if (size)
        *size = m_thumbSize;

    QFile f(m_baseDir + fn);
    if (!f.exists()) {
        return QImage();
//        QString path = levels.join("/");

//        QDir d(m_baseDir + path);
//        if (!d.exists())
//            d.mkpath(m_baseDir + path);

//        if (fromNetwork) {
//            QByteArray ba;
//            if (sendBlockingNetRequest(u, ba)) {
//                QImage tmpPix;
//                tmpPix.loadFromData(ba);
//                pix = tmpPix.scaled(m_thumbSize, m_thumbAspect);
//            }
//        } else {
//            pix = QImage(fn).scaled(m_thumbSize, m_thumbAspect);
//        }

//        f.open(QIODevice::WriteOnly);
//        QBuffer buf;
//        buf.open(QIODevice::WriteOnly);
//        pix.save(&buf, "JPG");
//        f.write(buf.buffer());
////        qDebug() << id << " : " << buf.data().size();
//        f.close();
    } else {
//        qDebug() << "Reading thumb " << m_baseDir + fn;
        f.open(QIODevice::ReadOnly);
        QImageReader imageReader(&f);
        pix = imageReader.read();
        f.close();
    }

//    showFatStatus("c:/thumbs.fat");

    if (requestedSize.isValid() && requestedSize != *size) {
        return pix.scaled(requestedSize);
    }
    return pix;
}
