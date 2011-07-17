QT += network

DEPENDPATH += src
INCLUDEPATH += src

SOURCES += \
    XbmcEventClient.cpp \
    NetworkAccessManagerFactory.cpp \
    ThumbImageProvider.cpp \
    src/VariantModel.cpp \
    src/ThumbnailCache.cpp \
    src/SortFilterModel.cpp

HEADERS += \
    XbmcEventClient.h \
    NetworkAccessManagerFactory.h \
    ThumbImageProvider.h \
    src/VariantModel.h \
    src/ThumbnailCache.h \
    src/SortFilterModel.h

!symbian {
    LIBS += -lws2_32
}

RESOURCES += \
    src/resource.qrc
