#ifndef XBMCTCPTRANSPORT_H
#define XBMCTCPTRANSPORT_H

#include <QObject>
#include <QtNetwork>

class XbmcTcpTransport : public QObject
{
    Q_OBJECT
public:
    explicit XbmcTcpTransport(QObject *parent = 0);

public:
    Q_INVOKABLE void initialize(const QString& ip, const QString& port, const int version);

signals:
    void notificationReceived(QString jsonMsg);
    void errorDetected(QString type, QString msg, QString info);

public slots:
    void on_socket_connected();
    void on_socket_error ( QAbstractSocket::SocketError socketError);
    void on_socket_readyRead();

protected:
    QTcpSocket* m_socket;
    int m_version;
};

#endif // XBMCTCPTRANSPORT_H
