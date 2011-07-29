#ifndef BROWSERVIEW_H
#define BROWSERVIEW_H

#include <QtWebKit>
#include <QWidget>
#include <QVector>
#include <QStack>
#include <QSslError>
#include <QList>
#include <QDeclarativeItem>

class QUrl;
class MWebPage;
class MWebView;
class QNetworkReply;
class QTimeLine;
class PersistentCookieJar;
class BrowserCache;

class BrowserView : public QDeclarativeItem
{
    Q_OBJECT

    friend class MWebView;
    friend class MWebPage;

/************* Properties *************/

    Q_PROPERTY(QUrl url READ url WRITE seturl NOTIFY urlChanged)
    Q_PROPERTY(QAction* reload READ reloadAction CONSTANT)
    Q_PROPERTY(QAction* back READ backAction CONSTANT)
    Q_PROPERTY(QAction* forward READ forwardAction CONSTANT)
    Q_PROPERTY(QAction* stop READ stopAction CONSTANT)

    Q_PROPERTY(bool delegateLinks READ delegateLinks WRITE setdelegateLinks)
public:
    bool delegateLinks() { return m_delegateLinks; }
    void setdelegateLinks(bool val) { m_delegateLinks = val; }
private:
    bool m_delegateLinks;

    Q_PROPERTY(QString userAgent READ userAgent WRITE setuserAgent)
public:
    QString userAgent() { return m_userAgent; }
    void setuserAgent(QString val) { m_userAgent = val; }
private:
    QString m_userAgent;

    Q_PROPERTY(int progress READ progress NOTIFY progressChanged)
public:
    int progress() { return m_progress; }

private:
    int m_progress;

/**************************************/

signals:
    void urlChanged();
    void unsupportedContent(const QUrl& url);
    void downloadRequested(const QUrl& url);
    void linkClicked(const QUrl& url);
    void progressChanged();

public:
    BrowserView(QDeclarativeItem * parent = 0);
    ~BrowserView();

    static BrowserView* instance() {
        return m_browserInstance;
    }
    static BrowserView* m_browserInstance;

    QString getCurrentName();

    QAction *reloadAction() const;
    QAction *backAction() const;
    QAction *forwardAction() const;
    QAction *stopAction() const;

public slots:
    void seturl(const QUrl &url);
    void setProgress(int progress);

    QUrl url();
    void stop();
    void reload();

private slots:
    void finish(bool);
#ifndef QT_NO_OPENSSL
    void slotSslErrors(QNetworkReply* rep,QList<QSslError>);
#endif
    void slotFrameCreated(QWebFrame * frame);
    void zoomBest();

    void onDownloadRequested (const QNetworkRequest & request);
    void onUnsupportedContent (QNetworkReply * reply);
    void unsupportedReplyFinished();

    void onLinkClicked(const QUrl& url);

signals:
    void loadingStarted();
    void loadingFinished();
    void loadingProgress(int progress);
    void menuButtonClicked();
    void preferencesClicked();

protected:
    void cleanupMemory();
    void addWebview();

    void geometryChanged ( const QRectF & newGeometry, const QRectF & oldGeometry );

protected:
    MWebView *curWebView;
    BrowserCache* m_cache;
    PersistentCookieJar* m_cookiejar;

    QNetworkReply* m_unsupReply;
    bool m_unsupHandled;
};

#endif // BROWSERVIEW_H
