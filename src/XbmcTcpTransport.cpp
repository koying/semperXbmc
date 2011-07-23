#include "XbmcTcpTransport.h"

XbmcTcpTransport::XbmcTcpTransport(QObject *parent)
    : QObject(parent)
    , m_socket(new QTcpSocket(this))
{
    connect (m_socket, SIGNAL(connected()), SLOT(on_socket_connected()));
    connect (m_socket, SIGNAL(error(QAbstractSocket::SocketError)), SLOT(on_socket_error(QAbstractSocket::SocketError)));
    connect (m_socket, SIGNAL(readyRead()), SLOT(on_socket_readyRead()));
}

void XbmcTcpTransport::initialize(const QString &ip, const QString &port)
{
    m_socket->connectToHost(ip, port.toInt());
}

void XbmcTcpTransport::on_socket_connected()
{
    qDebug() << "Connected";
    m_socket->write("{\"jsonrpc\": \"2.0\", \"method\": \"JSONRPC.SetNotificationFlags\", \"params\": { \"VideoLibrary\": true, \"AudioLibrary\": true }, \"id\":1 }");
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
