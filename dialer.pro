QT += qml
QT += quick
QT += sql
QT += widgets
QT += quickcontrols2
QT += concurrent

CONFIG += ordered
CONFIG += c++17
QMAKE_LINK += -nostdlib++

TARGET = dialer
TEMPLATE = app

linux:unix:!android {

    message(Building for Linux KDE)
    QT += webengine
    QT += KService KNotifications KNotifications KI18n KContacts
    QT += KIOCore KIOFileWidgets KIOWidgets KNTLM
    LIBS += -lMauiKit

#    SOURCES += src/interfaces/kcontactsinterface.cpp
#    HEADERS += src/interfaces/kcontactsinterface.h


} else:android {

    message(Building helpers for Android)
    QT += androidextras webview
    include($$PWD/3rdparty/openssl/openssl.pri)
    include($$PWD/3rdparty/mauikit/mauikit.pri)
    include($$PWD/3rdparty/kirigami/kirigami.pri)

    DEFINES += STATIC_KIRIGAMI

} else {
    message("Unknown configuration")
}

DEPENDPATH += \
    $$PWD/src/interfaces \
    $$PWD/src/models \
    $$PWD/src/models/contacts

INCLUDEPATH += \
    $$PWD/src/interfaces \
    $$PWD/src/models \
    $$PWD/src/models/contacts

SOURCES += \
    $$PWD/src/main.cpp \
    $$PWD/src/interfaces/androidinterface.cpp \
    $$PWD/src/interfaces/contactimage.cpp \
    $$PWD/src/models/contacts/calllogs.cpp \
    $$PWD/src/models/contacts/contactsmodel.cpp \

RESOURCES += \
    $$PWD/src/qml.qrc \
    $$PWD/assets/union_assets.qrc

HEADERS += \
     $$PWD/src/union.h \
    $$PWD/src/interfaces/androidinterface.h \
     $$PWD/src/models/contacts/contactsmodel.h \
     $$PWD/src/models/contacts/calllogs.h \
     $$PWD/src/interfaces/abstractinterface.h \
     $$PWD/src/interfaces/contactimage.h


qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target


contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    ANDROID_PACKAGE_SOURCE_DIR = \
        $$PWD/3rdparty/mauikit/src/android
}

