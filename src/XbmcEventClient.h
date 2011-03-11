#ifndef XBMCEVENTCLIENT_H
#define XBMCEVENTCLIENT_H

#include <QDeclarativeItem>
#include <QTimer>

#include "xbmcclient.h"

class CXBMCClient;

class XbmcEventClient : public QObject
{
    Q_OBJECT

public:
    explicit XbmcEventClient(QObject *parent = 0);
    ~XbmcEventClient();

public:
    Q_INVOKABLE void initialize(const QString& ip, const QString& port);
    Q_INVOKABLE void notify(const QString &Title, const QString &Message, unsigned short IconType, const QString &IconFile = QString());
    Q_INVOKABLE void button(const QString &Button, const QString &DeviceMap, unsigned short Flags, unsigned short Amount = 0);
    Q_INVOKABLE void button(unsigned short ButtonCode, const QString &DeviceMap, unsigned short Flags, unsigned short Amount = 0);
    Q_INVOKABLE void button(unsigned short ButtonCode, unsigned Flags, unsigned short Amount = 0);
    Q_INVOKABLE void mouse(int X, int Y, unsigned char Flag = MS_ABSOLUTE);
    Q_INVOKABLE void log(int LogLevel, const QString &Message, bool AutoPrintf = true);
    Q_INVOKABLE void action(const QString &ActionMessage, int ActionType = ACTION_EXECBUILTIN);

signals:

public slots:

private slots:
    void ping();

private:
    CXBMCClient* m_xbmcClient;
    bool m_connected;
    QTimer* m_PingTimer;
};

#endif // XBMCEVENTCLIENT_H
