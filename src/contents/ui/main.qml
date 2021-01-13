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
                icon.name: "create"
                text: i18n("Add kountdown")
                //onTriggered: pageStack.push(Qt.resolvedUrl("addPage.qml"))
                onTriggered: kountdownModel.append({"type": "potato", "age": 100})
            }
            
            ColumnLayout {
                width: parent.width
                
                Kirigami.Heading {
                    Layout.topMargin: Kirigami.Units.smallSpacing
                    Layout.bottomMargin: Kirigami.Units.smallSpacing
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    property var date: new Date()
                    text: `${i18n("Today is")} ${date.toLocaleDateString()}`
                    level: 1
                    wrapMode: Text.Wrap
                }
            }
            
            ListModel {
                id: kountdownModel
                ListElement { type: "Dog"; age: 8 }
                ListElement { type: "Cat"; age: 5 }
            }

            Component {
                id: kountdownDelegate
                Text { text: type + ", " + age }
            }
            
            ListView {
                id: listView
                model: kountdownModel
                delegate: kountdownDelegate
                
                Kirigami.Label {
                    anchors.centerIn: parent
                    visible: listView.count === 0
                    text: i18n("Add some kountdowns!")
                }
            }
        }
    }
}

