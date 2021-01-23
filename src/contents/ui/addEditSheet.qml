/*
* SPDX-FileCopyrightText: (C) 2021 Claudio Cambra <claudio.cambra@gmail.com>
* 
* SPDX-LicenseRef: GPL-3.0-or-later
*/

// Includes relevant modules used by the QML
import QtQuick 2.6
import QtQuick.Controls 2.0 as Controls
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.13 as Kirigami
import org.kde.daykountdown.private 1.0

// Overlay sheets appear over a part of the window
Kirigami.OverlaySheet {
	id: addEditSheet
	property int index;
	header: Kirigami.Heading {
		// i18nc is useful for adding context for translators
		text: sheetMode == "add" ? i18nc("@title:window", "Add kountdown") : 
			i18nc("@title:window", "Edit kountdown")
	}
	// Form layouts help align and structure a layout with several inputs
	Kirigami.FormLayout {
		// Textfields let you input text in a thin textbox
		Controls.TextField {
			id: nameField
			// Provides label attached to the textfield
			Kirigami.FormData.label: i18nc("@label:textbox", "Name:")
			// Placeholder text is visible before you enter anything
			placeholderText: i18n("Event name (required)")
			// What to do after input is accepted (i.e. pressed enter)
			// In this case, it moves the focus to the next field
			text: sheetMode == "add" ? "" : editingName
			onAccepted: descriptionField.forceActiveFocus()
		}
		Controls.TextField {
			id: descriptionField
			Kirigami.FormData.label: i18nc("@label:textbox", "Description:")
			placeholderText: i18n("Optional")
			text: sheetMode == "add" ? "" : editingDesc
			onAccepted: datePicker.forceActiveFocus()
		}
		// This singleton is bringing in a component defined in DatePicker.qml
		DatePicker {
			id: datePicker
			selectedDate: sheetMode == "add" ? nowDate :editingDate
		}
		// This is a button.
		Controls.Button {
			id: deleteButton
			Layout.fillWidth: true
			text: i18nc("@action:button", "Delete")
			visible: sheetMode == "edit"
			onClicked: {
				KountdownModel.removeKountdown(addEditSheet.index)
				addEditSheet.close();
			}
		}
		Controls.Button {
			id: doneButton
			Layout.fillWidth: true
			text: i18nc("@action:button", "Done")
			// Button is only enabled if the user has entered something into the nameField
			enabled: nameField.text.length > 0
			onClicked: {
				// Add a listelement to the kountdownModel ListModel
				if(sheetMode == "add") {
					KountdownModel.addKountdown(nameField.text, descriptionField.text, datePicker.selectedDate);
				}
				// Checks if kountdown properties have been changed
				else if ((sheetMode == "edit") && (nameField.text != editingName || 
					descriptionField.text != editingDesc || 
					datePicker.selectedDate != editingDate)) {
					KountdownModel.editKountdown(addEditSheet.index, nameField.text,
												 descriptionField.text, datePicker.selectedDate);
				}
				if (sheetMode == "edit") {
					editingName = ""
					editingDesc = ""
					editingDate = nowDate
				}
				nameField.text = "";
				descriptionField.text = "";
				datePicker.selectedDate = nowDate
				addEditSheet.close();
			}
		}
	}
}
