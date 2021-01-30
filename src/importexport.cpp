#include "importexport.h"
#include "kountdownmodel.h"

ImportExport::ImportExport(QObject *parent) : QObject(parent)
{

}

QJsonDocument ImportExport::_createJson() {
	QJsonArray kountdownsJsonArr;
	
	QSqlQuery query("SELECT * FROM KountdownModel");
	while(query.next()) {
		QJsonObject kountdownToAdd {
			{"name", query.value(1).toString()},
			{"description", query.value(2).toString()},
			{"date", query.value(3).toString()}
		};
		kountdownsJsonArr.append(kountdownToAdd);
	}
	QJsonDocument exportingDoc({"kountdowns", kountdownsJsonArr});
	return exportingDoc;
}

void ImportExport::exportFile() {
	QString fileName = QFileDialog::getSaveFileName(NULL, i18n("Save File As"), NULL, "JSON (*.json)");
	QJsonDocument jsonDoc = _createJson();
	QSaveFile file(fileName);
	file.open(QIODevice::WriteOnly);
	file.write(jsonDoc.toJson());
	file.commit();
}

void ImportExport::fetchKountdowns() {
	_kountdownArray.clear();
	
	QUrl filePath = QFileDialog::getOpenFileUrl(NULL, i18n("Import file"));
	filePath = filePath.toLocalFile();
	
	QFile inFile(filePath.toString());
	if(inFile.exists()) {
		qDebug() << "Found kountdowns.json";
		inFile.open(QIODevice::ReadOnly | QIODevice::Text);
		QByteArray data = inFile.readAll();
		inFile.close();
		
		QJsonParseError errorPtr;
		QJsonDocument kountdownsDoc = QJsonDocument::fromJson(data, &errorPtr);
		if(kountdownsDoc.isNull())
			qDebug() << "Parse failed";
		QJsonObject rootObj = kountdownsDoc.object();
		QJsonArray kountdownsJsonArray = rootObj.value("kountdowns").toArray();
		
		/*
		* JSON Structure should be like so:
		* {
		* 		"kountdowns": [
		* 			{
		* 				"name": "kountdown1",
		* 				"description": "kountdown number one",
		* 				"date": QDateTime object
		* 			}
		* 		]
		* }
		* 
		*/
		
		int i = 0;
		foreach(const QJsonValue & kountdownJson, kountdownsJsonArray) {
			kountdown currKountdown;
			currKountdown.index = i;
			currKountdown.name = kountdownJson.toObject().value("name").toString();
			currKountdown.description = kountdownJson.toObject().value("description").toString();
			currKountdown.date = kountdownJson.toObject().value("date").toString();
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


