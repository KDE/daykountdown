// SPDX-FileCopyrightText: 2021 Carl Schwan <carl@carlschwan.eu>
// SPDX-FileCopyrightText: 2021 Claudio Cambra <claudio.cambra@gmail.com>
//
// SPDX-LicenseRef: GPL-3.0-or-later

#pragma once

#include <QAbstractListModel>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlTableModel>

/**
* @brief Store all the kountdowns.
*/
class KountdownModel : public  QSqlTableModel
{
	Q_OBJECT

public:
	enum Roles {
		NameRole = Qt::UserRole + 1,
		DescriptionRole,
		DateRole,
	};
	
	enum SortTypes {
		CreationAsc,
		CreationDesc,
		AlphabeticalAsc,
		AlphabeticalDesc,
		DateAsc,
		DateDesc,
	};
	Q_ENUMS(SortTypes);

public:
	KountdownModel(QObject *parent = nullptr);

	virtual ~KountdownModel() override = default;

	QHash<int, QByteArray> roleNames() const override;
	QVariant data(const QModelIndex &index, int role) const override;

	Q_INVOKABLE bool addKountdown(const QString& name, const QString& description, const QDateTime& date);
	Q_INVOKABLE bool editKountdown(int index, const QString& name, const QString& description, const QDateTime& date);
	Q_INVOKABLE bool removeKountdown(int index);
	Q_INVOKABLE void sortModel(int sort_by);

private:
	QSqlDatabase m_db;
};
