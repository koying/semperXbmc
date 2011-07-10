QT += network

DEPENDPATH += src
INCLUDEPATH += src

SOURCES += \
    XbmcEventClient.cpp \
    src/NetworkAccessManagerFactory.cpp \
    src/SortFilterModel.cpp

HEADERS += \
    XbmcEventClient.h \
    src/NetworkAccessManagerFactory.h \
    src/SortFilterModel.h

!symbian {
    LIBS += -lws2_32
}
