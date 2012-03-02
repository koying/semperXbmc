#include "XbmcTcpTransport.h"

#include "QJson/Parser"
#include "QJson/Serializer"
#include "QJson/QObjectHelper"

XbmcJsonRequest::XbmcJsonRequest(QObject *parent)
    : QObject(parent)
{
}

XbmcJsonRequest::XbmcJsonRequest(const QString& method, const QVariant& id, const QVariantMap& params, QObject *parent)
    : QObject(parent), m_method(method), m_params(params), m_id(id)
{
}

QByteArray XbmcJsonRequest::serialize() const
{
    QVariantMap variant = QJson::QObjectHelper::qobject2qvariant(this);
    QJson::Serializer serializer;
    return serializer.serialize(variant);
}

QVariant XbmcJsonRequest::toVariant() const
{
    return QJson::QObjectHelper::qobject2qvariant(this);
}

QString XbmcJsonRequest::toString() const
{
    return QString(serialize());
}

/******************************/

XbmcTcpTransport::XbmcTcpTransport(QObject *parent)
    : QObject(parent)
    , m_socket(new QTcpSocket(this))
    , m_statusObject(NULL)
{
    connect (m_socket, SIGNAL(connected()), SLOT(on_socket_connected()));
    connect (m_socket, SIGNAL(error(QAbstractSocket::SocketError)), SLOT(on_socket_error(QAbstractSocket::SocketError)));
    connect (m_socket, SIGNAL(readyRead()), SLOT(on_socket_readyRead()));
}

XbmcTcpTransport::~XbmcTcpTransport()
{
    if (m_statusThread.isRunning()) {
        m_statusThread.quit();
        m_statusThread.wait(5000);
    }
}

void XbmcTcpTransport::initialize(const QString &ip, const QString &port, const int version)
{
    m_socket->connectToHost(ip, port.toInt());
    m_version = version;

    m_statusObject = new XbmcStatus(ip, port);
    m_statusObject->moveToThread(&m_statusThread);
    m_statusThread.start();

    emit initialized();
}

void XbmcTcpTransport::send(const XbmcJsonRequest &req) const
{
    m_socket->write(req.serialize());
}

void XbmcTcpTransport::on_socket_connected()
{
    qDebug() << "Socket Connected";
    switch (m_version) {
    case 2:
        m_socket->write("{\"jsonrpc\": \"2.0\", \"method\": \"JSONRPC.SetNotificationFlags\", \"params\": { \"VideoLibrary\": true, \"AudioLibrary\": true }, \"id\":1 }");
        break;

    case 3:
    case 4: {
        XbmcJsonRequest req("JSONRPC.SetConfiguration", 1);
        QVariantMap notifs;
        notifs["VideoLibrary"] = true;
        notifs["AudioLibrary"] = true;
        QVariantMap params;
        params["notifications"] = notifs;
        req.setParams(params);
//        m_socket->write("{\"jsonrpc\": \"2.0\", \"method\": \"JSONRPC.SetConfiguration\", \"params\": { \"notifications\": {\"VideoLibrary\": true, \"AudioLibrary\": true } }, \"id\":1 }");
        m_socket->write(req.serialize());
        break;
    }
    }
}

void XbmcTcpTransport::on_socket_error ( QAbstractSocket::SocketError socketError)
{
    qDebug() << "Socket Error";
}

void XbmcTcpTransport::on_socket_readyRead()
{
    QString msg = QString(m_socket->readAll());
    QString jsonMsg;
    int openedBrackets = 0;
    for (int i=0; i<msg.size(); ++i) {
        if (msg.at(i) == '{') {
            openedBrackets++;
            jsonMsg.append(msg.at(i));
        } else if (msg.at(i) == '}') {
            openedBrackets--;
            jsonMsg.append(msg.at(i));
            if (openedBrackets == 0 && jsonMsg.size()) {
                emit notificationReceived(jsonMsg);
                jsonMsg = QString();
            }
        } else if (openedBrackets > 0)
            jsonMsg.append(msg.at(i));
    }
}

/******************/

XbmcPlayer::XbmcPlayer(QObject *parent)
    : QObject(parent)
    , m_transport(NULL)
    , m_playerId(-1)
    , m_speed(-1)
    , m_percentage(-1)
    , m_position(-1)
{
}

void XbmcPlayer::playPause()
{
    if (!m_transport)
        return;

    XbmcJsonRequest req("Player.PlayPause");
    QVariantMap params;
    params["playerid"] = m_playerId;
    req.setParams(params);
    m_transport->send(req);
}

void XbmcPlayer::stop()
{
    if (!m_transport)
        return;

    XbmcJsonRequest req("Player.Stop");
    QVariantMap params;
    params["playerid"] = m_playerId;
    req.setParams(params);
    m_transport->send(req);
}

void XbmcPlayer::skipPrevious()
{
    if (!m_transport)
        return;

    XbmcJsonRequest req("Player.GoPrevious");
    QVariantMap params;
    params["playerid"] = m_playerId;
    req.setParams(params);
    m_transport->send(req);
}

void XbmcPlayer::skipNext()
{
    if (!m_transport)
        return;

    XbmcJsonRequest req("Player.GoNext");
    QVariantMap params;
    params["playerid"] = m_playerId;
    req.setParams(params);
    m_transport->send(req);
}

void XbmcPlayer::settype(QString val)
{
    m_type = val;
    m_playerId = -1;
    if (m_type == "audio")
        m_playerId = 0;
    else if (m_type == "video")
        m_playerId = 1;
    else if (m_type == "picture")
        m_playerId = 2;

    if (m_playerId < 0)
        return;

    makeConnections();
}

void XbmcPlayer::settransport(QObject *val)
{
    m_transport = qobject_cast<XbmcTcpTransport*>(val);

    if (!m_transport)
        return;

    if (m_transport->statusObject())
        makeConnections();
    else
        connect(m_transport, SIGNAL(initialized()), this, SLOT(makeConnections()));
}

void XbmcPlayer::setSpeed(qreal speed)
{
    m_speed = speed;
    emit speedChanged();
}

void XbmcPlayer::setPercentage(qreal percentage)
{
    m_percentage = percentage;
    emit percentageChanged();
}

void XbmcPlayer::setPosition(int position)
{
    m_position = position;
    emit positionChanged();
}

void XbmcPlayer::makeConnections()
{
    if (m_transport && m_transport->statusObject())
        disconnect(m_transport->statusObject(), 0, this, 0);

    if (m_playerId < 0)
        return;

    if (!m_transport || !m_transport->statusObject())
        return;

    if (m_type == "audio") {
        connect(m_transport->statusObject(), SIGNAL(audioPercentageChanged(qreal)), this, SLOT(setPercentage(qreal)));
        connect(m_transport->statusObject(), SIGNAL(audioPositionChanged(int)), this, SLOT(setPosition(int)));
        connect(m_transport->statusObject(), SIGNAL(audioSpeedChanged(qreal)), this, SLOT(setSpeed(qreal)));
    } else if (m_type == "video") {
        connect(m_transport->statusObject(), SIGNAL(videoPercentageChanged(qreal)), this, SLOT(setPercentage(qreal)));
        connect(m_transport->statusObject(), SIGNAL(videoPositionChanged(int)), this, SLOT(setPosition(int)));
        connect(m_transport->statusObject(), SIGNAL(videoSpeedChanged(qreal)), this, SLOT(setSpeed(qreal)));
    }
}


/******************/

XbmcStatus::XbmcStatus(const QString &host, const QString &port, QObject *parent)
    : QObject(parent)
    , m_connected(false)
    , m_host(host)
    , m_port(port.toInt())
    , m_socket(new QTcpSocket(this))
    , m_currentAudioSpeed(-1)
    , m_currentAudioPercentage(-1)
    , m_currentAudioPosition(-1)
    , m_currentVideoSpeed(-1)
    , m_currentVideoPercentage(-1)
    , m_currentVideoPosition(-1)
{
    connect (m_socket, SIGNAL(connected()), SLOT(on_socket_connected()));
    connect (m_socket, SIGNAL(error(QAbstractSocket::SocketError)), SLOT(on_socket_error(QAbstractSocket::SocketError)));
    connect (m_socket, SIGNAL(readyRead()), SLOT(on_socket_readyRead()));

    timer = new QTimer(this);
    timer->setInterval(10000);
    connect(timer, SIGNAL(timeout()), SLOT(update()));
    timer->start();

    m_socket->connectToHost(m_host, m_port);
}

void XbmcStatus::on_socket_connected()
{
    qDebug() << "XbmcStatus: Socket Connected";
    m_connected = true;
    timer->stop();
    timer->setInterval(1000);
    timer->start();
}

void XbmcStatus::on_socket_error ( QAbstractSocket::SocketError socketError)
{
    qDebug() << "Error";
    m_socket->abort();
    m_connected = false;
}

void XbmcStatus::on_socket_readyRead()
{
    QString msg = QString(m_socket->readAll());
    QString jsonMsg;
    int openedBrackets = 0;
    for (int i=0; i<msg.size(); ++i) {
        if (msg.at(i) == '{') {
            openedBrackets++;
            jsonMsg.append(msg.at(i));
        } else if (msg.at(i) == '}') {
            openedBrackets--;
            jsonMsg.append(msg.at(i));
            if (openedBrackets == 0 && jsonMsg.size()) {
                handleMsg(jsonMsg);
                jsonMsg = QString();
            }
        } else if (openedBrackets > 0)
            jsonMsg.append(msg.at(i));
    }
}

void XbmcStatus::update()
{
    if (!m_connected) {
        m_socket->connectToHost(m_host, m_port);
        return;
    }

    QVariantList requests;

    QStringList properties;
    QVariantMap params;

    XbmcJsonRequest req1("Player.GetProperties", 1);
    properties << "speed" << "percentage" << "position";
    params["playerid"] = 0;
    params["properties"] = properties;
    req1.setParams(params);
    requests << req1.toVariant();

    XbmcJsonRequest req2("Player.GetProperties", 2);
    params["playerid"] = 1;
    req2.setParams(params);
    requests << req2.toVariant();

//    XbmcJsonRequest req3("Player.GetActivePlayers", 3);
//    requests << req3.toVariant();

    QJson::Serializer serializer;
//    QString out = QString(serializer.serialize(requests));
//    qDebug() << out;
    m_socket->write(serializer.serialize(requests));
}

void XbmcStatus::handleMsg(const QString &msg)
{
    QJson::Parser parser;
    bool ok;

    QVariantMap o = parser.parse(msg.toUtf8(), &ok).toMap();
    if (!ok) {
        qDebug() << "Parse error";
        return;
    }

    int reqId = o["id"].toInt();
    qreal newSpeed = -1;
    qreal newPercentage = -1;
    int newPos = -1;

    switch (reqId) {
    case 1:
        if (o["result"].isValid()) {
            QVariantMap result = o["result"].toMap();
            newSpeed = result["speed"].toReal();
            newPercentage = result["percentage"].toReal();
            newPos = result["position"].toInt();
        }
        if (m_currentAudioSpeed != newSpeed) {
            m_currentAudioSpeed = newSpeed;
            emit audioSpeedChanged(m_currentAudioSpeed);
        }
        if (m_currentAudioPercentage != newPercentage) {
            m_currentAudioPercentage = newPercentage;
            emit audioPercentageChanged(m_currentAudioPercentage);
        }
        if (m_currentAudioPosition != newPos) {
            m_currentAudioPosition = newPos;
            emit audioPositionChanged(m_currentAudioPosition);
        }
        break;

    case 2: {
        if (o["result"].isValid()) {
            QVariantMap result = o["result"].toMap();
            newSpeed = result["speed"].toReal();
            newPercentage = result["percentage"].toReal();
            newPos = result["position"].toInt();
        }
        if (m_currentVideoSpeed != newSpeed) {
            m_currentVideoSpeed = newSpeed;
            emit videoSpeedChanged(m_currentVideoSpeed);
        }
        if (m_currentVideoPercentage != newPercentage) {
            m_currentVideoPercentage = newPercentage;
            emit videoPercentageChanged(m_currentVideoPercentage);
        }
        if (m_currentVideoPosition != newPos) {
            m_currentVideoPosition = newPos;
            emit videoPositionChanged(m_currentVideoPosition);
        }
        break;
    }
    }
}

