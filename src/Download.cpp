#include "Download.h"

#include <QDir>

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
    m_errorCode = 0;
    m_isFinished = false;
    m_progress = 0;

    if (m_inputPath.isEmpty() || m_outputPath.isEmpty()) {
        m_errorCode = 1;
        m_isFinished = true;
        emit finished();
        return;
    }

    if (!m_inputPath.startsWith("http://")) {
        m_errorCode = 2;
        m_isFinished = true;
        emit finished();
        return;
    }

    QUrl u(m_inputPath);
    if (!u.isValid()) {
        m_errorCode = 3;
        m_isFinished = true;
        emit finished();
        return;
    }
    m_title = u.path().section('/', -1);
    emit TitleChanged();

    QDir d(m_outputPath);
    if (!d.exists()) {
        d.mkpath(m_outputPath);
    }

    m_outputFile = new QFile(m_outputPath+"/"+m_outputFilename);
    if (!m_outputFile) {
        m_errorCode = 4;
        m_isFinished = true;
        emit finished();
        return;
    }

    if (!m_outputFile->open(QIODevice::WriteOnly)) {
        m_errorCode = 5;
        emit finished();
        return;
    }

    QNetworkReply* m_reply = m_netmanager->get(QNetworkRequest(u));
    if (!m_reply) {
        m_errorCode = 6;
        m_isFinished = true;
        emit finished();
        return;
    }

    connect(m_reply, SIGNAL(readyRead()), SLOT(onReadyData()));
    connect(m_reply, SIGNAL(downloadProgress(qint64,qint64)), SLOT(onDownloadProgress(qint64,qint64)));
    connect(m_reply, SIGNAL(finished()), this, SLOT(onFinished()));

    m_isActive = true;
    emit activated();
}

void Download::onFinished()
{
    m_outputFile->close();
    m_reply->deleteLater();
    m_isActive = false;
    m_isFinished = true;
    emit finished();
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

    qreal p = bytesReceived / bytesTotal;
    if (p != m_progress) {
        m_progress = p;
        emit progressChanged();
    }
}

void Download::onError(QNetworkReply::NetworkError code)
{
    m_errorCode = 500 + code;
}
