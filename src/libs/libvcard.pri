QT += core

HEADERS += \
    $$PWD/libvcard/include/vcard/vcard.h \
    $$PWD/libvcard/include/vcard/vcardparam.h \
    $$PWD/libvcard/include/vcard/vcardproperty.h

SOURCES += \
    $$PWD/libvcard/libvcard/vcard.cpp \
    $$PWD/libvcard/libvcard/vcardparam.cpp \
    $$PWD/libvcard/libvcard/vcardproperty.cpp

DEPENDPATH += \
    $$PWD/libvcard/include/vcard \

INCLUDEPATH += \
    $$PWD/libvcard/include/vcard \
