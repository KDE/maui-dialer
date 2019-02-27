QT += qml
QT += quick
QT += sql
QT += widgets
QT += quickcontrols2

CONFIG += c++11
CONFIG += ordered

TARGET = union
TEMPLATE = app

linux:unix:!android {

    message(Building for Linux KDE)
    QT += webengine
    LIBS += -lMauiKit

} else:android {

    message(Building helpers for Android)
    QT += androidextras webview

    include($$PWD/3rdparty/openssl/openssl.pri)
    include($$PWD/mauikit/mauikit.pri)
    include($$PWD/3rdparty/kirigami/kirigami.pri)

    DEFINES += STATIC_KIRIGAMI

} else {
    message("Unknown configuration")
}


SOURCES += \
    $$PWD/src/main.cpp \
    src/models/baselist.cpp \
    src/models/basemodel.cpp \
    src/models/contacts/contactsmodel.cpp \
    src/interfaces/syncing.cpp

RESOURCES += \
    $$PWD/src/qml.qrc \
    $$PWD/assets/union_assets.qrc

qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    src/union.h \
    src/models/baselist.h \
    src/models/basemodel.h \
    src/models/contacts/contactsmodel.h \
    src/interfaces/syncing.h

