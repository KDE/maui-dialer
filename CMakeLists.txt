project(union)

cmake_minimum_required(VERSION 3.1)

project(union LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(ECM 1.7.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${ECM_MODULE_PATH})

find_package(MauiKit REQUIRED)
find_package(Qt5 REQUIRED NO_MODULE COMPONENTS Qml Quick Sql Svg QuickControls2 Widgets)
include(KDEInstallDirs)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(KDECMakeSettings)
include(ECMInstallIcons)
include(FeatureSummary)
include(ECMAddAppIcon)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTORCC ON)


include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/src/libs/libvcard/include/vcard
    ${CMAKE_CURRENT_BINARY_DIR}/src/libs/libvcard/include/vcard
    )

set(union_SRCS
    src/main.cpp
    src/interfaces/synchroniser.cpp
    src/db/db.cpp
    src/db/dbactions.cpp
    src/models/baselist.cpp
    src/models/basemodel.cpp
    src/models/contacts/contactsmodel.cpp
    src/interfaces/kcontactsinterface.cpp

    src/libs/libvcard/libvcard/vcard.cpp
    src/libs/libvcard/libvcard/vcardparam.cpp
    src/libs/libvcard/libvcard/vcardproperty.cpp

    )

set(union_HDRS
    src/libs/libvcard/include/vcard/vcardproperty.h
    src/libs/libvcard/include/vcard/vcardparam.h
    src/libs/libvcard/include/vcard/vcard.h

    src/union.h
    src/db/db.h
    src/db/dbactions.h
    src/interfaces/synchroniser.h
    src/models/baselist.h
    src/models/basemodel.h
    src/models/contacts/contactsmodel.h
    src/interfaces/kcontactsinterface.h
    )

set(union_ASSETS
    src/qml.qrc
    assets/union_assets.qrc
    )

add_executable(union
    ${union_SRCS}
    ${union_HDRS}
    ${union_ASSETS}
    )

if (ANDROID)
    find_package(Qt5 REQUIRED COMPONENTS AndroidExtras)

    target_link_libraries(vvave Qt5::AndroidExtras)
    #    kde_source_files_enable_exceptions(union src/pix.cpp)
else()
    find_package(KF5 ${KF5_VERSION} REQUIRED COMPONENTS I18n Notifications Config KIO Attica Contacts People)
    find_package(Qt5 REQUIRED COMPONENTS WebEngine)

    target_link_libraries(union KF5::ConfigCore KF5::Notifications KF5::KIOCore KF5::I18n KF5::Attica KF5::Contacts KF5::People)
endif()

if (TARGET create-apk-union)
    set_target_properties(create-apk-union PROPERTIES ANDROID_APK_DIR "${MAUIKIT_ANDROID_DIR}")
endif()

target_link_libraries(union MauiKit Qt5::Sql Qt5::Qml Qt5::Widgets Qt5::Svg)

install(TARGETS union ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
#install(FILES org.kde.pix.desktop DESTINATION ${XDG_APPS_INSTALL_DIR})

#TODO: port to ecm_install_icons()
#install(FILES assets/pix.svg DESTINATION ${KDE_INSTALL_ICONDIR}/hicolor/scalable/apps)
#install(FILES org.kde.pix.appdata.xml DESTINATION ${KDE_INSTALL_METAINFODIR})

feature_summary(WHAT ALL   FATAL_ON_MISSING_REQUIRED_PACKAGES)
