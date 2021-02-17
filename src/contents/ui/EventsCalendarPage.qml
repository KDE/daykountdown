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
	
	Layout.fillWidth: true
	
	Component.onCompleted: {
		console.log
	}
	
	GridLayout {
		
		anchors {
			left: parent.left
			top: parent.top
			right: parent.right
		}
			
		rowSpacing: Kirigami.Units.largeSpacing
		columnSpacing: Kirigami.Units.largeSpacing
		columns: 2
		
		Controls.ScrollView {
			ListView {
			}
		}
		FocusScope {
			Layout.column: 2
			Layout.fillWidth: true
			height: applicationWindow().height - Kirigami.Units.gridUnit *4
			Controls1.Calendar {
				anchors.fill: parent
			}
		}
	}
}
