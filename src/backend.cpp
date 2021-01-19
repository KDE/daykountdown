#include "backend.h"

Backend::Backend(QObject *parent) : QObject(parent)
{
	_fetchKountdowns();
}

QByteArray Backend::_loadJson() {
	QFile inFile("contents/kountdowns.json");
	inFile.open(QIODevice::ReadOnly | QIODevice::Text);
	QByteArray data = inFile.readAll();
	inFile.close();
	
	return data;
}

void Backend::_fetchKountdowns() {
	_kountdownArray.clear();
	QByteArray data = _loadJson();
	
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
		_kountdownArray[i] = currKountdown;
		i++;
	}
}

QVariantList Backend::kountdownPopulator () {
	QVariantList kountdownsList;
	
	for (const kountdown & k : _kountdownArray) {
		kountdownsList << QVariant::fromValue(k);
	}
	
	return kountdownsList;
}
