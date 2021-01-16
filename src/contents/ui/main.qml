// Includes relevant modules used by the QML
import QtQuick 2.6
import QtQuick.Controls 2.0 as Controls
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.13 as Kirigami

// Base element, provides basic features needed for all kirigami applications
Kirigami.ApplicationWindow {
    // ID provides unique identifier to reference this element
    id: root

    // Window title
    title: i18nc("@title:window", "Day Kountdown")

    Kirigami.OverlaySheet {
        id: addSheet
        header: Kirigami.Heading {
            text: i18nc("@title:window", "Add kountdown")
        }
        Kirigami.FormLayout {
            Controls.TextField {
                id: nameField
                Kirigami.FormData.label: i18nc("@label:textbox", "Name:")
                onAccepted: dateField.forceActiveFocus()
            }
            /* Controls.TextField {
                id: dateField
                Kirigami.FormData.label: i18nc("@label:textbox", "Date:")
                onAccepted: addButton.forceActiveFocus()
            } */
            DatePicker {
				id: datePicker
			}
            Controls.Button {
                id: addButton
                Layout.fillWidth: true
                text: i18nc("@action:button", "Add")
                onClicked: {
                    kountdownModel.append({
                        "name": nameField.text,
                        "date": datePicker.selectedDate
                    });
                    // clear value
                    nameField.text = "";
                    addSheet.close();
                }
            }
        }
    }

    // ListModel needed for ListView, contains elements to be displayed
    ListModel {
        id: kountdownModel
        // Each ListElement is an element on the list, containing information
    }

    // Initial page to be loaded on app load
    pageStack.initialPage: mainPageComponent

    // Page here is defined as a QML component
    Component {
        id: mainPageComponent

        // Page contains the content. This one is scrollable.
        // DON'T PUT A SCTOLLVIEW IN A SCROLLPAGE - children of a ScrollablePage are already in a ScrollView
        Kirigami.ScrollablePage {
            // Title for the current page, placed on the toolbar
            title: i18nc("@title", "Kountdown")

            // Kirigami.Action encapsulates a UI action. Inherits from QQC2 Action
            actions.main: Kirigami.Action {
                id: addAction
                // Name of icon associated with the action
                icon.name: "list-add"
                // Action text, i18n function returns translated string
                text: i18nc("@action:button", "Add kountdown")
                // What to do when triggering the action
                onTriggered: addSheet.open()
            }

            // List view for card elements
            Kirigami.CardsListView {
                id: layout
                // Model contains info to be displayed
                model: kountdownModel
                // Delegate is how the information will be presented in the ListView
                delegate: Kirigami.AbstractCard {
                    // contentItem property includes the content to be displayed on the card
                    contentItem: Item {
                        // implicitWidth/Height define the natural width/height of an item if no width or height is specified
                        // The setting below defines a component's preferred size based on its content
                        implicitWidth: delegateLayout.implicitWidth
                        implicitHeight: delegateLayout.implicitHeight
                        GridLayout {
                            id: delegateLayout
                            // QtQuick anchoring system allows quick definition of anchor points for positioning
                            anchors {
                                left: parent.left
                                top: parent.top
                                right: parent.right
                            }
                            rowSpacing: Kirigami.Units.largeSpacing
                            columnSpacing: Kirigami.Units.largeSpacing
                            columns: root.wideScreen ? 4 : 2

                            Kirigami.Heading {
                                // Heading will be as tall as possible while respecting constraints
                                Layout.fillHeight: true
                                // Level determines the size of the heading
                                level: 1
                                text: date
                            }

                            // Kayout for positioning elements vertically
                            ColumnLayout {
                                Kirigami.Heading {
                                    level: 2
                                    text: name
                                }
                                // Horizontal rule
                                Kirigami.Separator {
                                    Layout.fillWidth: true
                                }
                                // Labels contain text
                                Controls.Label {
                                    Layout.fillWidth: true
                                    // Word wrap makes text stay within box and shift with size
                                    wrapMode: Text.WordWrap
                                    text: i18n("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam id risus id augue euismod accumsan.")
                                }
                            }
                            Controls.Button {
                                Layout.alignment: Qt.AlignRight
                                // Column spanning within grid layout (vertically in this case)
                                Layout.columnSpan: 2
                                text: i18n("More")
                            }
                        }
                    }
                }

                header: Kirigami.Heading {
                    padding: {
                        top: Kirigami.Units.largeSpacing
                    }
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    // Javascript variables must be prefixed with 'property'
                    // We create a new date object
                    property var date: new Date()
                    // Use toLocaleDateString ,method to convert to string
                    text: i18n("Today is %1", date.toLocaleDateString())
                    level: 1
                    wrapMode: Text.Wrap
                }
                // Different types of header positioning, this one gets covered up when you scroll
                headerPositioning: ListView.PullBackHeader

                Kirigami.PlaceholderMessage {
                    // Center element, horizontally and vertically
                    anchors.centerIn: parent
                    width: parent.width - (Kirigami.Units.largeSpacing * 4)
                    // Hide this if there are list elements to display
                    visible: layout.count === 0
                    text: i18n("Add some kountdowns!")
                    helpfulAction: addAction
                }
            }
        }
    }
}
