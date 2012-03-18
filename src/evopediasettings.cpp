#include "evopediasettings.h"

#include <QDir>

EvopediaSettings::EvopediaSettings()
    : settings(QDir::homePath() + "/.evopediarc", QSettings::IniFormat) {
    useExternalBrowser = settings.value("useExternalBrowser",false).toBool();
    darkTheme = settings.value("darkTheme",true).toBool();
}

bool EvopediaSettings::getDarkTheme() const {
    return darkTheme;
}

bool EvopediaSettings::getUseExternalBrowser() const {
    return useExternalBrowser;
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
