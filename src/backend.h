#pragma once

#include <QQmlApplicationEngine>
#include <QtQml>
#include <QUrl>

class Backend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList kountdowns READ _fetchKountdowns WRITE populateKountdowns NOTIFY kountdownsPopulated)

public:
    explicit Backend(QObject *parent = nullptr);
	
private:
	QByteArray _loadJson();
	void _fetchKountdowns();
};
