/*
* SPDX-FileCopyrightText: (C) 2021 Claudio Cambra <claudio.cambra@gmail.com>
* 
* SPDX-LicenseRef: GPL-3.0-or-later
*/

#pragma once

#include <KIO/Job>
#include <KMessageBox>
#include <KLocalizedString>
#include <QSaveFile>
#include <QFileDialog>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QUrl>

// This kountdown struct eases the process of importing parsed kountdowns
// Contains the relevant properties for QML code to read
typedef struct kountdown {
	Q_GADGET
	Q_PROPERTY(int index MEMBER index);
	Q_PROPERTY(QString name MEMBER name);
	Q_PROPERTY(QString description MEMBER description);
	Q_PROPERTY(QString date MEMBER date);
	Q_PROPERTY(QString colour MEMBER colour);
	
	public:
		int index;
		QString name;
		QString description;
		QString date;
		QString colour;
} kountdown;

class ImportExport : public QObject
{
    Q_OBJECT
    // Q_PROPERTY macro exposes this item in QML
    // QVariantList is flexible and can convert certain types, useful when dealing with QML
    Q_PROPERTY(QVariantList Kountdowns READ kountdownPopulator)

public:
	explicit ImportExport(QObject *parent = nullptr);
	virtual ~ImportExport() override = default;
	QVariantList Kountdowns;
	QVariantList kountdownPopulator();
	Q_INVOKABLE void fetchKountdowns();
	Q_INVOKABLE void exportFile();
	
private:
	//QVectors are dynamic arrays which can store data structures of your choosing
	QVector<kountdown> _kountdownArray;
	QJsonDocument _createJson();
};
