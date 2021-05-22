/*
* SPDX-FileCopyrightText: (C) 2021 Carl Schwan <carl@carlschwan.eu>
* SPDX-FileCopyrightText: (C) 2021 Claudio Cambra <claudio.cambra@gmail.com>
* 
* SPDX-LicenseRef: GPL-3.0-or-later
*/

// Includes relevant modules used by the QML
import QtQuick 2.6
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.3
import org.kde.kirigami 2.13 as Kirigami
import org.kde.daykountdown.private 1.0

// Base element, provides basic features needed for all kirigami applications
Kirigami.ApplicationWindow {
	// ID provides unique identifier to reference this element
	id: root

	// Window title
	title: i18nc("@title:window", "Day Kountdown")
	
	property date nowDate: new Date()
	property bool calPageOpen: false
	
	Timer {
		interval: 60000
		running: true
		repeat: true
		onTriggered: nowDate = new Date()
	}
	
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
			Kirigami.Action {
				text: i18n("Clear all kountdowns")
				icon.name: "edit-clear"
				onTriggered: removeAllDialog.open()
			},
			Kirigami.Action {
				text: i18n("Settings")
				icon.name: "settings-configure"
				onTriggered: pageStack.layers.push("SettingsPage.qml")
				enabled: pageStack.layers.currentItem.title !== i18n("Settings")
			},
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
	
    MessageDialog {
		id: removeAllDialog
		title: i18nc("@title:window", "Remove all kountdowns")
		icon: StandardIcon.Warning
		text: i18n("Are you sure you want to delete all your kountdowns?")
		standardButtons: Dialog.Yes | Dialog.Cancel
		onAccepted: KountdownModel.removeAllKountdowns()
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
	function openPopulateSheet(mode, index = -1, listName = "", listDesc = "", listDate = nowDate, colour = palette.text) {
		addEditSheet.mode = mode
		addEditSheet.colour = colour;
		addEditSheet.index = index;
		addEditSheet.name = listName
		addEditSheet.description = listDesc
		addEditSheet.kdate = listDate
		addEditSheet.open()
		addEditSheet.datePickerComponent.resetToToday() // Janky way of preventing duplicate dots for events appearing
	}

	// Initial page to be loaded on app load
	pageStack.initialPage: KountdownsPage {}
	
	Kirigami.Page {
		id: calPage
		visible: false

		Loader {
			id: calPageLoader
			anchors.fill: parent
			asynchronous: true
			active: false
			visible: calPage.visible
			source: Qt.resolvedUrl("EventsCalendarPage.qml")
			onLoaded: {
				applicationWindow().pageStack.pop() // Pop out the loadingPage
				root.pageStack.push(calPage)
				calPage.visible = true
			}
		}
	}

	Kirigami.Page {
		id: loadingPage
		visible: calPageOpen
		Controls.BusyIndicator {
			anchors.fill: parent
			running: loadingPage.visible
		}
	}

	function showCalendar() {
		calPageOpen = !calPageOpen
		if (calPageOpen == false) {
			calPageLoader.active = false
			applicationWindow().pageStack.pop() // Pop out calPage
		} else {
			calPageLoader.active = true
			root.pageStack.push(loadingPage)
		}
	}
}
