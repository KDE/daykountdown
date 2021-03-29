/*
* SPDX-FileCopyrightText: 2021 Claudio Cambra <claudio.cambra@gmail.com>
* SPDX-LicenseRef: GPL-3.0-or-later
*/

import QtQuick 2.12
import QtQuick.Controls 1.4 as Controls1
import QtQuick.Controls 2.12 as Controls
import QtQuick.Layouts 1.12

import org.kde.kirigami 2.13 as Kirigami
import org.kde.plasma.calendar 2.0 as PlasmaCalendar

import org.kde.daykountdown.private 1.0

Kirigami.Page {
	id: eventsCalendarPage
	
	title: i18nc("@title", "Events")
	
	Component.onCompleted: {
		PlasmaCalendar.EventPluginsManager.enabledPlugins = Config.enabledCalendarPlugins;
	}
	
	Connections {
		target: Config
		function onEnabledCalendarPluginsChanged() { 
			PlasmaCalendar.EventPluginsManager.enabledPlugins = Config.enabledCalendarPlugins
		}
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
					
					contentItem: GridLayout {
						id: eventRowLayout
						width: parent.width
						
						columns: 3
						rows: 2
						
						Rectangle {
							id: eventColor
							
							Layout.fillHeight: true
							Layout.row: 0
							Layout.rowSpan: 2
							Layout.column: 0
							
							width: 5
							color: modelData.eventColor
							visible: modelData.eventColor !== ""
						}
						Controls.Label {
							Layout.row: 0
							Layout.column: 1
							width: Kirigami.Units.gridUnit * 2

							text: isNaN(modelData.startDateTime) ? i18n("N/A") : Qt.formatTime(modelData.startDateTime)
							wrapMode: Text.Wrap
						}
						Controls.Label {
							Layout.row: 1
							Layout.column: 1
							width: Kirigami.Units.gridUnit * 2

							text: isNaN(modelData.endDateTime) ? i18n("N/A") : Qt.formatTime(modelData.endDateTime)
							wrapMode: Text.Wrap
						}
						Controls.Label {
							Layout.row: 0
							Layout.rowSpan: modelData.description === "" ? 2 : 1
							Layout.column: 2
							Layout.fillWidth: true
							
							text: modelData.title
							wrapMode: Text.Wrap
							elide: Text.ElideRight
							maximumLineCount: 1
						}
						Controls.Label {
							Layout.row: 1
							Layout.column: 2
							Layout.fillWidth: true
							
							text: modelData.description
							wrapMode: Text.Wrap
							elide: Text.ElideRight
							maximumLineCount: 1
							opacity: 0.7
							visible: modelData.description !== ""
						}
					}
				}
				Kirigami.PlaceholderMessage {
					anchors.centerIn: parent
					width: parent.width - (Kirigami.Units.largeSpacing * 4)
					visible: eventsView.count === 0
					text: i18n("No events on this day")
					helpfulAction: addAction
				}
			}
		}
	}
}
