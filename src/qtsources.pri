QT += network

DEPENDPATH += src
INCLUDEPATH += src

SOURCES += \
    XbmcEventClient.cpp \
    NetworkAccessManagerFactory.cpp \
    ThumbImageProvider.cpp \
    src/VariantModel.cpp \
    src/ThumbnailCache.cpp \
    src/SortFilterModel.cpp \
    src/XbmcTcpTransport.cpp \
    src/Haptics.cpp \
    src/Download.cpp

HEADERS += \
    XbmcEventClient.h \
    NetworkAccessManagerFactory.h \
    ThumbImageProvider.h \
    src/VariantModel.h \
    src/ThumbnailCache.h \
    src/SortFilterModel.h \
    src/XbmcTcpTransport.h \
    src/Haptics.h \
    src/Download.h

!symbian {
    LIBS += -lws2_32
}

