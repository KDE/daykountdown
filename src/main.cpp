/*
* SPDX-FileCopyrightText: (C) 2021 Carl Schwan <carl@carlschwan.eu>
* SPDX-FileCopyrightText: (C) 2021 Claudio Cambra <claudio.cambra@gmail.com>
* 
* SPDX-LicenseRef: GPL-3.0-or-later
*/

#include <QApplication>
#include <QCommandLineParser>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QUrl>
#include <QIcon>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <KLocalizedContext>
#include <KAboutData>
#include <KLocalizedString>
#include "kountdownmodel.h"

const QString DRIVER(QStringLiteral("QSQLITE"));

Q_DECL_EXPORT int main(int argc, char *argv[])
{
	QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
	QApplication app(argc, argv);
	KLocalizedString::setApplicationDomain("daykountdown");

	KAboutData aboutData(QStringLiteral("daykountdown"), i18nc("@title", "DayKountdown"), QStringLiteral("0.1"),
						i18nc("@title", "A countdown application"),
						KAboutLicense::GPL_V3);

	aboutData.addAuthor(i18nc("@info:credit", "Claudio Cambra"), i18nc("@info:credit", "Creator"));
	aboutData.addAuthor(i18nc("@info:credit", "Carl Schwan"), i18nc("@info:credit", "SQLite pro and code review"));

	KAboutData::setApplicationData(aboutData);
	QApplication::setWindowIcon(QIcon::fromTheme(QStringLiteral("org.kde.daykountdown")));

	Q_ASSERT(QSqlDatabase::isDriverAvailable(DRIVER));
	Q_ASSERT(QDir().mkpath(QDir::cleanPath(QStandardPaths::writableLocation(QStandardPaths::DataLocation))));
	QSqlDatabase db = QSqlDatabase::addDatabase(DRIVER);
	const auto path = QDir::cleanPath(QStandardPaths::writableLocation(QStandardPaths::DataLocation) + QStringLiteral("/") + qApp->applicationName());
	db.setDatabaseName(path);
	if (!db.open()) {
		qCritical() << db.lastError() << "while opening database at" << path;
	}

	QCommandLineParser parser;
	aboutData.setupCommandLine(&parser);
	parser.process(app);
	aboutData.processCommandLine(&parser);

	QQmlApplicationEngine engine;

	qmlRegisterSingletonInstance("org.kde.daykountdown.private", 1, 0, "KountdownModel", new KountdownModel(qApp));

	engine.rootContext()->setContextObject(new KLocalizedContext(&engine));
	engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

	if (engine.rootObjects().isEmpty()) {
		return -1;
	}

	return app.exec();
}
