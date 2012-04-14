
#include <harmattanevopediaapplication.h>

Q_DECL_EXPORT int main(int argc, char *argv[]) {
    HarmattanEvopediaApplication app(argc, argv);

    QTranslator qtTranslator;
    qtTranslator.load("qt_" + QLocale::system().name(), QLibraryInfo::location(QLibraryInfo::TranslationsPath));
    qApp->installTranslator(&qtTranslator);

    QTranslator evopediaTranslator;
    evopediaTranslator.load(":tr/evopedia_" + QLocale::system().name());
    qApp->installTranslator(&evopediaTranslator);

    return qApp->exec();
}
