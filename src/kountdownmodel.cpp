// SPDX-FileCopyrightText: 2020 Carl Schwan <carl@carlschwan.eu>
//
// SPDX-LicenseRef: CC0-1.0

#include "kountdownmodel.h"

#include <QCoreApplication>
#include <QColor>
#include <QDateTime>
#include <QDebug>
#include <QDir>
#include <QStandardPaths>
#include <QSqlRecord>
#include <QSqlError>

KountdownModel::KountdownModel(QObject *parent)
    : QSqlTableModel(parent)
{
    if (!QSqlDatabase::database().tables().contains(QStringLiteral("KountdownModel"))) {
        const auto statement = QStringLiteral(R"RJIENRLWEY(
            CREATE TABLE IF NOT EXISTS KountdownModel (
                ID INTEGER PRIMARY KEY AUTOINCREMENT,
                Name TEXT NOT NULL,
                Description TEXT NOT NULL,
                Date TEXT NOT NULL,
            )
        )RJIENRLWEY");
        auto query = QSqlQuery(statement);
        if (!query.exec()) {
            qCritical() << query.lastError() << "while creating table";
        }
    }

    setTable(QStringLiteral("KountdownModel"));
    setEditStrategy(QSqlTableModel::OnManualSubmit);
    select();
}

QVariant KountdownModel::data(const QModelIndex &index, int role) const
{
    if (role == Qt::EditRole) {
        return QSqlTableModel::data(index, Qt::EditRole);
    }
    int parentColumn = 0;
    if (role == Qt::UserRole + 0 + 1) { // ID
        parentColumn = 0;
    } else if (role == Qt::UserRole + 1 + 1) { // Name
        parentColumn = 0;
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
    QSqlRecord newRecord = this->record();
    newRecord.setValue(QStringLiteral("Name"), name);
    newRecord.setValue(QStringLiteral("Description"), description);
    newRecord.setValue(QStringLiteral("Date"), date.toString(Qt::ISODate));

    bool result = insertRecord(rowCount(), newRecord);
    result &= submitAll();
    return result;
}

bool KountdownModel::removeKountdown(int index)
{
    bool result = removeRow(index);
    result &= submitAll();
    return result;
}
