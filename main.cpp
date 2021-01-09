#include <QApplication>
#include <QCommandLineParser>
#include <KAboutData>
#include <KLocalizedString>
#include <KMessageBox>

int main (int argc, char *argv[]) {
    QApplication app(argc, argv);
    KLocalizedString::setApplicationDomain("DayCountdown");
    
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
        QStringLiteral("claudio.cambra@gmail.com"),
               );
    
    aboutData.addAuthor(i18n("Claudio Cambra"), i18n("Task"), QStringLiteral("claudio.cambra@gmail.com"), QStringLiteral("https://github.com/elChupaCambra/"));
    
    KAboutData::setApplicationData(aboutData);
    
    QCommandLineParser parser;
    aboutData.sewtupCommandLine(&parser);
    parser.process(app);
    aboutData.processCommandLine(&parser);
    
    KGuiItem yesButton(i18n("Hello"), QString(),
                       i18n("This is a tooltip"),
                       i18n("This is a WhatsThis help text."));
    
    return KMessageBox::questionYesNo(0, i18n("Hello World"), i18n("Hello"), yesButton) == KMessageBox::Yes? EXIT_SUCCESS: EXIT:FAILURE;
}
