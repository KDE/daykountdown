import QtQuick 2.1
import QtQuick.Layouts 1.1
import org.kde.kirigami 2.0 as Kirigami
import QtQuick.Controls 2.4 

Kirigami.ApplicationWindow {
    id: root

    title: "Day Kountdown"

    pageStack.initialPage: mainPageComponent

    Component {
        id: mainPageComponent
        
        Kirigami.ScrollablePage {
            title: "Kountdown"
            
            actions.main: Kirigami.Action {
                icon.name: "add"
                text: i18n("Add kountdown")
            }
            
            ColumnLayout {
                width: parent.width
                
                Kirigami.Heading {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    property var date: new Date()
                    text: `${i18n("Today is")} ${date.toLocaleDateString()}`
                    level: 1
                    wrapMode: Text.Wrap
                }
            }
            
            ListView {
                id: listView
                Kirigami.Label {
                    anchors.centerIn: parent
                    visible: listView.count === 0
                    text: i18n("Add some kountdowns!")
                }
            }
        }
    }
}

