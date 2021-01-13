import QtQuick 2.1
import QtQuick.Layouts 1.1
import org.kde.kirigami 2.4 as Kirigami
import QtQuick.Controls 2.0 as Controls

Kirigami.ApplicationWindow {
    id: root

    title: "Day Kountdown"

    pageStack.initialPage: mainPageComponent

    Component {
        id: mainPageComponent

        Kirigami.ScrollablePage {
            title: "Kountdown"
            ColumnLayout {
                width: parent.width
                    
                Kirigami.Label {
                    text: "pooper"
                }
            }
            
            ListView {
                    id: listView
            }
        }
    }
}

