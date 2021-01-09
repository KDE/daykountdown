#include <cstdlib>
#include <QApplication>
#include <QCommandLineParser>
#include <KAboutData>
#include <KLocalizedString>
#include "mainwindow.h"

int main (int argc, char *argv[]) {
    // Must create QApplication object first, and only once
    QApplication app(argc, argv);
    KLocalizedString::setApplicationDomain("DayCountdown"); //Properly sets translation catalog
    
    // Class used to store information about the program
    // Every KDE application should have this
    KAboutData aboutData(
        // Internal program name
        QStringLiteral("DayCountdown"),
        // Displayable program name string
        i18n("Day Countdown"),
        // Program version string
        QStringLiteral("0.1"),
        // Short app description
        i18n("Lets you keep track of days until an event"),
        // License
        KAboutLicense::GPL,
        // Copyright statement
        i18n("(c) 2021"),
        // Optional text shown in About box
        i18n("Placeholder"),
        // Program homepage
        QStringLiteral("https://github.com/elChupaCambra/Qt-DayCountdown"),
        // Bug report email address
        QStringLiteral("claudio.cambra@gmail.com")
               );
    
    aboutData.addAuthor(i18n("Claudio Cambra"), i18n("Task"), QStringLiteral("claudio.cambra@gmail.com"), QStringLiteral("https://github.com/elChupaCambra/"));
    
    // Initialise the properties of the QApplication object
    KAboutData::setApplicationData(aboutData);
    
    // Class used to specify command line switches, i.e. to open up app with specific file
    // Here it just opens the app
    QCommandLineParser parser;
    aboutData.setupCommandLine(&parser);
    parser.process(app);
    aboutData.processCommandLine(&parser);
    
   MainWindow *window = new MainWindow();
   window->show();
   
   return app.exec();
}

// All user-visible text is passed through the i18n() function, necessary for the UI to be translatable.
