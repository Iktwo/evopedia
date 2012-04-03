
#include <harmattanevopediaapplication.h>

int main(int argc, char *argv[]) {
    HarmattanEvopediaApplication app(argc, argv);

    QTranslator qtTranslator;
    qtTranslator.load("qt_" + QLocale::system().name(), QLibraryInfo::location(QLibraryInfo::TranslationsPath));
    app.installTranslator(&qtTranslator);

    QTranslator evopediaTranslator;
    evopediaTranslator.load(":tr/evopedia_" + QLocale::system().name());
    app.installTranslator(&evopediaTranslator);

    return app.exec();
}
