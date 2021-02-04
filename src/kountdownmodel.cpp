// SPDX-FileCopyrightText: 2021 Carl Schwan <carl@carlschwan.eu>
// SPDX-FileCopyrightText: 2021 Claudio Cambra <claudio.cambra@gmail.com>
//
// SPDX-LicenseRef: GPL-3.0-or-later

#include "kountdownmodel.h"

#include <QCoreApplication>
#include <QDateTime>
#include <QDebug>
#include <QDir>
#include <QStandardPaths>
#include <QSqlRecord>
#include <QSqlError>

KountdownModel::KountdownModel(QObject *parent)
	: QSqlTableModel(parent)
{
	// If database does not contain KountdownModel table, then create it
	if (!QSqlDatabase::database().tables().contains(QStringLiteral("KountdownModel"))) {
		// Statement to be inputted into SQLite
		// This is a rawstring
		const auto statement = QStringLiteral(R"RAWSTRING(
			CREATE TABLE IF NOT EXISTS KountdownModel (
				id INTEGER PRIMARY KEY AUTOINCREMENT,
				name TEXT NOT NULL,
				description TEXT NOT NULL,
				date TEXT NOT NULL,
				dateInMs INTEGER NOT NULL,
				colourPicked TEXT NOT NULL
			)
		)RAWSTRING");
		auto query = QSqlQuery(statement);
		// QSqlQuery returns false if query was unsuccessful
		if (!query.exec()) {
			qCritical() << query.lastError() << "while creating table";
		}
	}

	// Sets data table on which the model is going to operate
	setTable(QStringLiteral("KountdownModel"));
	// All changed will be cached in the model until submitAll() ot revertAll() is called
	setEditStrategy(QSqlTableModel::OnManualSubmit);
	// Populates the model with data from the table set above
	select();
}

// Returns value for the specified item and role (important when accessed by QML)
// Roles are integers. Feeding certain integer does certain action
QVariant KountdownModel::data(const QModelIndex &index, int role) const
{
	if (role == Qt::EditRole) {
		return QSqlTableModel::data(index, Qt::EditRole);
	}
	// ParentColumn defines the piece of data we will take from a record
	int parentColumn = 0;
	if (role == Qt::UserRole + 0 + 1) { // ID
		parentColumn = 0;
	} else if (role == Qt::UserRole + 1 + 1) { // Name
		parentColumn = 1;
	} else if (role == Qt::UserRole + 2 + 1) { // Description
		parentColumn = 2;
	} else if (role == Qt::UserRole + 3 + 1) { // Date
		parentColumn = 3;
		// QModelIndex class is used as an index into KountdownModel
		// These indexes refer to items in the model
		QModelIndex parentIndex = createIndex(index.row(), parentColumn);
		// We need to do some conversions for QDateTime class objects
		return QDateTime::fromString(QSqlTableModel::data(parentIndex, Qt::DisplayRole).toString(), Qt::ISODate);
	} else if (role == Qt::UserRole + 4 + 1) { //DateInMs
		parentColumn = 4;
	} else { // ColourPicked
		parentColumn = 5;
	}
	QModelIndex parentIndex = createIndex(index.row(), parentColumn);
	// We return a piece of data at index.row, parentColumn
	return QSqlTableModel::data(parentIndex, Qt::DisplayRole);
}

QHash<int, QByteArray> KountdownModel::roleNames() const
{
	QHash<int, QByteArray> roles;
	for (int i = 0; i < this->record().count(); i ++) {
		roles.insert(Qt::UserRole + i + 1, record().fieldName(i).toUtf8());
	}
	return roles;
}

bool KountdownModel::addKountdown(const QString& name, const QString& description, const QDateTime& date, QString colourPicked)
{
	// Create new instance of QSqlRecord
	// this points towards newRecord itself
	// calls record(), which returns a QSqlRecord containing the field information
	QSqlRecord newRecord = this->record();
	// Set field values
	newRecord.setValue(QStringLiteral("Name"), name);
	newRecord.setValue(QStringLiteral("Description"), description);
	newRecord.setValue(QStringLiteral("Date"), date.toString(Qt::ISODate));
	newRecord.setValue(QStringLiteral("DateInMS"), date.toMSecsSinceEpoch());
	newRecord.setValue(QStringLiteral("ColourPicked"), colourPicked);
	
	// insertRecord returns bool
	// inserts in last location
	bool result = insertRecord(rowCount(), newRecord);
	// result = result & submitAll
	// submitAll also returns bool
	result &= submitAll();
	return result;
}

//Similar to previous function, except result = setRecord instead of insertRecord
bool KountdownModel::editKountdown(int index, const QString& name, const QString& description, const QDateTime& date, QString colourPicked)
{
	QSqlRecord record = this->record();
	record.setValue(QStringLiteral("Name"), name);
	record.setValue(QStringLiteral("Description"), description);
	record.setValue(QStringLiteral("Date"), date.toString(Qt::ISODate));
	record.setValue(QStringLiteral("DateInMS"), date.toMSecsSinceEpoch());
	record.setValue(QStringLiteral("Colour"), colourPicked);
	bool result = setRecord(index, record);
	result &= submitAll();
	return result;
}

bool KountdownModel::removeKountdown(int index)
{
	bool result = removeRow(index);
	result &= submitAll();
	return result;
}

void KountdownModel::sortModel(int sort_by) {
	// Switch based on enum defined in kountdownmodel.h
	switch(sort_by) {
		case (AlphabeticalAsc):
			// This points to KountdownModel
			this->setSort(1, Qt::AscendingOrder);
			break;
		case (AlphabeticalDesc):
			this->setSort(1, Qt::DescendingOrder);
			break;
		case (DateAsc):
			this->setSort(3, Qt::AscendingOrder);
			break;
		case (DateDesc):
			this->setSort(3, Qt::DescendingOrder);
			break;
		case (CreationDesc):
			this->setSort(0, Qt::DescendingOrder);
			break;
		case (CreationAsc):
		default:
			this->setSort(0, Qt::AscendingOrder);
			break;
	}
	// Required to update model
	select();
}
