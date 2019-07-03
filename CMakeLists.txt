cmake_minimum_required(VERSION 3.1)

project(dialer LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(ECM 1.7.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${ECM_MODULE_PATH})

find_package(MauiKit REQUIRED)
find_package(Qt5 REQUIRED NO_MODULE COMPONENTS Qml Quick Sql Svg QuickControls2 Widgets Concurrent)
include(KDEInstallDirs)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(KDECMakeSettings)
include(ECMInstallIcons)
include(FeatureSummary)
include(ECMAddAppIcon)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTORCC ON)

set(dialer_SRCS
    src/main.cpp
    src/interfaces/synchroniser.cpp
    src/db/db.cpp
    src/db/dbactions.cpp
    src/models/baselist.cpp
    src/models/basemodel.cpp
    src/models/contacts/contactsmodel.cpp
    src/models/contacts/calllogs.cpp
    src/interfaces/kcontactsinterface.cpp
    src/interfaces/contactimage.cpp
    )

set(dialer_HDRS
    src/union.h
    src/db/db.h
    src/db/dbactions.h
    src/interfaces/synchroniser.h
    src/models/baselist.h
    src/models/basemodel.h
    src/models/contacts/contactsmodel.h
    src/models/contacts/calllogs.h
    src/interfaces/kcontactsinterface.h
    src/interfaces/contactimage.h
    )

set(dialer_ASSETS
    src/qml.qrc
    assets/union_assets.qrc
    )

add_executable(${PROJECT_NAME}
    ${dialer_SRCS}
    ${dialer_HDRS}
    ${dialer_ASSETS}
    )

if (ANDROID)
    find_package(Qt5 REQUIRED COMPONENTS AndroidExtras)

    target_link_libraries(${PROJECT_NAME} Qt5::AndroidExtras)
    #    kde_source_files_enable_exceptions(union src/pix.cpp)
elseif(${CMAKE_SYSTEM_PROCESSOR} MATCHES "arm")
add_subdirectory(src/dialer/linux)
else()
    find_package(KF5 ${KF5_VERSION} REQUIRED COMPONENTS I18n Notifications Config KIO Attica Contacts People )
    find_package(Qt5 REQUIRED COMPONENTS WebEngine)

    target_link_libraries(${PROJECT_NAME} KF5::ConfigCore KF5::Notifications KF5::KIOCore KF5::I18n KF5::Attica KF5::Contacts KF5::People  )
endif()

if (TARGET create-apk-dialer)
    set_target_properties(create-apk-dialer PROPERTIES ANDROID_APK_DIR "${MAUIKIT_ANDROID_DIR}")
endif()

target_link_libraries(${PROJECT_NAME} MauiKit Qt5::Sql Qt5::Qml Qt5::Widgets Qt5::Svg Qt5::Concurrent)

install(TARGETS ${PROJECT_NAME} ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
install(FILES org.kde.communicator.desktop DESTINATION ${XDG_APPS_INSTALL_DIR})

#TODO: port to ecm_install_icons()
install(FILES assets/communicator.svg DESTINATION ${KDE_INSTALL_ICONDIR}/hicolor/scalable/apps)
install(FILES org.maui.dialer.json DESTINATION /usr/share/maui-accounts/manifests)
#install(FILES org.kde.pix.appdata.xml DESTINATION ${KDE_INSTALL_METAINFODIR})

feature_summary(WHAT ALL   FATAL_ON_MISSING_REQUIRED_PACKAGES)
