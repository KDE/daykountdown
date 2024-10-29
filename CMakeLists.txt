cmake_minimum_required(VERSION 3.10)

project(daykountdown)

set(KF_MIN_VERSION "6.3.0")
set(QT_MIN_VERSION "6.5.0")

################# set KDE specific information #################

find_package(ECM ${KF_MIN_VERSION} REQUIRED NO_MODULE)

# where to look first for cmake modules, before ${CMAKE_ROOT}/Modules/ is checked
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH})

include(FeatureSummary)
include(ECMSetupVersion)
include(ECMGenerateHeaders)
include(KDEInstallDirs)
include(KDEClangFormat)
include(KDECMakeSettings)
include(ECMPoQmTools)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(ECMAddAppIcon)

################# Find dependencies #################

find_package(Qt6 ${QT_MIN_VERSION} REQUIRED NO_MODULE COMPONENTS Core Quick Test Gui QuickControls2 Svg Sql)
set_package_properties(Qt6 PROPERTIES
    TYPE REQUIRED
    PURPOSE "Basic application components"
)

find_package(KF6 ${KF_MIN_VERSION} REQUIRED COMPONENTS KIO Kirigami I18n CoreAddons WidgetsAddons)
set_package_properties(KF6 PROPERTIES
    TYPE REQUIRED
    PURPOSE "Basic application components"
)

find_package(KF6KirigamiAddons 1.4.0 REQUIRED)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

################# build and install #################
install(FILES org.kde.daykountdown.desktop DESTINATION ${KDE_INSTALL_APPDIR})
install(FILES org.kde.daykountdown.svg DESTINATION ${KDE_INSTALL_FULL_ICONDIR}/hicolor/scalable/apps)

add_subdirectory(src)

ki18n_install(po)

feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)
