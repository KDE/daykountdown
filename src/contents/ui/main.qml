import QtQuick 2.6
import QtQuick.Controls 2.0 as Controls
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.4 as Kirigami

Kirigami.ApplicationWindow {
    id: root

    title: "Day Kountdown"
    
    ListModel {
        id: kountdownModel
        ListElement { type: "Dog"; age: 8 }
        ListElement { type: "Cat"; age: 5 }
    }

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
            
            
            Kirigami.CardsListView {
                id: layout
                model: kountdownModel
                delegate: Kirigami.AbstractCard {
                    contentItem: Item {
                        implicitWidth: delegateLayout.implicitWidth
                        implicitHeight: delegateLayout.implicitHeight
                        GridLayout {
							id: delegateLayout
                            anchors {
                                left: parent.left
                                top: parent.top
                                right: parent.right
                            }
                            rowSpacing: Kirigami.Units.largeSpacing
                            columnSpacing: Kirigami.Units.largeSpacing 
                            columns: width > Kirigami.Units.gridUnit * 20 ? 4 : 2
                            
                            Kirigami.Heading {
								Layout.fillHeight: true
								Layout.preferredWidth: height
								level: 1
								text: "100"
							}
                            
							ColumnLayout {
								Kirigami.Heading {
									level: 2
									text: type
								}
								Kirigami.Separator {
									Layout.fillWidth: true
								}
								Controls.Label {
									Layout.fillWidth: true
									wrapMode: Text.WordWrap
									text: qsTr("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam id risus id augue euismod accumsan.")
								}
							}
                            Controls.Button {
                                Layout.alignment: Qt.AlignRight
                                Layout.columnSpan: 2 
                                text: "More"
                            }
                        }
                    }
                }
                
                header: Kirigami.Heading {
                    padding: {
                        top: 20
                    }
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    property var date: new Date()
                    text: `${i18n("Today is")} ${date.toLocaleDateString()}`
                    level: 1
                    wrapMode: Text.Wrap
                }
                headerPositioning: ListView.PullBackHeader
                
                Kirigami.Heading {
                    anchors.centerIn: parent
                    visible: layout.count === 0
                    text: i18n("Add some kountdowns!")
                    level: 2
                }
            }
        }
    }
}
