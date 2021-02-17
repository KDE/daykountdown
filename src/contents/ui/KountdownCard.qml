/*
* SPDX-FileCopyrightText: (C) 2021 Claudio Cambra <claudio.cambra@gmail.com>
* 
* SPDX-LicenseRef: GPL-3.0-or-later
*/

import QtQuick 2.6
import QtQuick.Controls 2.0 as Controls
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.13 as Kirigami

// Delegate is how the information will be presented in the ListView
Kirigami.Card {
	id: kountdownDelegate
	
	showClickFeedback: true
	onReleased: openPopulateSheet("edit", index, name, description, date, colour)
	
	// contentItem property includes the content to be displayed on the card
	contentItem: Item {
		id: cardContents
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
			RowLayout {
				Rectangle {
					Layout.fillHeight: true
					width: 5
					color: colour
				}
				Kirigami.Heading {
					// Heading will be as tall as possible while respecting constraints
					Layout.fillHeight: true
					// Level determines the size of the heading
					level: 1
					property var daysLeft: Math.round((date.getTime()-nowDate.getTime())/86400000)
					// Changes 'day' word depending on quantity of days
					property var daysWord: daysLeft <= -2 || daysLeft >= 2 ? "days" : "day"
					text: daysLeft < 0 ? 
						i18n("%1 " + daysWord + " ago", daysLeft*-1) : i18n("%1 " + daysWord, daysLeft)
					color: colour
				}
			}
			
			// Kayout for positioning elements vertically
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
}
