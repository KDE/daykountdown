// SPDX-FileCopyrightText: 2020 Carl Schwan <carl@carlschwan.eu>
//
// SPDX-LicenseRef: CC0-1.0

#pragma once

#include <QAbstractListModel>
#include <QColor>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlTableModel>

/**
 * @brief Store all the kountdown.
 */
class KountdownModel : public  QSqlTableModel
{
    Q_OBJECT

public:
    enum ColorRoles {
        NameRole = Qt::UserRole + 1,
        DescriptionRole,
        DateRole,
    };

public:
    KountdownModel(QObject *parent = nullptr);

    virtual ~KountdownModel() override = default;

    QHash<int, QByteArray> roleNames() const override;
    QVariant data(const QModelIndex &index, int role) const override;

    Q_INVOKABLE bool addKountdown(const QString& name, const QString& description, const QDateTime& date);
    Q_INVOKABLE bool removeKountdown(int index);

private:
    QSqlDatabase m_db;
};
