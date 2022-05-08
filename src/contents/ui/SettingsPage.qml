/*
 * SPDX-FileCopyrightText: 2021 Claudio Cambra <claudio.cambra@gmail.com>
 * SPDX-LicenseRef: GPL-3.0-or-later
 */

import QtQuick 2.12
import QtQuick.Controls 2.12 as Controls
import QtQuick.Layouts 1.12

import org.kde.kirigami 2.13 as Kirigami
import org.kde.plasma.workspace.calendar 2.0 as PlasmaCalendar

import org.kde.daykountdown.private 1.0

Kirigami.ScrollablePage {
	id: settingsPage
	
	title: i18nc("@title", "Settings")
	Component.onCompleted: {
		PlasmaCalendar.EventPluginsManager.enabledPlugins = Config.enabledCalendarPlugins
	}
	
	ColumnLayout {
		id: settingsLayout
		ColumnLayout {
			id: calendarSettingsLayout
			
			Kirigami.Heading {
				level: 1
				text: i18n("Calendar settings")
			}
			
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
			
			Repeater {
				id: calendarPluginsSettings
				
				model: PlasmaCalendar.EventPluginsManager.model
				delegate: ColumnLayout {
					Layout.fillWidth: true
					Layout.fillHeight: true
					Kirigami.Heading {
						level: 2
						text: model.display
						visible: Config.enabledCalendarPlugins.indexOf(model.pluginPath) > -1
					}
					Loader {
						Layout.fillWidth: true
						source: "file:" + model.configUi
						visible: Config.enabledCalendarPlugins.indexOf(model.pluginPath) > -1
						onLoaded: {
							this.item.configurationChanged.connect(this.item.saveConfig)
							if(model.label = "PIM Events Plugin")
								this.item.height = Kirigami.Units.gridUnit * 15
							if (model.label = "Astronomical Events")
								this.item.wideMode = false
						}
					}
				}
			}
		}
	}
}
