#include "Download.h"

#include <QDir>
#include <QVariant>
#include <QDebug>

Download::Download(QObject *parent)
    : QObject(parent)
    , m_progress(0)
    , m_isActive(false)
    , m_isFinished(false)
    , m_errorCode(0)
{
    m_netmanager = new QNetworkAccessManager(this);
}

void Download::go()
{
    m_outputFile = new QFile(m_outputPath+"/"+m_filename);
    if (!m_outputFile) {
        m_errorCode = 4;
        m_isFinished = true;
        emit finishedChanged();
        return;
    }

    if (!m_outputFile->open(QIODevice::WriteOnly)) {
        m_errorCode = 5;
        emit finishedChanged();
        return;
    }

    QUrl u = QUrl::fromUserInput(m_inputPath);
    qDebug() << m_inputPath;
    m_reply = m_netmanager->get(QNetworkRequest(u));
    if (!m_reply) {
        m_errorCode = 6;
        m_isFinished = true;
        emit finishedChanged();
        return;
    }

    connect(m_reply, SIGNAL(readyRead()), SLOT(onReadyData()));
    connect(m_reply, SIGNAL(downloadProgress(qint64,qint64)), SLOT(onDownloadProgress(qint64,qint64)));
    connect(m_reply, SIGNAL(finished()), this, SLOT(onFinished()));

    m_isActive = true;
    m_isFinished = false;
    emit activeChanged();
    emit finishedChanged();
}

void Download::onFinished()
{
    m_outputFile->close();

//    for (int i=0; i<m_reply->rawHeaderPairs().size(); ++i) {
//        qDebug() << m_reply->rawHeaderPairs().at(i).first << "=" << m_reply->rawHeaderPairs().at(i).second;
//    }
    QVariant mimetype = m_reply->header(QNetworkRequest::ContentTypeHeader);
    if (mimetype.isValid()) {
        QString ext;
        QString sMimetype = mimetype.toString();

        if (sMimetype.contains("audio/aiff")) ext = ".aif";
        else if (sMimetype.contains("video/x-ms-asf")) ext = ".asf";
        else if (sMimetype.contains("video/avi")) ext = ".avi";
        else if (sMimetype.contains("video/avs-video")) ext = ".avs";
        else if (sMimetype.contains("application/octet-stream")) ext = ".bin";
        else if (sMimetype.contains("image/bmp")) ext = ".bmp";
        else if (sMimetype.contains("video/x-dv")) ext = ".dv";
        else if (sMimetype.contains("video/fli")) ext = ".fli";
        else if (sMimetype.contains("image/gif")) ext = ".gif";
        else if (sMimetype.contains("text/html")) ext = ".html";
        else if (sMimetype.contains("image/x-icon")) ext = ".ico";
        else if (sMimetype.contains("audio/it")) ext = ".it";
        else if (sMimetype.contains("image/jpeg")) ext = ".jpg";
        else if (sMimetype.contains("application/json")) ext = ".json";
        else if (sMimetype.contains("audio/midi")) ext = ".kar";
        else if (sMimetype.contains("audio/x-mpequrl")) ext = ".m3u";
        else if (sMimetype.contains("audio/midi")) ext = ".mid";
        else if (sMimetype.contains("video/x-matroska")) ext = ".mkv";
        else if (sMimetype.contains("audio/mod")) ext = ".mod";
        else if (sMimetype.contains("video/quicktime")) ext = ".mov";
        else if (sMimetype.contains("audio/mpeg3")) ext = ".mp3";
        else if (sMimetype.contains("audio/mpeg")) ext = ".mpa";
        else if (sMimetype.contains("video/mpeg")) ext = ".mpg";
        else if (sMimetype.contains("image/x-pcx")) ext = ".pcx";
        else if (sMimetype.contains("image/png")) ext = ".png";
        else if (sMimetype.contains("audio/x-pn-realaudio")) ext = ".rm";
        else if (sMimetype.contains("audio/s3m")) ext = ".s3m";
        else if (sMimetype.contains("audio/x-psid")) ext = ".sid";
        else if (sMimetype.contains("image/tiff")) ext = ".tif";
        else if (sMimetype.contains("text/plain")) ext = ".txt";
        else if (sMimetype.contains("text/uri-list")) ext = ".uni";
        else if (sMimetype.contains("video/vivo")) ext = ".viv";
        else if (sMimetype.contains("audio/wav")) ext = ".wav";
        else if (sMimetype.contains("audio/xm")) ext = ".xm";
        else if (sMimetype.contains("text/xml")) ext = ".xml";
        else if (sMimetype.contains("application/zip")) ext = ".zip";
        else if (sMimetype.contains("image/jpeg")) ext = ".tbn";
        else if (sMimetype.contains("application/javascript")) ext = ".js";
        else if (sMimetype.contains("text/css")) ext = ".css";

        m_outputFile->rename(m_outputFile->fileName() + ext);
    }

    m_reply->deleteLater();
    m_isActive = false;
    m_isFinished = true;
    emit activeChanged();
    emit finishedChanged();
}

void Download::onReadyData()
{
    m_outputFile->write(m_reply->readAll());
}

void Download::onDownloadProgress(qint64 bytesReceived, qint64 bytesTotal)
{
    if (bytesTotal == 0) {
        m_progress = 0;
        return;
    }

    qreal p = (qreal)bytesReceived / bytesTotal * 100;
    if (p != m_progress) {
        m_progress = p;
        emit progressChanged();
    }
}

void Download::onError(QNetworkReply::NetworkError code)
{
    m_errorCode = 500 + code;
    m_isActive = false;
    m_isFinished = true;
    emit activeChanged();
    emit finishedChanged();
}

void Download::setInputPath(QString val)
{
    m_inputPath = val;
    m_isFinished = false;

    if (m_inputPath.isEmpty() || m_outputPath.isEmpty()) {
        m_errorCode = 1;
        m_isActive = false;
        m_isFinished = true;
        emit activeChanged();
        emit finishedChanged();
        return;
    }

    if (!m_inputPath.startsWith("http://")) {
        m_errorCode = 2;
        m_isActive = false;
        m_isFinished = true;
        emit activeChanged();
        emit finishedChanged();
        return;
    }

    QUrl u(m_inputPath);
    if (!u.isValid()) {
        m_errorCode = 3;
        m_isActive = false;
        m_isFinished = true;
        emit activeChanged();
        emit finishedChanged();
        return;
    }
}

void Download::setOutputPath(QString val)
{
    m_outputPath = val;
    m_isFinished = false;

    QDir d(m_outputPath);
    if (!d.exists()) {
        d.mkpath(m_outputPath);
    }
}

void Download::setFilename(QString val)
{
    m_filename = val;

    emit FilenameChanged();
}
