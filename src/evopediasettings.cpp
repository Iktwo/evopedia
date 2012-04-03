#include "evopediasettings.h"

#include <QDir>

EvopediaSettings::EvopediaSettings(Evopedia* evopedia)
    : settings(QDir::homePath() + "/.evopediarc", QSettings::IniFormat),
      evopedia(evopedia) {

    useExternalBrowser = settings.value("useExternalBrowser",false).toBool();
    darkTheme = settings.value("darkTheme",true).toBool();

    foreach (LocalArchive *b, evopedia->getArchiveManager()->getDefaultLocalArchives()) {
        qDebug() << "Found language: " << b->getLanguage();
        languageList << b->getLanguage();
    }

    setLanguageIndex(settings.value("languageIndex", 0).toInt());
}

bool EvopediaSettings::getDarkTheme() const {
    return darkTheme;
}

bool EvopediaSettings::getUseExternalBrowser() const {
    return useExternalBrowser;
}

int EvopediaSettings::getLanguageIndex() const {
    return languageIndex;
}

QStringList EvopediaSettings::getLanguageList() const {
    return languageList;
}

void EvopediaSettings::setUseExternalBrowser(bool value) {

    if (useExternalBrowser == value)
        return;

    useExternalBrowser = value;

    settings.setValue("useExternalBrowser",useExternalBrowser);

    emit useExternalBrowserChanged();
}

void EvopediaSettings::setDarkTheme(bool value) {

    if (darkTheme == value)
        return;

    darkTheme = value;

    settings.setValue("darkTheme",darkTheme);

    emit darkThemeChanged();
}

void EvopediaSettings::setLanguageIndex(int i) {
    const int oldLanguageIndex = languageIndex;

    if (i >= 0 && i < languageList.size())
        languageIndex = i;
    else {
        if (languageList.empty())
            languageIndex = -1;
        else
            languageIndex = 0;
    }

    settings.setValue("languageIndex", languageIndex);

    if (languageIndex != oldLanguageIndex)
        emit languageIndexChanged();
}
