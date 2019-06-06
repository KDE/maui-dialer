

set(dialer_SRCS
    main.cpp
    dialerutils.cpp
    call-handler.cpp
    call-manager.cpp
)

add_executable(${PROJECT_NAME} ${dialer_SRCS})
target_compile_definitions(${PROJECT_NAME} PRIVATE -DPROJECT_VERSION="${PROJECT_VERSION}")

#find_package(ActiveApp REQUIRED)
find_package(PhoneNumber COMPONENTS PhoneNumber REQUIRED)

target_link_libraries(${PROJECT_NAME}
 PhoneNumber::PhoneNumber
 Qt5::Gui
 Qt5::Quick
 Qt5::Widgets
 KF5::Declarative
 KF5::I18n
 KF5::Package
 KF5::QuickAddons
 KF5::DBusAddons
 KF5::Notifications
 ${TELEPATHY_QT5_LIBRARIES}
)

install(TARGETS ${PROJECT_NAME} ${INSTALL_TARGETS_DEFAULT_ARGS})
#install(FILES plasma_dialer.notifyrc DESTINATION ${KDE_INSTALL_KNOTIFY5RCDIR})

#configure_file(org.freedesktop.Telepathy.Client.Plasma.Dialer.service.in
#                org.freedesktop.Telepathy.Client.Plasma.Dialer.service)
#install(FILES ${CMAKE_CURRENT_BINARY_DIR}/org.freedesktop.Telepathy.Client.Plasma.Dialer.service
#        DESTINATION ${DBUS_SERVICES_INSTALL_DIR})

#install(FILES Plasma.Dialer.client DESTINATION ${SHARE_INSTALL_PREFIX}/telepathy/clients/)

#elseif(${CMAKE_SYSTEM_PROCESSOR} MATCHES "arm")
#    add_subdirectory(src/dialer/linux)

#    target_link_libraries(${PROJECT_NAME}
#        PhoneNumber::PhoneNumber
#        Qt5::Gui
#        Qt5::Quick
#        ${TELEPATHY_QT5_LIBRARIES}
#        KF5::Declarative
#        KF5::Package
#        KF5::QuickAddons
#        KF5::DBusAddons)
