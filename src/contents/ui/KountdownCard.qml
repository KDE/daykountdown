/*
* SPDX-FileCopyrightText: (C) 2021 Claudio Cambra <claudio.cambra@gmail.com>
* 
* SPDX-LicenseRef: GPL-3.0-or-later
*/

import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

// Delegate is how the information will be presented in the ListView
Kirigami.AbstractCard {
	id: kountdownDelegate
	
	showClickFeedback: true
	onReleased: openPopulateSheet("edit", index, name, description, date, colour)
	
	// contentItem property includes the content to be displayed on the card
	contentItem: GridLayout {
		id: delegateLayout
		rowSpacing: Kirigami.Units.largeSpacing
		columnSpacing: Kirigami.Units.largeSpacing
		columns: 2
		RowLayout {
			Rectangle {
				Layout.fillHeight: true
				width: 5
				color: colour
			}
			Kirigami.Heading {
				// Level determines the size of the heading
				level: 1
				property var daysLeft: Math.ceil((date.getTime()-nowDate.getTime())/86400000)
				// Changes 'day' word depending on quantity of days
				property var daysWord: Math.abs(daysLeft) == 1 ? "day" : "days"
				text: daysLeft < 0 ? 
					i18n("%1 " + daysWord + " ago", daysLeft*-1) : i18n("%1 " + daysWord, daysLeft)
				color: colour
			}
		}
		
		// Layout for positioning elements vertically
		ColumnLayout {
			Kirigami.Heading {
				Layout.fillWidth: true
				wrapMode: Text.Wrap
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
				wrapMode: Text.Wrap
				text: description
				visible: description.length > 0
			}
		}
	}
}
