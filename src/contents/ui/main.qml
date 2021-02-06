/*
* SPDX-FileCopyrightText: (C) 2021 Carl Schwan <carl@carlschwan.eu>
* SPDX-FileCopyrightText: (C) 2021 Claudio Cambra <claudio.cambra@gmail.com>
* 
* SPDX-LicenseRef: GPL-3.0-or-later
*/

// Includes relevant modules used by the QML
import QtQuick 2.6
import QtQuick.Controls 2.0 as Controls
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.13 as Kirigami
import org.kde.daykountdown.private 1.0

// Base element, provides basic features needed for all kirigami applications
Kirigami.ApplicationWindow {
	// ID provides unique identifier to reference this element
	id: root

	// Window title
	title: i18nc("@title:window", "Day Kountdown")
	
	// Global drawer element with app-wide actions
	globalDrawer: Kirigami.GlobalDrawer {
		// Makes drawer a small menu rather than sliding pane
		isMenu: true
		actions: [
			Kirigami.Action {
				text: i18n("Import")
				icon.name: "document-open"
				shortcut: StandardKey.Open
				onTriggered: {
					ImportExport.fetchKountdowns();
					for(var i in ImportExport.Kountdowns) {
						KountdownModel.addKountdown(
							ImportExport.Kountdowns[i].name,
							ImportExport.Kountdowns[i].description,
							new Date(ImportExport.Kountdowns[i].date),
							ImportExport.Kountdowns[i].colour
						);
					}
				}
			},
			Kirigami.Action {
				text: i18n("Export")
				icon.name: "document-save"
				shortcut: StandardKey.Save
				onTriggered: ImportExport.exportFile()
			},
			/*Kirigami.Action {
				text: i18n("Settings")
				icon.name: "settings-configure"
				//onTriggered: ImportExport.fetchKountdowns()
				shortcut: StandardKey.Preferences
			},*/
			Kirigami.Action {
				text: i18n("About DayKountdown")
				icon.name: "help-about"
				onTriggered: pageStack.layers.push(aboutPage)
				enabled: pageStack.layers.currentItem.title !== i18n("About")
			},
			Kirigami.Action {
				text: i18n("Quit")
				icon.name: "application-exit"
				shortcut: StandardKey.Quit
				onTriggered: Qt.quit()
			}
		]
	}
	
	Component {
        id: aboutPage
        Kirigami.AboutPage {
            aboutData: AboutData.aboutData
        }
    }
	
	property var nowDate: new Date()
	Timer {
		interval: 60000
		running: true
		repeat: true
		onTriggered: nowDate = new Date()
	}
	
	// Fetches item from addEditSheet.qml and does action on signal
	// Cool thing about signals: they expose the variables defined in them to the function that is listening to them
	AddEditSheet { 
		id: addEditSheet
		onEdited: KountdownModel.editKountdown(
			index, 
			name, 
			description, 
			kdate, 
			colour
		);
		onAdded: KountdownModel.addKountdown(
			name, 
			description, 
			kdate, 
			colour
		);
		onRemoved: KountdownModel.removeKountdown(index)
	}

	SystemPalette { id: palette; colorGroup: SystemPalette.Active }
	// Function called by 'edit' button on card
	function openPopulateSheet(mode, index = -1, listName = "", listDesc = "", listDate = "", colour = palette.text) {
		addEditSheet.mode = mode
		addEditSheet.colour = colour;
		if(mode === "edit") {
			addEditSheet.index = index;
			addEditSheet.name = listName
			addEditSheet.description = listDesc
			addEditSheet.kdate = listDate
		}
		addEditSheet.open()
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
			actions { 
				main: Kirigami.Action {
					id: addAction
					// Name of icon associated with the action
					icon.name: "list-add"
					// Action text, i18n function returns translated string
					text: i18nc("@action:button", "Add kountdown")
					// What to do when triggering the action
					onTriggered: openPopulateSheet("add")
				}
				// Kirigami.Actions can have nested actions.
				left: Kirigami.Action {
					id: sortList
					text: i18nc("@action:button", "Sort")
					Kirigami.Action {
						text: i18nc("@action:button", "Creation (ascending)")
						onTriggered: KountdownModel.sortModel(KountdownModel.CreationAsc)
					}
					Kirigami.Action {
						text: i18nc("@action:button", "Creation (descending)")
						onTriggered: KountdownModel.sortModel(KountdownModel.CreationDesc)
					}
					Kirigami.Action {
						text: i18nc("@action:button", "Date (ascending)")
						onTriggered: KountdownModel.sortModel(KountdownModel.DateAsc)
					}
					Kirigami.Action {
						text: i18nc("@action:button", "Date (descending)")
						onTriggered: KountdownModel.sortModel(KountdownModel.DateDesc)
					}
					Kirigami.Action {
						text: i18nc("@action:button", "Alphabetical (ascending)")
						onTriggered: KountdownModel.sortModel(KountdownModel.AlphabeticalAsc)
					}
					Kirigami.Action {
						text: i18nc("@action:button", "Alphabetical (descending)")
						onTriggered: KountdownModel.sortModel(KountdownModel.AlphabeticalDesc)
					}
				}
			}
			

			// List view for card elements
			Kirigami.CardsListView {
				id: layout
				// Model contains info to be displayed
				model: KountdownModel
				// Grabs component from different file specified in resources
				delegate: KountdownCard {}
				
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
