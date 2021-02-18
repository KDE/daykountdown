/*
 * SPDX-FileCopyrightText: 2021 Claudio Cambra <claudio.cambra@gmail.com>
 * SPDX-LicenseRef: GPL-3.0-or-later
 */

#pragma once

#include <Akonadi/Calendar/FetchJobCalendar>
#include <KCalendarCore/Event>
#include <QDateTime>

class PIMModule : public QObject {
	Q_OBJECT
	
public:
	explicit PIMModule(QObject *parent = nullptr);
	virtual ~PIMModule() override = default;
	
	bool getCalendarList();
	
	
};
