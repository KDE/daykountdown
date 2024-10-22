/*
 * SPDX-FileCopyrightText: 2021 Claudio Cambra <claudio.cambra@gmail.com>
 * SPDX-LicenseRef: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.merkuro.calendar as PlasmaCalendar

import org.kde.daykountdown.private

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
