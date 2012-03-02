#ifndef XBMCTCPTRANSPORT_H
#define XBMCTCPTRANSPORT_H

#include <QObject>
#include <QtNetwork>

class XbmcStatus;

class XbmcJsonRequest : public QObject
{
    Q_OBJECT
public:
    explicit XbmcJsonRequest(QObject *parent = 0);
    explicit XbmcJsonRequest(const QString& method, const QVariant& id=QVariant(), const QVariantMap& params=QVariantMap(),QObject *parent = 0);

    Q_PROPERTY(QString jsonrpc READ jsonrpc)
    Q_PROPERTY(QString method READ method WRITE setMethod)
    Q_PROPERTY(QVariantMap params READ params WRITE setParams)
    Q_PROPERTY(QVariant id READ id WRITE setId)


public:
    QString jsonrpc() const { return "2.0"; }

    QString method() const { return m_method; }
    void setMethod(const QString& val) { m_method = val; }

    QVariantMap params() const { return m_params; }
    void setParams(const QVariantMap& val) { m_params = val; }

    QVariant id() const { return m_id; }
    void setId(const QVariant& val) { m_id = val; }

    Q_INVOKABLE QByteArray serialize() const;
    Q_INVOKABLE QVariant toVariant() const;
    Q_INVOKABLE QString toString() const;

protected:
    QString m_method;
    QVariantMap m_params;
    QVariant m_id;

};

class XbmcJsonReply : public QObject
{
};

/********************/

class XbmcTcpTransport : public QObject
{
    Q_OBJECT
public:
    explicit XbmcTcpTransport(QObject *parent = 0);
    ~XbmcTcpTransport();

    XbmcStatus* statusObject() { return m_statusObject; }

public:
    Q_INVOKABLE void initialize(const QString& ip, const QString& port, const int version);

    void send(const XbmcJsonRequest& req) const;

signals:
    void initialized();
    void notificationReceived(QString jsonMsg);
    void errorDetected(QString type, QString msg, QString info);

public slots:
    void on_socket_connected();
    void on_socket_error ( QAbstractSocket::SocketError socketError);
    void on_socket_readyRead();

protected:
    QTcpSocket* m_socket;
    int m_version;

    QThread m_statusThread;
    XbmcStatus* m_statusObject;
};

/************************/

class XbmcPlayer : public QObject
{
    Q_OBJECT

signals:
    void speedChanged();
    void percentageChanged();
    void positionChanged();

public:
    explicit XbmcPlayer(QObject *parent = 0);

    Q_PROPERTY(QString type READ type WRITE settype)
    Q_PROPERTY(QObject* transport READ transport WRITE settransport)

    Q_PROPERTY(qreal speed READ speed NOTIFY speedChanged)
    Q_PROPERTY(qreal percentage READ percentage NOTIFY percentageChanged)
    Q_PROPERTY(int position READ position NOTIFY positionChanged)

    Q_INVOKABLE void playPause();
    Q_INVOKABLE void stop();
    Q_INVOKABLE void skipPrevious();
    Q_INVOKABLE void skipNext();


public:
    QString type() const { return m_type; }
    void settype(QString val);

    QObject* transport() const { return m_transport; }
    void settransport(QObject* val);

    qreal speed() const { return m_speed; }
    qreal percentage() const { return m_percentage; }
    int position() const { return m_position; }

public slots:
    void setSpeed(qreal speed);
    void setPercentage(qreal percentage);
    void setPosition(int position);

protected slots:
    void makeConnections();

private:
    XbmcTcpTransport* m_transport;
    QString m_type;
    int m_playerId;

    qreal m_speed;
    qreal m_percentage;
    int m_position;

};

/**********************/

class XbmcStatus : public QObject
{
    Q_OBJECT
public:
    explicit XbmcStatus(const QString &host, const QString &port, QObject *parent = 0);

signals:
    void audioSpeedChanged(qreal speed);
    void audioPercentageChanged(qreal percentage);
    void audioPositionChanged(int position);

    void videoSpeedChanged(qreal speed);
    void videoPercentageChanged(qreal percentage);
    void videoPositionChanged(int position);

protected slots:
    void on_socket_connected();
    void on_socket_error ( QAbstractSocket::SocketError socketError);
    void on_socket_readyRead();

    void update();
    void handleMsg(const QString& msg);

protected:
    bool m_connected;
    QString m_host;
    int m_port;

    QTcpSocket* m_socket;
    QTimer* timer;

    qreal m_currentAudioSpeed;
    qreal m_currentAudioPercentage;
    int m_currentAudioPosition;

    qreal m_currentVideoSpeed;
    qreal m_currentVideoPercentage;
    int m_currentVideoPosition;
};

#endif // XBMCTCPTRANSPORT_H
