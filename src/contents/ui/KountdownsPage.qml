/*
 * SPDX-FileCopyrightText: (C) 2021 Claudio Cambra <claudio.cambra@gmail.com>
 * 
 * SPDX-LicenseRef: GPL-3.0-or-later
 */

// Includes relevant modules used by the QML
import QtQuick 2.6
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.13 as Kirigami
import org.kde.daykountdown.private 1.0

// Page contains the content. This one is scrollable.
// DON'T PUT A SCROLLVIEW IN A SCROLLPAGE - children of a ScrollablePage are already in a ScrollView
Kirigami.ScrollablePage {
	id: kountdownsPage
	
	// Title for the current page, placed on the toolbar
	title: i18nc("@title", "Kountdowns")
	
	// Kirigami.Action encapsulates a UI action. Inherits from QQC2 Action
	actions { 
		main: Kirigami.Action {
			id: addAction
			// Name of icon associated with the action
			icon.name: "list-add"
			// Action text, i18n function returns translated string
			tooltip: i18nc("@action:button", "Add kountdown")
			// What to do when triggering the action
			onTriggered: openPopulateSheet("add")
		}
		// Kirigami.Actions can have nested actions.
		right: Kirigami.Action {
			id: sortList
			tooltip: i18nc("@action:button", "Sort by")
			icon.name: "view-sort"
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
		left: Kirigami.Action {
			tooltip: i18n("Show calendar")
			icon.name: "view-calendar"
			onTriggered: showCalendar()
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
