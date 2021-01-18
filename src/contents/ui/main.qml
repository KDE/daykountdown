// Includes relevant modules used by the QML
import QtQuick 2.6
import QtQuick.Controls 2.0 as Controls
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.13 as Kirigami

import org.kde.backend 1.0

// Base element, provides basic features needed for all kirigami applications
Kirigami.ApplicationWindow {
	// ID provides unique identifier to reference this element
	id: root

	// Window title
	title: i18nc("@title:window", "Day Kountdown")
	
	// ListModel needed for ListView, contains elements to be displayed
	ListModel {
		id: kountdownModel
		// Each ListElement is an element on the list, containing information
		// ListElement { name: "Dog"; date: 8 }
	}
	
	globalDrawer: Kirigami.GlobalDrawer {
		isMenu: true
		actions: [
			Kirigami.Action {
				text: i18n("Settings")
				icon.name: "settings-configure"
				//onTriggered: Settings page with exporting kountdowns
				shortcut: StandardKey.Preferences
			},
			Kirigami.Action {
					text: i18n("Quit")
					icon.name: "gtk-quit"
					shortcut: StandardKey.Quit
					onTriggered: Qt.quit()
				}
		]
	}
	
	property var nowDate: new Date()	

	// Overlay sheets appear over a part of the window
	Kirigami.OverlaySheet {
		id: addSheet
		header: Kirigami.Heading {
			// i18nc is useful for adding context for translators
			text: i18nc("@title:window", "Add kountdown")
		}
		// Form layouts help align and structure a layout with several inputs
		Kirigami.FormLayout {
			// Textfields let you input text in a thin textbox
			Controls.TextField {
				id: addNameField
				// Provides label attached to the textfield
				Kirigami.FormData.label: i18nc("@label:textbox", "Name:")
				// Placeholder text is visible before you enter anything
				placeholderText: i18n("Event name (required)")
				// What to do after input is accepted (i.e. pressed enter)
				// In this case, it moves the focus to the next field
				onAccepted: addDescriptionField.forceActiveFocus()
			}
			Controls.TextField {
				id: addDescriptionField
				Kirigami.FormData.label: i18nc("@label:textbox", "Description:")
				placeholderText: i18n("Optional")
				onAccepted: addDatePicker.forceActiveFocus()
			}
			// This singleton is bringing in a component defined in DatePicker.qml
			DatePicker {
				id: addDatePicker
			}
			// This is a button.
			Controls.Button {
				id: addButton
				Layout.fillWidth: true
				text: i18nc("@action:button", "Add")
				// Button is only enabled if the user has entered something into the nameField
				enabled: addNameField.text.length > 0
				onClicked: {
					// Add a listelement to the kountdownModel ListModel
					kountdownModel.append({
						// Each of the properties and what to set them to
						"name": addNameField.text,
						"description": addDescriptionField.text,
						"date": addDatePicker.selectedDate
					});
					// Clear values from the input sheet
					addNameField.text = "";
					addDescriptionField.text = "";
					addDatePicker.selectedDate = nowDate
					addSheet.close();
				}
			}
		}
	}
	
	// Setting variables in AppWindow scope so they are accessible to editSheet
	property var editingName
	property var editingDesc
	property var editingDate
	// Function called by 'edit' button on card
	function openPopulateEditSheet (listName, listDesc, listDate) {
		editingName = listName
		editingDesc = listDesc
		editingDate = listDate
		editSheet.open()
	}
	
	// Mirrors addSheet
	Kirigami.OverlaySheet {
		id: editSheet
		header: Kirigami.Heading {
			// i18nc is useful for adding context for translators
			text: i18nc("@title:window", "Edit kountdown")
		}
		Kirigami.FormLayout {
			Controls.TextField {
				id: editNameField
				Kirigami.FormData.label: i18nc("@label:textbox", "Name:")
				placeholderText: i18n("Event name (required)")
				text: editingName
				onAccepted: editDescriptionField.forceActiveFocus()
			}
			Controls.TextField {
				id: editDescriptionField
				Kirigami.FormData.label: i18nc("@label:textbox", "Description:")
				placeholderText: i18n("Optional")
				text: editingDesc
				onAccepted: editDatePicker.forceActiveFocus()
			}
			DatePicker {
				id: editDatePicker
				selectedDate: editingDate
			}
			Controls.Button {
				id: editButton
				Layout.fillWidth: true
				text: i18nc("@action:button", "Done")
				enabled: editNameField.text.length > 0
				onClicked: {
					// Checks if kountdown properties have been changed
					if (editNameField.text != editingName || 
						editDescriptionField.text != editingDesc || 
						editDatePicker.selectedDate != editingDate) {
						// Loop through entries in kountdownModel for correct one
						for (let i = 0; i < kountdownModel.count; i++) {
							if(kountdownModel.get(i).name == editingName) {
								kountdownModel.set(i, {
									"name": editNameField.text, 
									"description": editDescriptionField.text,
									"date": editDatePicker.selectedDate
								})
							}
						}
					}
					editingName = ""
					editingDesc = ""
					editingDate = nowDate
					editSheet.close();
				}
			}
		}
	}

	// Initial page to be loaded on app load
	pageStack.initialPage: mainPageComponent

	// Page here is defined as a QML component
	Component {
		id: mainPageComponent

		// Page contains the content. This one is scrollable.
		// DON'T PUT A SCROLLVIEW IN A SCROLLPAGE - children of a ScrollablePage are already in a ScrollView
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
								text: i18n("%1 days", Math.round((date.getTime()-nowDate.getTime())/86400000))
							}

							// Kayout for positioning elements vertically
							ColumnLayout {
								Kirigami.Heading {
									Layout.fillWidth: true
									level: 2
									text: name
								}
								// Horizontal rule
								Kirigami.Separator {
									Layout.fillWidth: true
									visible: description.length > 0
								}
								// Labels contain text
								Controls.Label {
									Layout.fillWidth: true
									// Word wrap makes text stay within box and shift with size
									wrapMode: Text.WordWrap
									text: description
									visible: description.length > 0
								}
							}
							Controls.Button {
								Layout.alignment: Qt.AlignRight
								// Column spanning within grid layout (vertically in this case)
								Layout.columnSpan: 2
								text: i18n("Edit")
								onClicked: openPopulateEditSheet(name, description, date)
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
					// Use toLocaleDateString, method to convert date object to string
					text: i18n("Today is %1", nowDate.toLocaleDateString())
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
