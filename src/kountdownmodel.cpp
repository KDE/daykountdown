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
		//Statement to be inputted into SQLite
		const auto statement = QStringLiteral(R"RJIENRLWEY(
			CREATE TABLE IF NOT EXISTS KountdownModel (
				id INTEGER PRIMARY KEY AUTOINCREMENT,
				name TEXT NOT NULL,
				description TEXT NOT NULL,
				date TEXT NOT NULL
			)
		)RJIENRLWEY");
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
	int parentColumn = 0;
	if (role == Qt::UserRole + 0 + 1) { // ID
		parentColumn = 0;
	} else if (role == Qt::UserRole + 1 + 1) { // Name
		parentColumn = 1;
	} else if (role == Qt::UserRole + 2 + 1) { // Description
		parentColumn = 2;
	} else { // Date
		parentColumn = 3;
		QModelIndex parentIndex = createIndex(index.row(), parentColumn);
		return QDateTime::fromString(QSqlTableModel::data(parentIndex, Qt::DisplayRole).toString(), Qt::ISODate);
	}
	QModelIndex parentIndex = createIndex(index.row(), parentColumn);
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

bool KountdownModel::addKountdown(const QString& name, const QString& description, const QDateTime& date)
{
	// Create new instance of QSqlRecord
	// this points towards newRecord itself
	// calls record(), which returns a QSqlRecord containing the field information
	QSqlRecord newRecord = this->record();
	// Set field values
	newRecord.setValue(QStringLiteral("Name"), name);
	newRecord.setValue(QStringLiteral("Description"), description);
	newRecord.setValue(QStringLiteral("Date"), date.toString(Qt::ISODate));

	// insertRecord returns bool
	// inserts in last location
	bool result = insertRecord(rowCount(), newRecord);
	// result = result & submitAll
	// submitAll also returns bool
	result &= submitAll();
	return result;
}

//Similar to previous function, except result = setRecord instead of insertRecord
bool KountdownModel::editKountdown(int index, const QString& name, const QString& description, const QDateTime& date)
{
	QSqlRecord record = this->record();
	record.setValue(QStringLiteral("Name"), name);
	record.setValue(QStringLiteral("Description"), description);
	record.setValue(QStringLiteral("Date"), date.toString(Qt::ISODate));
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
