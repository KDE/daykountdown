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
#include <AkonadiCore/CollectionFilterProxyModel>
#include <AkonadiCore/EntityMimeTypeFilterModel>

#include <QDBusInterface>
#include <QDBusReply>
#include <QEventLoop>
#include <QFile>
#include <QFileInfo>
#include <QTextStream>

PIMModule::PIMModule(QObject *parent) : QObject(parent)
{
	m_calendarModel = new Akonadi::ETMCalendar();
	listCalendars();
	qDebug() << m_calendarModel->model()->roleNames();
}

Akonadi::ETMCalendar* PIMModule::calendarModel() const
{
	return m_calendarModel;
}

void PIMModule::setCalendarModel(Akonadi::ETMCalendar* inCalendar)
{
	m_calendarModel = inCalendar;
	emit calendarModelChanged();
}

KCheckableProxyModel* PIMModule::accessCalendarCheckableProxyModel()
{
	return m_calendarModel->checkableProxyModel();
}

QAbstractItemModel* PIMModule::accessCalendarModel()
{
	return m_calendarModel->model();
}

bool PIMModule::listCalendars()
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
		auto mimeTypeSet = QSet<QString>(mimeTypes.begin(), mimeTypes.end());
		
		for (const Akonadi::Collection &collection : collections) {
			const QStringList contentMimeTypes = collection.contentMimeTypes();
            auto collectionMimeTypeSet = QSet<QString>(contentMimeTypes.begin(), contentMimeTypes.end());
			qDebug() << collection.displayName();
			qDebug() << collectionMimeTypeSet;
			qDebug() << collection.resource();
		}
	}
	
	return true;
}
