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
		PlasmaCalendar.EventPluginsManager.enabledPlugins = Config.enabledCalendarPlugins
		
	}
	
	function connectConfig(item) {
		var saveConnect = Qt.createQmlObject("import QtQuick 2.12; Connections {target: " + item + ";
			function onConfigurationChanged() { " + item.saveConfig() + "} }", settingsPage, model.display + "dynobject")
	}
	
	Kirigami.FormLayout {
		id: settingsLayout
		ColumnLayout {
			id: calendarSettingsLayout
			
			Kirigami.FormData.label: i18n("Calendar Plugins:")
			
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
					}
					Loader {
						readonly property string uniqueId: model.label+uniqueID+index
						Layout.fillWidth: true
						Layout.minimumHeight: 500
						source: "file:" + model.configUi
						visible: Config.enabledCalendarPlugins.indexOf(model.pluginPath) > -1
						onLoaded: {
							this.item.configurationChanged.connect(this.item.saveConfig)
						}
					}
				}
			}
		}
	}
}
