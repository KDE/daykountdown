/*
* SPDX-FileCopyrightText: 2021 Claudio Cambra <claudio.cambra@gmail.com>
* SPDX-LicenseRef: GPL-3.0-or-later
*/

#include "pimmodule.h"

#include <KLocalizedString>

#include <AkonadiCore/AgentInstance>
#include <AkonadiCore/AgentInstanceCreateJob>
#include <AkonadiCore/AgentManager>
#include <AkonadiCore/Collection>
#include <AkonadiCore/CollectionFetchJob>
#include <AkonadiCore/CollectionFetchScope>

#include <QDBusInterface>
#include <QDBusReply>
#include <QEventLoop>
#include <QFile>
#include <QFileInfo>
#include <QTextStream>

PIMModule::PIMModule(QObject *parent) : QObject(parent)
{
}

bool PIMModule::getCalendarList()
{
	Akonadi::CollectionFetchJob *job = new Akonadi::CollectionFetchJob(Akonadi::Collection::root(), Akonadi::CollectionFetchJob::Recursive);
	const QStringList mimeTypes = QStringList() << QStringLiteral("text/calendar")
		<< KCalendarCore::Event::eventMimeType()
		<< KCalendarCore::Todo::todoMimeType();
	job->fetchScope().setContentMimeTypes(mimeTypes);
	QEventLoop loop;
	QObject::connect(job, &Akonadi::CollectionFetchJob::result, &loop, &QEventLoop::quit);
	job->start();
	loop.exec();
	
	if (job->error() != 0) {
		qDebug() << i18n("Problem fetching calendars.");
		return false;
	}
	
	const Akonadi::Collection::List collections = job->collections();
	
	if (collections.isEmpty()) {
		qDebug() << i18n("There are no calendars available.");
	} else {
		for (const Akonadi::Collection &collection : collections) {
			qDebug() << collection.displayName();
		}
	}
	
	return true;
}
