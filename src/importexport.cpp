/*
* SPDX-FileCopyrightText: (C) 2021 Claudio Cambra <claudio.cambra@gmail.com>
* 
* SPDX-LicenseRef: GPL-3.0-or-later
*/

#include "importexport.h"
#include "kountdownmodel.h"

// Constructor function
ImportExport::ImportExport(QObject *parent) : QObject(parent)
{

}

// Function extracts koutndowns from SQLite table and converts to JSON array
QJsonDocument ImportExport::_createJson() {
	QJsonArray kountdownsJsonArr;
	
	// Select all rows from KountdownModel table
	QSqlQuery query("SELECT * FROM KountdownModel");
	// Query.next moves through each returned row
	while(query.next()) {
		// Object to add to JSON array
		QJsonObject kountdownToAdd {
			// Query.value(number) <- number is the column
			{"name", query.value(1).toString()},
			{"description", query.value(2).toString()},
			{"date", query.value(3).toString()},
			{"colour", query.value(5).toString()}
		};
		kountdownsJsonArr.append(kountdownToAdd);
	}
	// Create object with key-value pair of "kountdowns": kountdownsJsonArr
	QJsonObject mainObj {{"kountdowns", kountdownsJsonArr}};
	// Create JSON document from this object
	QJsonDocument exportingDoc(mainObj);
	return exportingDoc;
}

void ImportExport::exportFile() {
	// Open file dialog to get path for file-name to save
	QString fileName = QFileDialog::getSaveFileName(NULL, i18n("Save File As"), "exported_kountdowns.json", "JSON (*.json)");
	// Get the JSON file from the previous function to create
	QJsonDocument jsonDoc = _createJson();
	QSaveFile file(fileName);
	file.open(QIODevice::WriteOnly);
	file.write(jsonDoc.toJson());
	// Commit writes the changes to file
	file.commit();
}

void ImportExport::fetchKountdowns() {
	// _kountdownArray is going to hold all out kountdowns extracted from the JSON
	// We clear it so we don't import kountdowns from previously imported files
	_kountdownArray.clear();
	
	// Get QUrl for file to import
	QUrl filePath = QFileDialog::getOpenFileUrl(NULL, i18n("Import file"));
	// Returns the path of the QUrl formatted as a local gile path
	filePath = filePath.toLocalFile();
	
	QFile inFile(filePath.toString());
	if(inFile.exists()) {
		qDebug() << "Found kountdowns.json";
		inFile.open(QIODevice::ReadOnly | QIODevice::Text);
		// QByteArray is going to hold the data from the JSON file
		QByteArray data = inFile.readAll();
		inFile.close();
		
		// errorPtr is going to contain any errors we run into when parsing our JSON data
		QJsonParseError errorPtr;
		// Create internal JSON doc from data, with errorPtr address for errors
		QJsonDocument kountdownsDoc = QJsonDocument::fromJson(data, &errorPtr);
		if(kountdownsDoc.isNull())
			qDebug() << "Parse failed";
		// Create JSON object from root object of JSON file
		QJsonObject rootObj = kountdownsDoc.object();
		// Create array from the root object's value of "kountdowns" key (which is an array)
		QJsonArray kountdownsJsonArray = rootObj.value("kountdowns").toArray();
		
		/*
		* JSON Structure should be like so:
		* {
		* 		"kountdowns": [
		* 			{
		* 				"name": "kountdown1",
		* 				"description": "kountdown number one",
		* 				"date": date string,
		* 				"colour": "red"
		* 			}
		* 		]
		* }
		* 
		*/
		
		int i = 0;
		// For each kountdown in the JSON array...
		foreach(const QJsonValue & kountdownJson, kountdownsJsonArray) {
			// Create kountdown struct
			kountdown currKountdown;
			// Set values of this struct
			currKountdown.index = i;
			currKountdown.name = kountdownJson.toObject().value("name").toString();
			currKountdown.description = kountdownJson.toObject().value("description").toString();
			currKountdown.date = kountdownJson.toObject().value("date").toString();
			if(kountdownJson.toObject().contains("colour"))
				currKountdown.colour = kountdownJson.toObject().value("colour").toString();
			else
				// Default text colour defined in QML
				currKountdown.colour = "palette.text";
			_kountdownArray.append(currKountdown);
			i++;
		}
	}
	else {
		qDebug() << "Didn't find kountdowns.json";
	}
}

QVariantList ImportExport::kountdownPopulator () {
	QVariantList kountdownsList;
	
	for(const kountdown & k : _kountdownArray) {
		kountdownsList << QVariant::fromValue(k);
	}
	
	return kountdownsList;
}


