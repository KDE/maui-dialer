QT += qml
QT += quick
QT += sql
QT += widgets
QT += quickcontrols2
QT += concurrent

CONFIG += c++11
CONFIG += ordered

TARGET = communicator
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
    LIBS += -ljnigraphics
    include($$PWD/3rdparty/openssl/openssl.pri)
    include($$PWD/mauikit/mauikit.pri)
    include($$PWD/3rdparty/kirigami/kirigami.pri)

    DEFINES += STATIC_KIRIGAMI

    SOURCES +=  src/interfaces/androidintents.cpp
    HEADERS += src/interfaces/androidintents.h

} else {
    message("Unknown configuration")
}

SOURCES += \
    $$PWD/src/main.cpp \
    src/interfaces/contactimage.cpp \
    src/models/baselist.cpp \
    src/models/basemodel.cpp \
    src/models/contacts/calllogs.cpp \
    src/models/contacts/contactsmodel.cpp \
    src/interfaces/synchroniser.cpp \
    src/db/db.cpp \
    src/db/dbactions.cpp \

RESOURCES += \
    $$PWD/src/qml.qrc \
    $$PWD/assets/union_assets.qrc

qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    src/interfaces/contactimage.h \
    src/models/contacts/calllogs.h \
    src/union.h \
    src/db/db.h \
    src/db/dbactions.h \
    src/models/baselist.h \
    src/models/basemodel.h \
    src/models/contacts/contactsmodel.h \
    src/interfaces/synchroniser.h \

