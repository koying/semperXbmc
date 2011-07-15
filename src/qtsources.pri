QT += network

DEPENDPATH += src
INCLUDEPATH += src

SOURCES += \
    XbmcEventClient.cpp \
    NetworkAccessManagerFactory.cpp \
    ThumbImageProvider.cpp

HEADERS += \
    XbmcEventClient.h \
    NetworkAccessManagerFactory.h \
    ThumbImageProvider.h

!symbian {
    LIBS += -lws2_32
}
