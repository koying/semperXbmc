QT += network

DEPENDPATH += src
INCLUDEPATH += src

SOURCES += \
    XbmcEventClient.cpp \
    src/NetworkAccessManagerFactory.cpp

HEADERS += \
    XbmcEventClient.h \
    src/NetworkAccessManagerFactory.h

!symbian {
    LIBS += -lws2_32
}
