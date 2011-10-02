#include "XbmcTcpTransport.h"

XbmcTcpTransport::XbmcTcpTransport(QObject *parent)
    : QObject(parent)
    , m_socket(new QTcpSocket(this))
{
    connect (m_socket, SIGNAL(connected()), SLOT(on_socket_connected()));
    connect (m_socket, SIGNAL(error(QAbstractSocket::SocketError)), SLOT(on_socket_error(QAbstractSocket::SocketError)));
    connect (m_socket, SIGNAL(readyRead()), SLOT(on_socket_readyRead()));
}

void XbmcTcpTransport::initialize(const QString &ip, const QString &port, const int version)
{
    m_socket->connectToHost(ip, port.toInt());
    m_version = version;
}

void XbmcTcpTransport::on_socket_connected()
{
    qDebug() << "Connected";
    switch (m_version) {
    case 2:
        m_socket->write("{\"jsonrpc\": \"2.0\", \"method\": \"JSONRPC.SetNotificationFlags\", \"params\": { \"VideoLibrary\": true, \"AudioLibrary\": true }, \"id\":1 }");
        break;

    case 3:
        m_socket->write("{\"jsonrpc\": \"2.0\", \"method\": \"JSONRPC.SetConfiguration\", \"params\": { \"notifications\": {\"VideoLibrary\": true, \"AudioLibrary\": true } }, \"id\":1 }");
        break;
    }
}

void XbmcTcpTransport::on_socket_error ( QAbstractSocket::SocketError socketError)
{
    qDebug() << "Error";
}

void XbmcTcpTransport::on_socket_readyRead()
{
    QString msg = QString(m_socket->readAll());
//    qDebug() << "msg: " << msg;
    emit notificationReceived(msg);
}
