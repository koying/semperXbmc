#include "MWebView.h"

#include "BrowserView.h"

#include <QSysInfo>
#include <QApplication>
#include <QMouseEvent>
#include <QPainter>
#include <QMenu>
#include <QGesture>
#include <QMessageBox>
#include <QClipboard>
#include <QGraphicsSceneContextMenuEvent>
#include <QGestureEvent>

#include <QtScroller>
#include <QtScrollerProperties>
#include <QtScrollEvent>
#include <QtScrollPrepareEvent>

#define ZOOM_STEP 1.10

MWebView::MWebView(BrowserView * parent)
    : QGraphicsWebView(parent)
    , m_BrowserView(parent)
    , m_zoomedIn(false)
    , m_zoomedOut(false)
    , m_initZoom(1.0)
    , m_isPinching(false)
{
    m_copyUrlAction = new QAction(tr("Copy page URL"), this);
    connect(m_copyUrlAction, SIGNAL(triggered()), SLOT(onCopyUrlAction()));
    m_GotoClipboardUrlAction = new QAction(tr("Goto clipboard URL"), this);
    connect(m_GotoClipboardUrlAction, SIGNAL(triggered()), SLOT(onGotoClipboardUrlAction()));

    setAcceptTouchEvents(true); //set this to receive touch events
    grabGesture(Qt::PinchGesture);

    QtScroller::grabGesture(this, QtScroller::LeftMouseButtonGesture);
    QtScroller* s = QtScroller::scroller(this);
    QtScrollerProperties p = s->scrollerProperties();
    p.setScrollMetric(QtScrollerProperties::HorizontalOvershootPolicy, QtScrollerProperties::OvershootAlwaysOff);
    p.setScrollMetric(QtScrollerProperties::VerticalOvershootPolicy, QtScrollerProperties::OvershootAlwaysOff);
    s->setScrollerProperties(p);
}

bool MWebView::event(QEvent *e)
{
    switch (e->type()) {
    case QtScrollPrepareEvent::ScrollPrepare: {
        QtScrollPrepareEvent *se = static_cast<QtScrollPrepareEvent *>(e);
        se->setViewportSize(size());
        QSize sz = page()->mainFrame()->contentsSize();
//        qDebug() << "QtScrollPrepareEvent: " << sz << page()->mainFrame()->contentsSize();
        se->setContentPosRange(QRectF(0, 0,
                                      qMax(qreal(0), sz.width() - size().width()),
                                      qMax(qreal(0), sz.height() - size().height())));
        se->setContentPos(page()->mainFrame()->scrollPosition());
        se->accept();
        return true;
    }

    case QtScrollEvent::Scroll: {
        QtScrollEvent *se = static_cast<QtScrollEvent *>(e);
//        qDebug() << "Scrolling: " << pos() << se->contentPos();
//        setPos(-se->contentPos());
        page()->mainFrame()->setScrollPosition(se->contentPos().toPoint());
        return true;
    }

    default:
        break;
    }
    return QGraphicsWebView::event(e);
}

void MWebView::mousePressEvent(QGraphicsSceneMouseEvent* event)
{
    QPointF pressPoint = event->pos();
    QGraphicsWebView::mousePressEvent(event);

    QWebHitTestResult hit = page()->mainFrame()->hitTestContent(pressPoint.toPoint());
    if (hit.isContentEditable())
        m_BrowserView->forceActiveFocus();
    setFocus();
}

bool MWebView::sceneEvent(QEvent *e)
{
    switch (e->type()) {
    case QEvent::TouchBegin: {
        qDebug() << "TouchBegin";
        // We need to return true for the TouchBegin here in the
        // top-most graphics object - otherwise gestures in our parent
        // objects will NOT work at all (the accept() flag is already
        // set due to our setAcceptTouchEvents(true) call in the c'tor
        return true;

    }
//    case QEvent::GraphicsSceneMousePress: {
//        // We need to return true for the MousePress here in the
//        // top-most graphics object - otherwise gestures in our parent
//        // objects will NOT work at all (the accept() flag is already
//        // set to true by Qt)
//        return true;

//    }
    case QEvent::Gesture:
        return gestureEvent(static_cast<QGestureEvent*>(e));
        break;

    default:
        break;
    }
    return QGraphicsWebView::sceneEvent(e);
}

bool MWebView::gestureEvent(QGestureEvent *event)
{
//    qDebug() << "gestureEvent";
    if (QGesture *pinch = event->gesture(Qt::PinchGesture)){
        pinchTriggered(static_cast<QPinchGesture *>(pinch));
        return true;
    }
    return false;
}

void MWebView::pinchTriggered(QPinchGesture *gesture)
{
//    qDebug() << "pinchTriggered";
    QPinchGesture::ChangeFlags changeFlags = gesture->changeFlags();
    if (changeFlags & QPinchGesture::ScaleFactorChanged) {
        qreal value = gesture->scaleFactor();
        qreal factor = value*zoomFactor();

        qDebug()<< "zooming";
        switch (gesture->state()) {
        case Qt::GestureStarted:
        case Qt::GestureUpdated:
            scaleZoom(value, pos(), mapToScene(gesture->centerPoint()));
            m_isPinching = true;
            break;

        case Qt::GestureFinished:
            setPos(0,0);
            setScale(1.);
            zoom(gesture->totalScaleFactor(), page()->mainFrame()->scrollPosition(), gesture->centerPoint());
            m_isPinching = false;
            break;

        case Qt::GestureCanceled:
            setPos(0,0);
            setScale(1.);
            m_isPinching = false;
            break;
        }
    }
}

qreal MWebView::getMaxZoom()
{
    return (double)size().width() / page()->mainFrame()->contentsSize().width() * zoomFactor();
}

void MWebView::zoomIn()
{
    double currentZoom = zoomFactor() * ZOOM_STEP;
    setZoomFactor(currentZoom);
}

void MWebView::zoomOut()
{
    double currentZoom = zoomFactor() / ZOOM_STEP;
    setZoomFactor(currentZoom);
}

void MWebView::zoomBest()
{
    QWebFrame *frame = page()->mainFrame();
    QPoint lastZoomedPoint = frame->scrollPosition();

    setZoomFactor(getMaxZoom());
    m_zoomedOut = true;
    m_zoomedIn = false;

    frame->setScrollPosition(lastZoomedPoint);
}

bool MWebView::isZoomed()
{
    return (zoomFactor() != m_initZoom);
}

void MWebView::zoom100()
{
    setZoomFactor(m_initZoom);
}

void MWebView::contextMenuEvent(QGraphicsSceneContextMenuEvent *event)
{
    if (m_isPinching)
        return;

    page()->updatePositionDependentActions(event->scenePos().toPoint());
    QMenu* ctxMenu = page()->createStandardContextMenu();
    ctxMenu->addSeparator();
    ctxMenu->addAction(m_copyUrlAction);

    QClipboard *clip = QApplication::clipboard();
    if (clip && clip->mimeData()) {
        QUrl u(clip->mimeData()->text());
        if (u.isValid() && !u.host().isEmpty())
            if (u != url()) {
                m_GotoClipboardUrlAction->setText(QString("Goto clipboard URL (%1)").arg(u.host()));
                ctxMenu->addAction(m_GotoClipboardUrlAction);
            }
    }

    ctxMenu->exec(event->screenPos());
    event->accept();
}

void MWebView::onCopyUrlAction()
{
    QClipboard* clip = qApp->clipboard();
    clip->setText(url().toString());
}

void MWebView::onGotoClipboardUrlAction()
{
    QClipboard *clip = QApplication::clipboard();
    QUrl u(clip->mimeData()->text());
    if (u.isValid()) {
        m_BrowserView->seturl(u);
    }
}

void MWebView::zoom(qreal reqFactor, QPointF viewPos, QPointF eventPos)
{
    qreal factor = qMax(reqFactor*zoomFactor(), getMaxZoom());

    QPointF p2 =  viewPos * (factor / zoomFactor());
    QPointF pos2 = eventPos * (factor / zoomFactor());
    p2 += pos2 - eventPos;

    setZoomFactor(factor);
    page()->mainFrame()->setScrollPosition(p2.toPoint());
}

void MWebView::scaleZoom(qreal reqFactor, QPointF viewPos, QPointF eventPos)
{
    QPointF p2 =  viewPos * reqFactor;
    QPointF pos2 = eventPos * reqFactor;
    p2 -= pos2 - eventPos;

    setScale(reqFactor*scale());
    setPos(p2);
}

void MWebView::mouseDoubleClickEvent(QGraphicsSceneMouseEvent *ev)
{
//    if (zoomFactor() == m_initZoom)
//        zoomBest();
//    else
//        zoom(m_initZoom/zoomFactor(), page()->mainFrame()->scrollPosition(), ev->pos());

//    qreal targetZoom;
//    if (m_zoomedIn || m_zoomedOut) {
//        targetZoom = m_initZoom;
//        m_zoomedIn = false;
//        m_zoomedOut = false;
//    } else {
//        targetZoom = m_initZoom * 2.0;
//        m_zoomedIn = true;
//    }
//    zoom(targetZoom, page()->mainFrame()->scrollPosition(), event->pos());
}

void MWebView::wheelEvent(QGraphicsSceneWheelEvent *ev)
{
    qreal finalZoom = 1.;
    int Steps = ev->delta() / 120;
    if (Steps > 0) {
        for (int i = 0; i < Steps; ++i) {
            finalZoom *= 150/100.0;
        }
    } else if (Steps < 0) {
        for (int i = 0; i < -Steps; ++i) {
            finalZoom *= 75/100.0;
        }
    }

    // Do not overzoom in one go (circular scroll on touchpads can scroll very
    // fast). Without this check we can end up scaling the background by e.g.
    // 40 times in each direction and running out of memory.
    if (finalZoom > 2.0)
        finalZoom = 2.0;
    else if (finalZoom < 0.5)
        finalZoom = 0.5;

//    zoom(finalZoom, page()->mainFrame()->scrollPosition(), ev->pos());
    qDebug() << scale() << pos() << mapToScene(ev->pos());
    if (ev->modifiers() & Qt::ControlModifier)
        scaleZoom(finalZoom, pos(), mapToScene(ev->pos()));
    else {
        zoom(finalZoom, page()->mainFrame()->scrollPosition(), ev->pos());
        setPos(0, 0);
        setScale(1.);
    }

    qDebug() << "vp size: " << page()->viewportSize() << " content sz: " << page()->mainFrame()->contentsSize();
}
