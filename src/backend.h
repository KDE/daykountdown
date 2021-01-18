#pragma once

#include <QQmlApplicationEngine>
#include <QtQml>
#include <QUrl>

class Backend : public QObject
{
    Q_OBJECT

public:
    explicit Backend(QObject *parent = nullptr);
};
