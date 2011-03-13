#include "XbmcEventClient.h"

#include <errno.h>

XbmcEventClient::XbmcEventClient(QObject *parent)
    : QObject(parent)
    , m_xbmcClient(0)
    , m_connected(false)
{
    m_PingTimer = new QTimer(this);
    m_PingTimer->setInterval(45000);
    connect(m_PingTimer, SIGNAL(timeout()), SLOT(ping()));

    XBMCClientUtils::Initialize();
}

XbmcEventClient::~XbmcEventClient()
{
    if (m_xbmcClient)
        delete m_xbmcClient;
    XBMCClientUtils::Clean();
}

void XbmcEventClient::initialize(const QString &ip, const QString &port)
{
    if (m_xbmcClient) {
        delete m_xbmcClient;
        m_xbmcClient = NULL;
    }

    m_xbmcClient = new CXBMCClient(ip.toAscii().data(), port.toInt());
    if (m_xbmcClient->isConnected()) {
        m_xbmcClient->SendHELO("QML device", ICON_NONE);
        m_PingTimer->start();
        notify("semperXbmc", "Now connected", ICON_NONE);
    } else {
        delete m_xbmcClient;
        m_xbmcClient = NULL;
#ifdef Q_OS_WIN
        qDebug() << "Socket creation failed" << WSAGetLastError();
#endif
    }
}

void XbmcEventClient::ping()
{
    if (!m_xbmcClient)
        return;

    m_xbmcClient->SendPING();
}

void XbmcEventClient::notify(const QString& Title, const QString& Message, unsigned short IconType, const QString& IconFile)
{
    if (!m_xbmcClient)
        return;

    char *cIconFile = NULL;
    if (!IconFile.isEmpty())
        cIconFile = IconFile.toLatin1().data();

    m_xbmcClient->SendNOTIFICATION(Title.toLatin1().data(), Message.toLatin1().data(), IconType, cIconFile);
}

void XbmcEventClient::button(const QString& Button, const QString& DeviceMap, unsigned short Flags, unsigned short Amount)
{
    if (!m_xbmcClient)
        return;

    m_xbmcClient->SendButton(Button.toLatin1().data(), DeviceMap.toLatin1().data(), Flags, Amount);
}

void XbmcEventClient::button(unsigned short ButtonCode, const QString& DeviceMap, unsigned short Flags, unsigned short Amount)
{
    if (!m_xbmcClient)
        return;

    m_xbmcClient->SendButton(ButtonCode, DeviceMap.toLatin1().data(), Flags, Amount);
}

void XbmcEventClient::button(unsigned short ButtonCode, unsigned Flags, unsigned short Amount)
{
    if (!m_xbmcClient)
        return;

    m_xbmcClient->SendButton(ButtonCode, Flags, Amount);
}

void XbmcEventClient::mouse(int X, int Y, unsigned char Flag)
{
    if (!m_xbmcClient)
        return;

    m_xbmcClient->SendMOUSE(X, Y, Flag);
}

void XbmcEventClient::log(int LogLevel, const QString& Message, bool AutoPrintf)
{
    if (!m_xbmcClient)
        return;

    m_xbmcClient->SendLOG(LogLevel, Message.toLatin1().data(), AutoPrintf);
}

void XbmcEventClient::action(const QString& ActionMessage, int ActionType)
{
    if (!m_xbmcClient)
        return;

    m_xbmcClient->SendACTION(ActionMessage.toLatin1().data(), ActionType);
}

void XbmcEventClient::actionButton(const QString& ActionMessage)
{
    if (!m_xbmcClient)
        return;

    m_xbmcClient->SendACTION(ActionMessage.toLatin1().data(), ACTION_BUTTON);
}

void XbmcEventClient::actionBuiltin(const QString& ActionMessage)
{
    if (!m_xbmcClient)
        return;

    m_xbmcClient->SendACTION(ActionMessage.toLatin1().data(), ACTION_EXECBUILTIN);
}

void XbmcEventClient::keypress(const QString& keycode)
{
    if (!m_xbmcClient)
        return;

    if (!keycode.isEmpty()) {
        m_xbmcClient->SendButton(keycode.toLatin1().data(), "KB", BTN_USE_NAME | BTN_DOWN | BTN_QUEUE);
        m_xbmcClient->SendButton(keycode.toLatin1().data(), "KB", BTN_USE_NAME | BTN_UP | BTN_QUEUE);
    }
}

