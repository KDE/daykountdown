/*
* SPDX-FileCopyrightText: (C) 2021 Carl Schwan <carl@carlschwan.eu>
* SPDX-FileCopyrightText: (C) 2021 Claudio Cambra <claudio.cambra@gmail.com>
* 
* SPDX-LicenseRef: GPL-3.0-or-later
*/

// Includes relevant modules used by the QML
import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components as Components
import org.kde.kirigamiaddons.formcard as FormCard
import org.kde.daykountdown.private

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
        FormCard.AboutPage {
            aboutData: AboutData.aboutData
        }
    }
	
    Components.MessageDialog {
		id: removeAllDialog
		title: i18nc("@title:window", "Remove all kountdowns")
		dialogType: Components.MessageDialog.Warning
		contentItem: Controls.Label {
            text: i18n("Are you sure you want to delete all your kountdowns?")
            wrapMode: Text.Wrap
        }
		standardButtons: Controls.DialogButtonBox.Yes | Controls.DialogButtonBox.Cancel
		onAccepted: KountdownModel.removeAllKountdowns()
	}
	
	// Fetches item from addEditSheet.qml and does action on signal
	AddEditSheet { 
		id: addEditSheet
		onEdited: (index, name, description, kdate, colour) => KountdownModel.editKountdown(
			index, 
			name, 
			description, 
			kdate, 
			colour
		);
		onAdded: (name, description, kdate, colour) => KountdownModel.addKountdown(
			name, 
			description, 
			kdate, 
			colour
		);
		onRemoved: index => KountdownModel.removeKountdown(index)
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
