#ifndef MWEBPAGE_H
#define MWEBPAGE_H

#include <QWebPage>

class MWebPage : public QWebPage
{
    Q_OBJECT

public:
    MWebPage(QObject * parent = 0);
    ~MWebPage();

    virtual void triggerAction(WebAction action, bool checked = false);

protected:
    QString userAgentForUrl ( const QUrl & url ) const;
    bool acceptNavigationRequest(QWebFrame *frame, const QNetworkRequest &request, NavigationType type);
    void javaScriptAlert(QWebFrame *frame, const QString &msg);
    bool javaScriptConfirm(QWebFrame *frame, const QString &msg);
    bool javaScriptPrompt(QWebFrame *frame, const QString &msg, const QString &defaultValue, QString *result);
    void javaScriptConsoleMessage(const QString &message, int lineNumber, const QString &sourceID);
    bool shouldInterruptJavaScript();
    QWebPage *createWindow(QWebPage::WebWindowType type);

private slots:
#if (QTWEBKIT_VERSION >= 0x020100)
    void onFeaturePermissionRequested(QWebFrame* frame, QWebPage::Feature feature);
//    void onFeaturePermissionRequestCanceled(QWebFrame* frame, QWebPage::Feature feature);
#endif
};

#endif // MWEBPAGE_H
