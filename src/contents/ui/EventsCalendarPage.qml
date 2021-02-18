/*
 * SPDX-FileCopyrightText: 2021 Claudio Cambra <claudio.cambra@gmail.com>
 * SPDX-LicenseRef: GPL-3.0-or-later
 */

import QtQuick 2.12
import QtQuick.Controls 1.2 as Controls1
import QtQuick.Controls 2.12 as Controls
import QtQuick.Layouts 1.12

import org.kde.kirigami 2.13 as Kirigami
import org.kde.plasma.calendar 2.0 as PlasmaCalendar

Kirigami.Page {
	id: eventsCalendarPage
	
	title: i18nc("@title", "Events")
	
	actions {
		left: Kirigami.Action {
			text: i18n("Events on week")
		}
		main: Kirigami.Action {
			text: i18n("All events")
		}
		right: Kirigami.Action {
			text: i18n("Events on month")
		}
	}
	
	GridLayout {
		
		anchors.fill: parent
			
		rowSpacing: Kirigami.Units.largeSpacing
		columnSpacing: Kirigami.Units.largeSpacing
		columns: 2
		rows: 2
		
		Controls.ScrollView {
			Layout.column: 0
			Layout.rowSpan: 2
			Layout.fillWidth: true
			Layout.fillHeight: true
			ListView {
			}
		}
		FocusScope {
			Layout.column: 1
			Layout.row: 1
			Layout.fillWidth: true
			height: parent.height /2
			Controls1.Calendar {
				anchors.fill: parent
			}
		}
	}
}
