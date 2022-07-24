set(daykountdown_SRCS
    main.cpp
    kountdownmodel.cpp
    importexport.cpp
    aboutdatapasser.cpp
    resources.qrc
    )

add_executable(daykountdown ${daykountdown_SRCS})

ecm_add_app_icon(DAYKOUNTDOWN_ICON ICONS ${CMAKE_SOURCE_DIR}/org.kde.daykountdown.png)
target_sources(daykountdown PRIVATE ${DAYKOUNTDOWN_ICON})
target_link_libraries(daykountdown 
	Qt::Quick
	Qt::QuickControls2
	Qt::Qml
	Qt::Gui
	Qt::Sql
	Qt::Svg
	KF5::Kirigami2
	KF5::I18n
	KF5::CoreAddons
	KF5::ConfigCore
	KF5::ConfigGui
	KF5::WidgetsAddons
	KF5::KIOCore)
kconfig_add_kcfg_files(daykountdown GENERATE_MOC daykountdownconfig.kcfgc)

if(ANDROID)
    kirigami_package_breeze_icons(ICONS
        "help-about"
        "document-open"
        "document-save"
        "edit-clear"
        "list-add"
        "configure"
    )
endif()

install(TARGETS daykountdown ${KF5_INSTALL_TARGETS_DEFAULT_ARGS})
