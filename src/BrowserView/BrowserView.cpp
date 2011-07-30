#include "BrowserView.h"

#include <QtGui>
#include <QtNetwork>
#include <QNetworkCookieJar>
#include <QTimeLine>
#include <QMessageBox>
#include <QWebFrame>

#include "MWebView.h"
#include "MWebPage.h"
#include "BrowserCache.h"

class PersistentCookieJar : public QNetworkCookieJar {
public:
    PersistentCookieJar(QObject *parent) : QNetworkCookieJar(parent) { load(); }
    ~PersistentCookieJar() { save(); }

public:
    void save()
    {
        QList<QNetworkCookie> list = allCookies();
        QByteArray data;
        foreach (QNetworkCookie cookie, list) {
            if (!cookie.isSessionCookie()) {
                data.append(cookie.toRawForm());
                data.append("\n");
            }
        }
        QSettings settings;
        settings.setValue("Cookies",data);
    }

    void load()
    {
        QSettings settings;
        QByteArray data = settings.value("Cookies").toByteArray();
        setAllCookies(QNetworkCookie::parseCookies(data));
    }
};

/***************************/

BrowserView* BrowserView::m_browserInstance = 0;

BrowserView::BrowserView(QDeclarativeItem *parent)
    : QDeclarativeItem(parent)
    , curWebView(0)
    , m_cache(0)
    , m_unsupReply(0)
    , m_unsupHandled(false)
{
    setFlag(QGraphicsItem::ItemHasNoContents, false);
    m_cookiejar = new PersistentCookieJar(this);
    m_browserInstance = this;
}

BrowserView::~BrowserView()
{
    delete curWebView;
    delete m_cookiejar;
}

void BrowserView::cleanupMemory()
{
}

void BrowserView::addWebview()
{
    curWebView = new MWebView(this);
    if (!curWebView) {
        cleanupMemory();
    }
    curWebView->setPos(0,0);
    curWebView->resize(QSize(width(), height()));

    connect(curWebView, SIGNAL(loadProgress(int)), SLOT(setProgress(int)));
    connect(curWebView, SIGNAL(loadFinished(bool)), SLOT(finish(bool)));

    connect(curWebView, SIGNAL(loadStarted()), SIGNAL(loadingStarted()));
    connect(curWebView, SIGNAL(loadFinished(bool)), SIGNAL(loadingFinished()));

    MWebPage* newPage = new MWebPage(curWebView);
    if (!newPage) {
        cleanupMemory();
    }
    if (!curWebView || !newPage) {
        QMessageBox::critical(0, tr("Memory Allocation error"), tr("Cannot allocate memory.\nBailing out..."));
    }

    newPage->setLinkDelegationPolicy(QWebPage::DelegateAllLinks);
    newPage->setPreferredContentsSize(QSize(width(), height()));
    qDebug() << width() << height();

    connect(newPage, SIGNAL(linkClicked(QUrl)), this, SLOT(onLinkClicked(QUrl)));
#ifndef QT_NO_OPENSSL
    connect(newPage->networkAccessManager(), SIGNAL(sslErrors(QNetworkReply*,QList<QSslError>)), this, SLOT(slotSslErrors(QNetworkReply*,QList<QSslError>)));
#endif
    connect(newPage, SIGNAL(frameCreated (QWebFrame *)), this, SLOT(slotFrameCreated (QWebFrame *)));
    connect(newPage, SIGNAL(downloadRequested (const QNetworkRequest &)), SLOT(onDownloadRequested (const QNetworkRequest &)));
    connect(newPage, SIGNAL(unsupportedContent (QNetworkReply *)), SLOT(onUnsupportedContent (QNetworkReply *)));

//    if (!m_cache)
//        m_cache = new BrowserCache(this);
//    newPage->networkAccessManager()->setCache(m_cache);

    newPage->networkAccessManager()->setCookieJar(m_cookiejar);
    m_cookiejar->setParent(0);

    QWebFrame *frame = newPage->mainFrame();
    frame->setScrollBarPolicy(Qt::Vertical, Qt::ScrollBarAlwaysOff);
    frame->setScrollBarPolicy(Qt::Horizontal, Qt::ScrollBarAlwaysOff);

    curWebView->setPage(newPage);
}

void BrowserView::stop()
{
    curWebView->stop();
}

void BrowserView::zoomBest()
{
    curWebView->zoomBest();
}

void BrowserView::reload()
{
    curWebView->reload();
}

void BrowserView::finish(bool ok)
{
    // TODO: handle error
    if (!ok && !m_unsupHandled) {
        return;
    }

//    // Force hidding any scrollbar
//    QWebElement body = m_webPage->currentFrame()->findFirstElement("body");
//    if (!body.isNull())
//        body.setStyleProperty("overflow", "hidden !important");

//    updateFrameLayout();

#if !defined(QT_NO_DEBUG_OUTPUT) && !defined(Q_OS_SYMBIAN)
    QFile f("c:/semperWeb.html");
    f.open(QIODevice::WriteOnly);
    f.write(curWebView->page()->mainFrame()->toHtml().toUtf8());
    f.close();
#endif
}

void BrowserView::geometryChanged ( const QRectF & newGeometry, const QRectF & oldGeometry )
{
    QDeclarativeItem::geometryChanged(newGeometry, oldGeometry);

    if (curWebView) {
        curWebView->setPos(0,0);
        curWebView->resize(newGeometry.size());
        curWebView->page()->setPreferredContentsSize(newGeometry.size().toSize());
    }
}

void BrowserView::seturl(const QUrl &url)
{
//    if (url.toString().endsWith("3gp")) {
//        showMedia(url);
//        return;
//    }
//	curWebView->setZoomFactor(INIT_ZOOM);
    qDebug() << "BrowserView::navigate: " << url.toString();

    QString sch = url.scheme();
    if (sch == "tel" || sch == "sms" || sch == "mailto") {
        QDesktopServices::openUrl(url);
        return;
    } else if (url.host().contains("store.ovi")) {
        QUrl u(url);
        u.setHost("store.ovi.mobi");
        QDesktopServices::openUrl(u);
        return;
    }

    QUrl referer;
    if (curWebView)
        referer = curWebView->page()->mainFrame()->url();
    if (!curWebView) {
        addWebview();
    }
    QNetworkRequest req(url);
    req.setRawHeader(QString("Referer").toAscii(), referer.toString().toAscii());
    req.setAttribute(QNetworkRequest::CacheLoadControlAttribute, QNetworkRequest::PreferCache);
    m_unsupHandled = false;
    m_unsupReply = NULL;

    curWebView->load(req);
    emit urlChanged();
}

#ifndef QT_NO_OPENSSL
void BrowserView::slotSslErrors(QNetworkReply* rep,QList<QSslError>)
{
    rep->ignoreSslErrors();
}
#endif

void BrowserView::slotFrameCreated(QWebFrame * frame)
{
    frame->setScrollBarPolicy(Qt::Vertical, Qt::ScrollBarAlwaysOff);
    frame->setScrollBarPolicy(Qt::Horizontal, Qt::ScrollBarAlwaysOff);

//    connect(frame, SIGNAL(initialLayoutCompleted()), SLOT(slotFrameInitialLayoutCompleted()));
}

//void BrowserView::slotFrameInitialLayoutCompleted()
//{
//}

QString BrowserView::getCurrentName()
{
    if (curWebView)
        return curWebView->title();
    else
        return QString();
}

void BrowserView::onUnsupportedContent (QNetworkReply * reply)
{
    if (!reply)
         return;

    if (reply->error() != QNetworkReply::NoError)
        return;

    if (reply->header(QNetworkRequest::ContentTypeHeader).isValid() != true)
        return;

    if (reply->header(QNetworkRequest::ContentTypeHeader).toString().toLower() == "image/pjpeg") {
        m_unsupReply = reply;
        m_unsupReply->setParent(this);
        if (m_unsupReply->isFinished())
            unsupportedReplyFinished();
        else {
            connect(m_unsupReply, SIGNAL(finished()), SLOT(unsupportedReplyFinished()));
        }
        m_unsupHandled = true;
        return;
    }

    qDebug() << "Unsuported: " << reply->url() << reply->header(QNetworkRequest::ContentTypeHeader);

//    if (QMessageBox::question(0, tr("Launch File"), tr("Do you really want to launch this file?"), QMessageBox::Ok | QMessageBox::Cancel) == QMessageBox::Ok) {
//        m_downloader = new Downloader(this, reply);
//        connect(m_downloader, SIGNAL(done()), m_downloader, SLOT(deleteLater()));
//        m_unsupHandled = true;
//    } else
//        reply->abort();
    emit unsupportedContent(reply->url());
    reply->abort();
}

void BrowserView::onDownloadRequested (const QNetworkRequest & request)
{
//    if (m_unsupReply)
//        m_downloader = new Downloader(this, m_unsupReply->request(), (QNetworkCookieJar *)m_cookiejar);
//    else
//        m_downloader = new Downloader(this, request, (QNetworkCookieJar *)m_cookiejar);
//    connect(m_downloader, SIGNAL(done()), m_downloader, SLOT(deleteLater()));
//    m_downloader->go();
    emit downloadRequested(request.url());
}

void BrowserView::unsupportedReplyFinished()
{
    QByteArray ba = m_unsupReply->readAll();
    curWebView->setContent(ba, QString("image/jpeg"));
//    QFile* m_out = new QFile("c:/tmp.jpg");
//    m_out->open(QIODevice::WriteOnly);
//    m_out->write(unsupReply->readAll());
//    m_out->close();

    m_unsupReply->close();
}

QUrl BrowserView::url()
{
    if (!curWebView || !curWebView->page())
        return QUrl();

    return curWebView->url();
}

void BrowserView::onLinkClicked(const QUrl &url)
{
    if (m_delegateLinks)
        emit linkClicked(url);
    else
        seturl(url);
}

QAction* BrowserView::backAction() const
{
    return curWebView->page()->action(QWebPage::Back);
}

QAction* BrowserView::forwardAction() const
{
    return curWebView->page()->action(QWebPage::Forward);
}

QAction* BrowserView::reloadAction() const
{
    return curWebView->page()->action(QWebPage::Reload);
}

QAction* BrowserView::stopAction() const
{
    return curWebView->page()->action(QWebPage::Stop);
}

void BrowserView::setProgress(int progress)
{
    m_progress = progress;
    emit progressChanged();
}

