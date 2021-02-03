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
							new Date(ImportExport.Kountdowns[i].date)
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
				text: i18n("Quit")
				icon.name: "application-exit"
				shortcut: StandardKey.Quit
				onTriggered: Qt.quit()
			}
		]
	}
	
	property var nowDate: new Date()	
	
	// Loader fetches item from addEditSheet.qml
	Loader { 
		id: addEditSheetLoader
		source: "addEditSheet.qml" 
	}
	// This is read by addEditSheet to change functionality
	property var sheetMode
	// Setting variables in AppWindow scope so they are accessible to addEditSheet in edit mode
	property var editingName
	property var editingDesc
	property var editingDate
	
	// Function called by 'edit' button on card
	function openPopulateSheet(mode, index = -1, listName = "", listDesc = "", listDate = "") {
		sheetMode = mode
		
		if(mode == "edit")
			addEditSheetLoader.item.index = index;
			editingName = listName
			editingDesc = listDesc
			editingDate = listDate
		addEditSheetLoader.item.open()
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
				// Loader grabs component from different file specified in resources
				delegate: Loader { source: "kountdownCard.qml" }
				
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
