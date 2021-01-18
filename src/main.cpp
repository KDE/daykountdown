#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QtQml>
#include <QUrl>

struct kountdown {
		Q_GADGET
		QString _name;
		QString _description;
		QDateTime _date;
		Q_PROPERTY(QString name MEMBER _name)
		Q_PROPERTY(QString description MEMBER _description)
		Q_PROPERTY(QDateTime date MEMBER _date)
};
	
void setupKountdowns() {
	
}

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QCoreApplication::setOrganizationName("KDE");
    QCoreApplication::setOrganizationDomain("kde.org");
    QCoreApplication::setApplicationName("DayKountdown");

    QQmlApplicationEngine engine;

    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    setupKountdowns();
    
    return app.exec();
}
