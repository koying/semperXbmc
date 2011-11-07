# Add more folders to ship with the application, here
folder_01.source = qml
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

symbian:TARGET.UID3 = 0xE56B2B32

# Allow network access on Symbian
symbian:TARGET.CAPABILITY += NetworkServices

# Define QMLJSDEBUGGER to allow debugging of QML in debug builds
# (This might significantly increase build time)
# DEFINES += QMLJSDEBUGGER

# If your application uses the Qt Mobility libraries, uncomment
# the following lines and add the respective components to the
# MOBILITY variable.
 CONFIG += mobility
 MOBILITY += feedback

VERSION = 0.9.4
DEFINES += APP_VERSION=$$VERSION
TARGET.EPOCHEAPSIZE = 0x200000  0x5000000
ICON = semperXbmc_Anna_converted.svg

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp
include (src/qtsources.pri)

INCLUDEPATH +=src/QFatFs
DEPENDPATH += src/QFatFs
include(src/QFatFs/QFatFs.pri)

#INCLUDEPATH += ../QFatFs/QFatFs
#DEPENDPATH += ../QFatFs/QFatFs
#include(../QFatFs/QFatFs/QFatFs.pri)

symbian {
    contains(S60_VERSION, 5.0): __NOWEBKIT=1
}

contains(__ING,1) {
   DEFINES += __ING
}

contains(__NOWEBKIT,1) {
    DEFINES += __NOWEBKIT
} else {
    QT += webkit

    INCLUDEPATH +=src/BrowserView
    DEPENDPATH += src/BrowserView
    include(src/BrowserView/BrowserView.pri)

    simulator {
        QTSCROLLER_OUT = ../qtscroller-build-simulator
    } else {
        win32:QTSCROLLER_OUT = ../qtscroller-build-desktop
    }

    include(../qtscroller/qtscroller.pri)
}

RESOURCES += \
    qml/resource.qrc


# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()


