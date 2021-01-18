#include "backend.h"

Backend::Backend(QObject *parent) : QObject(parent)
{

}

QByteArray loadJson() {
	QFile inFile("contents/kountdowns.json");
	inFile.open(QIODevice::ReadOnly | QIODevice::Text);
	QByteArray data = inFile.readAll();
	inFile.close();
	
	return data;
}

QJsonArray fetchKountdowns() {
	QByteArray data = loadJson();
	
	QJsonParseError errorPtr;
	QJsonDocument kountdownsDoc = QJsonDocument::fromJson(data, &errorPtr);
	if(kountdownsDoc.isNull())
		qDebug() << "Parse failed";
	QJsonObject rootObj = kountdownsDoc.object();
	QJsonArray kountdownsArray = rootObj.value("kountdowns").toArray();
	return kountdownsArray;
}

