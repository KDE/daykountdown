#include "backend.h"

Backend::Backend(QObject *parent) : QObject(parent)
{

}

QByteArray Backend::_loadJson() {
	QFile inFile("contents/kountdowns.json");
	inFile.open(QIODevice::ReadOnly | QIODevice::Text);
	QByteArray data = inFile.readAll();
	inFile.close();
	
	return data;
}

struct kountdownArray[100];

void Backend::_fetchKountdowns() {
	struct kountdown {
		QString index;
		QString name;
		QString description;
		QString date;
	};
	
	QByteArray data = _loadJson();
	
	QJsonParseError errorPtr;
	QJsonDocument kountdownsDoc = QJsonDocument::fromJson(data, &errorPtr);
	if(kountdownsDoc.isNull())
		qDebug() << "Parse failed";
	QJsonObject rootObj = kountdownsDoc.object();
	QJsonArray kountdownsArray = rootObj.value("kountdowns").toArray();
	
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
	foreach(const QJsonValue & kountdown, kountdownsArray) {
		struct kountdown currKountdown;
		currKountdown.index = i;
		currKountdown.name = kountdown.toObject().value("name").toString();
		currKountdown.description = kountdown.toObject().value("description").toString();
		currKountdown.date = kountdown.toObject().value("date").toString();
		i++;
	}
}

