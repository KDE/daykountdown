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
			Layout.fillWidth: true
			Layout.minimumHeight: Kirigami.Units.gridUnit * 22
			Layout.minimumWidth: Kirigami.Units.gridUnit * 22
			
			PlasmaCalendar.MonthView {
				id: monthView
				borderOpacity: 0.25
				today: nowDate
				firstDayOfWeek: Qt.locale().firstDayOfWeek
			}
		}
		
		Controls.ScrollView {
			Layout.fillWidth: true
			Layout.fillHeight: true
			
			ListView {
				model: monthView.daysModel.eventsForDate(monthView.currentDate);
				delegate: Text {
					id: eventItem
					text: modelData.title
				}
			}
		}
	}
}
