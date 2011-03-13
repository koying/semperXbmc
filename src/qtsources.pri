QT += network

DEPENDPATH += src
INCLUDEPATH += src

SOURCES += \
    XbmcEventClient.cpp

HEADERS += \
    XbmcEventClient.h

!symbian {
    LIBS += -lws2_32
}
