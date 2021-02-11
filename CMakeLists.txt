project(daykountdown)

cmake_minimum_required(VERSION 3.10)
set(KF5_MIN_VERSION "5.18.0")
set(QT_MIN_VERSION "5.5.0")

################# set KDE specific information #################

find_package(ECM 0.0.8 REQUIRED NO_MODULE)

# where to look first for cmake modules, before ${CMAKE_ROOT}/Modules/ is checked
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR})

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

find_package(Qt5 ${QT_MIN_VERSION} REQUIRED NO_MODULE COMPONENTS Core Quick Test Gui QuickControls2 Svg Sql)
set_package_properties(Qt5 PROPERTIES
    TYPE REQUIRED
    PURPOSE "Basic application components"
)

find_package(KF5 ${KF5_MIN_VERSION} REQUIRED COMPONENTS KIO Kirigami2 I18n CoreAddons WidgetsAddons)
set_package_properties(KF5 PROPERTIES
    TYPE REQUIRED
    PURPOSE "Basic application components"
)

################# Enable C++11 features for clang and gcc #################

set(CMAKE_CXX_STANDARD 11)

set(CMAKE_AUTOMOC ON)

################# build and install #################
install(FILES org.kde.daykountdown.desktop DESTINATION ${KDE_INSTALL_APPDIR})
install(FILES org.kde.daykountdown.svg DESTINATION ${KDE_INSTALL_FULL_ICONDIR}/hicolor/scalable/apps)

add_subdirectory(src)

feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)
