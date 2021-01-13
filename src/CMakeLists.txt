qt5_add_resources(daykountdown_SRCS resources.qrc)
add_executable(daykountdown main.cpp ${test_SRCS})
target_link_libraries(daykountdown Qt5::Qml Qt5::Gui)

