#include "ThumbImageProvider.h"

#include "QFat.h"

ThumbImageProvider::ThumbImageProvider(const QDir& basedir, const QSize& thumbSize, Qt::AspectRatioMode aspectRatioMode)
    : QDeclarativeImageProvider(QDeclarativeImageProvider::Image)
    , m_baseDir(basedir.path())
    , m_thumbSize(thumbSize)
    , m_thumbAspect(aspectRatioMode)
{
}

bool ThumbImageProvider::sendBlockingNetRequest(const QUrl& theUrl, QByteArray& reply)
{
    QNetworkAccessManager manager;
    QEventLoop q;
    QTimer tT;

//    manager.setProxy(M_PREFS->getProxy(QUrl("http://merkaartor.be")));

    tT.setSingleShot(true);
    connect(&tT, SIGNAL(timeout()), &q, SLOT(quit()));
    connect(&manager, SIGNAL(finished(QNetworkReply*)),
            &q, SLOT(quit()));

    QNetworkReply *netReply = manager.get(QNetworkRequest(theUrl));

    tT.start(30000);
    q.exec();
    if(tT.isActive()) {
        // download complete
        tT.stop();
    } else {
        return false;
    }

    reply = netReply->readAll();
    return true;
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
    QStringList levels = id.split("/");
    QString name = levels.takeLast();
    if (name.isEmpty())
        return pix;

    if (size)
        *size = m_thumbSize;

    QFile f;
    bool fromNetwork = false;
    QUrl u(id);
    if (u.isValid() && !u.scheme().isEmpty() && u.scheme()!= "file") {
        f.setFileName(m_baseDir + u.toString(QUrl::RemoveScheme | QUrl::RemoveAuthority).replace(":", ""));
        qDebug() << f.fileName();
        fromNetwork = true;
    } else {
        f.setFileName(m_baseDir + id);
    }
    if (!f.exists()) {
        QString path = levels.join("/");

        QDir d(m_baseDir + path);
        if (!d.exists())
            d.mkpath(m_baseDir + path);

        if (fromNetwork) {
            QByteArray ba;
            if (sendBlockingNetRequest(u, ba))
                pix.loadFromData(ba);
        } else {
            pix = QImage(id).scaled(m_thumbSize, m_thumbAspect);
        }

        f.open(QIODevice::WriteOnly);
        QBuffer buf;
        buf.open(QIODevice::WriteOnly);
        pix.save(&buf, "PNG");
        f.write(buf.buffer());
//        qDebug() << id << " : " << buf.data().size();
        f.close();
    } else {
        f.open(QIODevice::ReadOnly);
        QByteArray ba;
        ba = f.readAll();
        pix.loadFromData(ba);
        f.close();
    }

//    showFatStatus("c:/thumbs.fat");

    if (requestedSize.isValid() && requestedSize != *size) {
        return pix.scaled(requestedSize);
    }
    return pix;
}
