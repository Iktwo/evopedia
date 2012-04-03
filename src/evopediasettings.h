#ifndef EVOPEDIASETTINGS_H
#define EVOPEDIASETTINGS_H

#include <QObject>
#include <QSettings>
#include "evopedia.h"

class EvopediaSettings : public QObject
{
    Q_OBJECT

public:
    Q_PROPERTY(bool darkTheme
               READ getDarkTheme
               WRITE setDarkTheme
               NOTIFY darkThemeChanged)

    Q_PROPERTY(bool useExternalBrowser
               READ getUseExternalBrowser
               WRITE setUseExternalBrowser
               NOTIFY useExternalBrowserChanged)

    Q_PROPERTY(int languageIndex
               READ getLanguageIndex
               WRITE setLanguageIndex
               NOTIFY languageIndexChanged)

    Q_PROPERTY(QStringList languageList
               READ getLanguageList)

    EvopediaSettings(Evopedia* evopedia);

    bool getDarkTheme() const;
    bool getUseExternalBrowser() const;
    int getLanguageIndex() const;
    QStringList getLanguageList() const;

    void setUseExternalBrowser(bool value);
    void setDarkTheme(bool value);
    void setLanguageIndex(int i);

signals:
    void darkThemeChanged();
    void useExternalBrowserChanged();
    void languageIndexChanged();

private:

    QSettings settings;
    Evopedia* evopedia;

    bool useExternalBrowser;
    bool darkTheme;
    int languageIndex;
    QStringList languageList;
};

#endif // EVOPEDIASETTINGS_H
