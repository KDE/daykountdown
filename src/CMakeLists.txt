set(daykountdown_SRCS
    main.cpp
    )

qt5_add_resources(RESOURCES resources.qrc)
add_executable(daykountdown ${daykountdown_SRCS} ${RESOURCES})
target_link_libraries(daykountdown Qt5::Core Qt5::Qml Qt5::Quick Qt5::Gui)
