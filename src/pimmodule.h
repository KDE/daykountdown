/*
 * SPDX-FileCopyrightText: 2021 Claudio Cambra <claudio.cambra@gmail.com>
 * SPDX-LicenseRef: GPL-3.0-or-later
 */

#pragma once

#include <Akonadi/Calendar/FetchJobCalendar>
#include <Akonadi/Calendar/ETMCalendar>
#include <KCalendarCore/Event>
#include <QDateTime>

class CalendarModel : public Akonadi::ETMCalendar
{
public:
	explicit CalendarModel(QObject *parent = nullptr);
	virtual ~CalendarModel() override = default;
};

class PIMModule : public QObject {
	Q_OBJECT
	Q_PROPERTY(Akonadi::ETMCalendar* CalendarModel READ calendarModel WRITE setCalendarModel NOTIFY calendarModelChanged)
	
public:
	explicit PIMModule(QObject *parent = nullptr);
	virtual ~PIMModule() override = default;
	
	Akonadi::ETMCalendar* calendarModel() const;
	void setCalendarModel(Akonadi::ETMCalendar* inCalendar);
	Q_INVOKABLE KCheckableProxyModel* accessCalendarCheckableProxyModel();
	Q_INVOKABLE QAbstractItemModel* accessCalendarModel();
	
	bool listCalendars();
	
signals:
	void calendarModelChanged();
	
private:
	Akonadi::ETMCalendar* m_calendarModel;
};

