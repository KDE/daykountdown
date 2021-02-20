/*
* SPDX-FileCopyrightText: (C) 2021 Claudio Cambra <claudio.cambra@gmail.com>
* 
* SPDX-LicenseRef: GPL-3.0-or-later
*/

// Includes relevant modules used by the QML
import QtQuick 2.6
import QtQuick.Controls 2.3 as Controls
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.3
import org.kde.kirigami 2.13 as Kirigami
import org.kde.daykountdown.private 1.0

// Overlay sheets appear over a part of the window
Kirigami.OverlaySheet {
	id: addEditSheet
	
	// Sheet mode
	property string mode: "add"
	
	property int index: -1
	property string name: ""
	property string description: ""
	property date kdate: nowDate
	property color colour: palette.text;
	
	// Signals can be read an certain actions performed when these happen
	signal added (string name, string description, var kdate)
	signal edited(int index, string name, string description, var kdate)
	signal removed(int index)
	
	header: Kirigami.Heading {
		// i18nc is useful for adding context for translators
		text: mode === "add" ? i18nc("@title:window", "Add kountdown") : 
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
			text: name
			onAccepted: descriptionField.forceActiveFocus()
		}
		Controls.TextField {
			id: descriptionField
			Kirigami.FormData.label: i18nc("@label:textbox", "Description:")
			placeholderText: i18n("Optional")
			text: description
			onAccepted: datePicker.forceActiveFocus()
		}
		// Advanced colourpicker widget
		ColorDialog {
			id: colorDialog
			title: i18n("Kountdown Colour")
			onAccepted: {
				colour = colorDialog.color;
			}
		}
		// Horizontally display kountdown colour buttons
		RowLayout {
			Layout.fillWidth: true
			Kirigami.FormData.label: i18n("Colour:")
			Controls.RoundButton {
				contentItem: Text {
					text: "\u2B24"
					color: "crimson"
					horizontalAlignment: Text.AlignHCenter
					verticalAlignment: Text.AlignVCenter
				}
				onClicked: colour = "crimson"
			}
			Controls.RoundButton {
				contentItem: Text {
					text: "\u2B24"
					color: "coral"
					horizontalAlignment: Text.AlignHCenter
					verticalAlignment: Text.AlignVCenter
				}
				onClicked: colour = "coral"
			}
			Controls.RoundButton {
				contentItem: Text {
					text: "\u2B24"
					color: "goldenrod"
					horizontalAlignment: Text.AlignHCenter
					verticalAlignment: Text.AlignVCenter
				}
				onClicked: colour = "goldenrod"
			}
			Controls.RoundButton {
				contentItem: Text {
					text: "\u2B24"
					color: "lightseagreen"
					horizontalAlignment: Text.AlignHCenter
					verticalAlignment: Text.AlignVCenter
				}
				onClicked: colour = "lightseagreen"
			}
			Controls.RoundButton {
				contentItem: Text {
					text: "\u2B24"
					color: "deepskyblue"
					horizontalAlignment: Text.AlignHCenter
					verticalAlignment: Text.AlignVCenter
				}
				onClicked: colour = "deepskyblue"
			}
			Controls.RoundButton {
				contentItem: Text {
					text: "\u2B24"
					color: "hotpink"
					horizontalAlignment: Text.AlignHCenter
					verticalAlignment: Text.AlignVCenter
				}
				onClicked: colour = "hotpink"
			}
			Controls.Button {
				id: openColourDialog
				onClicked: colorDialog.open()
				text: "More"
				Layout.fillWidth: true
			}
		}
		Rectangle {
			color: colour
			Layout.fillWidth: true
			height: 20
		}
		// This singleton is bringing in a component defined in DatePicker.qml
		DatePicker {
			id: datePicker
			selectedDate: kdate
			Layout.fillWidth: true
		}
		// This is a button.
		Controls.Button {
			id: deleteButton
			Layout.fillWidth: true
			text: i18nc("@action:button", "Delete")
			visible: mode === "edit"
			onClicked: {
				addEditSheet.removed(index)
				close();
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
				if(mode === "add") {
					addEditSheet.added(
						nameField.text, 
						descriptionField.text, 
						datePicker.selectedDate, 
						colour
					);
				}
				else {
					addEditSheet.edited(
						index, 
						nameField.text, 
						descriptionField.text, 
						datePicker.selectedDate, 
						colour
					);
				}
				close();
			}
		}
	}
}
