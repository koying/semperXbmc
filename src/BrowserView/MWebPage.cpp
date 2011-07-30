#include "MWebPage.h"

#include "MWebView.h"
#include "BrowserView.h"

#include <QWebFrame>
#include <QMessageBox>
#include <QNetworkProxy>
#include <QNetworkRequest>
#include <QInputDialog>
#include <QLineEdit>

#define SYMBIAN1_AGENT "Mozilla/5.0 (SymbianOS/9.4; U; Series60/5.0 Nokia5800d-1/30.0.011; Profile/MIDP-2.1 Configuration/CLDC-1.1 ) AppleWebKit/532.4 (KHTML, like Gecko) Safari/532.4"
#define SYMBIAN3_AGENT "Mozilla/5.0 (Symbian/3; Series60/5.2 NokiaC7-00/011.004; Profile/MIDP-2.1 Configuration/CLDC-1.1 ) AppleWebKit/525 (KHTML, like Gecko) Version/3.0 BrowserNG/7.2.6.7 3gpp-gba"
#define IPHONE_AGENT "Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_0 like Mac OS X; en-us) AppleWebKit/528.18 (KHTML, like Gecko) Version/4.0 Mobile/7A341 Safari/528.16"
#define ANDROID_AGENT "Mozilla/5.0 (Linux; U; Android 2.0.1; en-us;sdk Build/ES54) AppleWebKit/530.17+ (KHTML, like Gecko) Version/4.0 Mobile Safari/530.17"
#define DESKTOP_AGENT "Mozilla/5.0 (Windows; U; Windows NT 6.1; en-us; rv:1.9.2.8) Gecko/20100722 Firefox/3.6.8 ( .NET CLR 3.5.30729; .NET4.0C)"

MWebPage::MWebPage(QObject * parent)
    : QWebPage(parent)
{
    setForwardUnsupportedContent(true);
#if (QTWEBKIT_VERSION >= QTWEBKIT_VERSION_CHECK(2, 1, 0))
    connect (this, SIGNAL(featurePermissionRequested(QWebFrame*, QWebPage::Feature)), SLOT(onFeaturePermissionRequested(QWebFrame*, QWebPage::Feature)));
#endif
    QPalette pal = palette();
    pal.setBrush(QPalette::Base, Qt::white);
    setPalette(pal);
}

MWebPage::~MWebPage()
{
}

QString MWebPage::userAgentForUrl ( const QUrl & url ) const
{
//    int curUa = M_PREFS->getCurrentUa();
//    if (!curUa)
//        curUa = M_PREFS->getGeneralUserAgent();

//    if (url.toString().toLower().contains("iphone"))
//        return(IPHONE_AGENT);
//    if (url.toString().toLower().contains("youtube.com")) {
//#ifdef Q_OS_SYMBIAN
//        if (QSysInfo::symbianVersion() == QSysInfo::SV_SF_3)
//            return SYMBIAN3_AGENT;
//        else
//            return SYMBIAN1_AGENT;
//#else
//        return SYMBIAN3_AGENT;
//#endif
//    }

//    switch (curUa)
//    {
//    case MyPreferences::UaSymbian1:  // Symbian1
//        return(SYMBIAN1_AGENT);
//        break;
//    case MyPreferences::UaIPhone:  // iPhone
//        return(IPHONE_AGENT);
//        break;
//    case MyPreferences::UaAndroid:  // Android
//        return(ANDROID_AGENT);
//        break;
//    case MyPreferences::UaSymbian3:  // Symbian3
//        return(SYMBIAN3_AGENT);
//        break;
//    case MyPreferences::UaDesktop:  // Desktop (firefox)
//        return(DESKTOP_AGENT);
//        break;
//    default:
//        return QWebPage::userAgentForUrl(url);
//        break;
//    }

    if (!BrowserView::instance()->userAgent().isEmpty())
        return BrowserView::instance()->userAgent();

//#ifdef Q_OS_SYMBIAN
//    if (QSysInfo::symbianVersion() == QSysInfo::SV_SF_3)
//        return SYMBIAN3_AGENT;
//    else
//        return SYMBIAN1_AGENT;
//#endif
    return QWebPage::userAgentForUrl(url);
}

bool MWebPage::acceptNavigationRequest(QWebFrame *frame, const QNetworkRequest &request, NavigationType type)
{
    //	if (QWebPage::acceptNavigationRequest(frame, request, type)) {
    //		//	QNetworkProxy myProxy(QNetworkProxy::HttpProxy, "localhost", 8888);
    //		//	p->m_webPage->networkAccessManager()->setProxy(myProxy);
    //		QNetworkProxyQuery npq(request.url());
    //		QList<QNetworkProxy> listOfProxies = QNetworkProxyFactory::systemProxyForQuery(npq);
    //		if (listOfProxies.size())
    //			networkAccessManager()->setProxy(listOfProxies[0]);
    //		return true;
    //	} else
    //		return false;

    //	QNetworkProxy myProxy(QNetworkProxy::HttpProxy, "localhost", 8888);
    //	networkAccessManager()->setProxy(myProxy);

    return QWebPage::acceptNavigationRequest(frame, request, type);

}

/*!
    This function is called whenever a JavaScript program running inside \a frame calls the alert() function with
    the message \a msg.

    The default implementation shows the message, \a msg, with QMessageBox::information.
*/
void MWebPage::javaScriptAlert(QWebFrame *frame, const QString& msg)
{
    Q_UNUSED(frame);
    qDebug() << msg;
#ifndef QT_NO_MESSAGEBOX
    QWidget* parent = 0;
    QMessageBox::information(parent, tr("JavaScript Alert - %1").arg(mainFrame()->url().host()), msg, QMessageBox::Ok);
#endif
}

/*!
    This function is called whenever a JavaScript program running inside \a frame calls the confirm() function
    with the message, \a msg. Returns true if the user confirms the message; otherwise returns false.

    The default implementation executes the query using QMessageBox::information with QMessageBox::Yes and QMessageBox::No buttons.
*/
bool MWebPage::javaScriptConfirm(QWebFrame *frame, const QString& msg)
{
    Q_UNUSED(frame);
    qDebug() << msg;
#ifdef QT_NO_MESSAGEBOX
    return true;
#else
    QWidget* parent = 0;
    return QMessageBox::Yes == QMessageBox::information(parent, tr("JavaScript Confirm - %1").arg(mainFrame()->url().host()), msg, QMessageBox::Yes, QMessageBox::No);
#endif
}

/*!
    This function is called whenever a JavaScript program running inside \a frame tries to prompt the user for input.
    The program may provide an optional message, \a msg, as well as a default value for the input in \a defaultValue.

    If the prompt was cancelled by the user the implementation should return false; otherwise the
    result should be written to \a result and true should be returned. If the prompt was not cancelled by the
    user, the implementation should return true and the result string must not be null.

    The default implementation uses QInputDialog::getText().
*/
bool MWebPage::javaScriptPrompt(QWebFrame *frame, const QString& msg, const QString& defaultValue, QString* result)
{
    Q_UNUSED(frame);
    qDebug() << msg;
    bool ok = false;
#ifndef QT_NO_INPUTDIALOG
    QWidget* parent = 0;
    QString x = QInputDialog::getText(parent, tr("JavaScript Prompt - %1").arg(mainFrame()->url().host()), msg, QLineEdit::Normal, defaultValue, &ok);
    if (ok && result)
        *result = x;
#endif
    return ok;
}

void MWebPage::javaScriptConsoleMessage(const QString& message, int lineNumber, const QString& sourceID)
{
    qDebug() << message;
}

/*!
    \fn bool QWebPage::shouldInterruptJavaScript()
    \since 4.6
    This function is called when a JavaScript program is running for a long period of time.

    If the user wanted to stop the JavaScript the implementation should return true; otherwise false.

    The default implementation executes the query using QMessageBox::information with QMessageBox::Yes and QMessageBox::No buttons.

    \warning Because of binary compatibility constraints, this function is not virtual. If you want to
    provide your own implementation in a QWebPage subclass, reimplement the shouldInterruptJavaScript()
    slot in your subclass instead. QtWebKit will dynamically detect the slot and call it.
*/
bool MWebPage::shouldInterruptJavaScript()
{
#ifdef QT_NO_MESSAGEBOX
    return false;
#else
    QWidget* parent = 0;
    return QMessageBox::Yes == QMessageBox::information(parent, tr("JavaScript Problem - %1").arg(mainFrame()->url().host()), tr("The script on this page appears to have a problem. Do you want to stop the script?"), QMessageBox::Yes, QMessageBox::No);
#endif
}

QWebPage *MWebPage::createWindow(QWebPage::WebWindowType type)
{
    qDebug() << "createWindow";
    Q_UNUSED(type);

    BrowserView::instance()->addWebview();
    return BrowserView::instance()->curWebView->page();
}

void MWebPage::triggerAction(QWebPage::WebAction action, bool checked)
{
    switch (action) {
    case OpenLink:
        return QWebPage::triggerAction(OpenLinkInNewWindow, checked);
    }
    return QWebPage::triggerAction(action, checked);
}

#if (QTWEBKIT_VERSION >= QTWEBKIT_VERSION_CHECK(2, 1, 0))
void MWebPage::onFeaturePermissionRequested(QWebFrame *frame, QWebPage::Feature feature)
{
    switch (feature) {
    case QWebPage::Geolocation:
        if (QMessageBox::Yes == QMessageBox::information(0, tr("Geolocation").arg(mainFrame()->url().host()), tr("This site wants to know your location. Do you allow it?"), QMessageBox::Yes, QMessageBox::No)) {
            setFeaturePermission(frame, feature, PermissionGrantedByUser);
        } else {
            setFeaturePermission(frame, feature, PermissionDeniedByUser);
        }
        break;
    default:
        break;
    }
}
#endif
