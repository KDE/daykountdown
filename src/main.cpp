#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QtQml>
#include <QUrl>

QByteArray loadJson() {
	QFile inFile("contents/kountdowns.json");
	inFile.open(QIODevice::ReadOnly | QIODevice::Text);
	QByteArray data = inFile.readAll();
	inFile.close();
	
	return data;
}

QJsonArray fetchKountdowns() {
	QByteArray data = loadJson();
	
	QJsonParseError errorPtr;
	QJsonDocument kountdownsDoc = QJsonDocument::fromJson(data, &errorPtr);
	if(kountdownsDoc.isNull())
		qDebug() << "Parse failed";
	QJsonObject rootObj = kountdownsDoc.object();
	QJsonArray kountdownsArray = rootObj.value("kountdowns").toArray();
	return kountdownsArray;
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

    return app.exec();
}
