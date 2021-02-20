/*
* SPDX-FileCopyrightText: 2021 Claudio Cambra <claudio.cambra@gmail.com>
* SPDX-LicenseRef: GPL-3.0-or-later
*/

import QtQuick 2.12
import QtQuick.Controls 1.4 as Controls1
import QtQuick.Controls 2.12 as Controls
import QtQuick.Layouts 1.12

import org.kde.kirigami 2.13 as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.calendar 2.0 as PlasmaCalendar

import org.kde.daykountdown.private 1.0

Kirigami.Page {
	id: eventsCalendarPage
	
	title: i18nc("@title", "Events")
	
	Component.onCompleted: {
		console.log(Config.enabledCalendarPlugins)
		PlasmaCalendar.EventPluginsManager.enabledPlugins = Config.enabledCalendarPlugins;
		console.log(PlasmaCalendar.EventPluginsManager.enabledPlugins)
	}
	
	ColumnLayout {
		
		anchors.fill: parent
		
		spacing: Kirigami.Units.largeSpacing
		
		Item {
			anchors {
				left: parent.left
				right: parent.right
				top: parent.top
			}
			Layout.minimumHeight: Kirigami.Units.gridUnit * 18
			
			PlasmaCalendar.MonthView {
				id: monthView
				borderOpacity: 0.25
				today: nowDate
				firstDayOfWeek: Qt.locale().firstDayOfWeek
			}
		}
		
		Controls.ScrollView {
			Layout.fillHeight: true
			anchors {
				left: parent.left
				right: parent.right
				bottom: parent.bottom
			}
			Controls.ScrollBar.horizontal.policy: Controls.ScrollBar.AlwaysOff
			
			ListView {
				id: eventsView
				
				width: parent.width - 10
				
				model: monthView.daysModel.eventsForDate(monthView.currentDate);
				delegate: Kirigami.SwipeListItem {
					id: eventItem
					
					actions: [
						Kirigami.Action {
							icon.name: "list-add"
							onTriggered: openPopulateSheet("add", -1, modelData.title, modelData.description, monthView.currentDate, modelData.eventColor)
						}
					]
					
					contentItem: RowLayout {
						Rectangle {
							id: eventColor
							
							Layout.fillHeight: true
							width: 5
							color: modelData.eventColor
							visible: modelData.eventColor !== ""
						}
						Controls.Label {
							text: modelData.title
						}
					}
				}
				Kirigami.PlaceholderMessage {
					anchors.centerIn: parent
					width: parent.width - (Kirigami.Units.largeSpacing * 4)
					// Hide this if there are list elements to display
					visible: eventsView.count === 0
					text: i18n("No events on this day")
					helpfulAction: addAction
				}
			}
		}
	}
}
