#ifndef DOWNLOAD_H
#define DOWNLOAD_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QFile>

class Download : public QObject
{
    Q_OBJECT
public:
    explicit Download(QObject *parent = 0);

    Q_INVOKABLE void go();

signals:
    void FilenameChanged();
    void progressChanged();
    void activeChanged();
    void finishedChanged();

protected:
    QNetworkAccessManager *m_netmanager;
    QNetworkReply* m_reply;
    QFile* m_outputFile;

protected slots:
    void onFinished();
    void onReadyData();
    void onError(QNetworkReply::NetworkError code);
    void onDownloadProgress ( qint64 bytesReceived, qint64 bytesTotal );

public:
    Q_PROPERTY(QString inputPath READ inputPath WRITE setInputPath)
public:
    QString inputPath() { return m_inputPath; }
    void setInputPath(QString val);
private:
    QString m_inputPath;

    Q_PROPERTY(QString outputPath READ outputPath WRITE setOutputPath)
public:
    QString outputPath() { return m_outputPath; }
    void setOutputPath(QString val);
private:
    QString m_outputPath;

    Q_PROPERTY(QString filename READ filename WRITE setFilename NOTIFY FilenameChanged)
public:
    QString filename() { return m_filename; }
    void setFilename(QString val);
private:
    QString m_filename;


    Q_PROPERTY(qreal progress READ progress NOTIFY progressChanged)
public:
    qreal progress() { return m_progress; }
private:
    qreal m_progress;

    Q_PROPERTY(int errorCode READ errorCode)
public:
    int errorCode() { return m_errorCode; }
private:
    int m_errorCode;

    Q_PROPERTY(bool isActive READ isActive NOTIFY activeChanged)
public:
    bool isActive() { return m_isActive; }
private:
    bool m_isActive;


    Q_PROPERTY(bool isFinished READ isFinished NOTIFY finishedChanged)
public:
    bool isFinished() { return m_isFinished; }
private:
    bool m_isFinished;

};

#endif // DOWNLOAD_H
