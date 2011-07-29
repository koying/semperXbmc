#ifndef MWEBVIEW_H
#define MWEBVIEW_H

#include <QtWebKit>

class BrowserView;
class QGestureEvent;
class QPinchGesture;

class MWebView : public QGraphicsWebView
{
    Q_OBJECT

public:
    MWebView(BrowserView * parent = 0);

protected:
    void contextMenuEvent(QGraphicsSceneContextMenuEvent *event);
    bool gestureEvent(QGestureEvent *event);
    void pinchTriggered(QPinchGesture *gesture);

    void mouseDoubleClickEvent(QGraphicsSceneMouseEvent *event);
    void wheelEvent ( QGraphicsSceneWheelEvent * ev ) ;

    bool event(QEvent *e);
    bool sceneEvent(QEvent *e);

    qreal getMaxZoom();

protected slots:
    void onCopyUrlAction();
    void onGotoClipboardUrlAction();

public slots:
    void zoomIn();
    void zoomOut();
    void zoomBest();
    void zoom100();

public:
    bool isZoomed();

private:
    BrowserView* m_BrowserView;
    double scaleRatio;
    double curZoom;

    qreal m_initZoom;
    bool m_zoomedIn;
    bool m_zoomedOut;

    bool m_isPinching;

    QAction* m_copyUrlAction;
    QAction* m_GotoClipboardUrlAction;

    void zoom(qreal factor, QPointF p, QPointF pos);
    void scaleZoom(qreal reqFactor, QPointF viewPos, QPointF eventPos);
};

#endif // MWEBVIEW_H
