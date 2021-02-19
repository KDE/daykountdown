/*
 * SPDX-FileCopyrightText: 2021 Claudio Cambra <claudio.cambra@gmail.com>
 * SPDX-LicenseRef: GPL-3.0-or-later
 */

import QtQuick 2.12
import QtQuick.Controls 2.12 as Controls
import QtQuick.Layouts 1.12

import org.kde.kirigami 2.13 as Kirigami
import org.kde.plasma.calendar 2.0 as PlasmaCalendar

import org.kde.daykountdown.private 1.0

Kirigami.ScrollablePage {
	id: settingsPage
	
	title: i18nc("@title", "Settings")
	Component.onCompleted: {
		console.log(PlasmaCalendar.EventPluginsManager.enabledPlugins)
		console.log(Config.enabledCalendarPlugins)
	}
	
	ColumnLayout {
		Kirigami.FormData.label: i18n("Available Plugins:")
		Kirigami.FormData.buddyFor: children[1] // 0 is the Repeater
		
		Repeater {
			id: calendarPluginsRepeater
			model: PlasmaCalendar.EventPluginsManager.model
			delegate: RowLayout {
				Controls.CheckBox {
					text: model.display
					checked: model.checked
					onClicked: {
						//needed for model's setData to be called
						model.checked = checked;
						Config.enabledCalendarPlugins = PlasmaCalendar.EventPluginsManager.enabledPlugins;
						Config.save()
					}
				}
			}
		}
	}
}
