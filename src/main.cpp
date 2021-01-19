#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <KLocalizedContext>
#include <KLocalizedString>
#include <QUrl>
#include "backend.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    KLocalizedString::setApplicationDomain("daykountdown");
    QApplication app(argc, argv);
    QCoreApplication::setOrganizationName("KDE");
    QCoreApplication::setOrganizationDomain("kde.org");
    QCoreApplication::setApplicationName("DayKountdown");

    QQmlApplicationEngine engine;
	
	Backend backend;
	engine.rootContext()->setContextProperty("backend", &backend);

    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));
    engine.rootContext()->setContextObject(new KLocalizedContext(&engine));

    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    return app.exec();
}
