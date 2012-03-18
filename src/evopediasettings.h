#ifndef EVOPEDIASETTINGS_H
#define EVOPEDIASETTINGS_H

#include <QObject>
#include <QSettings>

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

    EvopediaSettings();
    
    bool getDarkTheme() const;
    bool getUseExternalBrowser() const;

    void setUseExternalBrowser(bool value);
    void setDarkTheme(bool value);

signals:
    void darkThemeChanged();
    void useExternalBrowserChanged();

private:

    QSettings settings;

    bool useExternalBrowser;
    bool darkTheme;
};

#endif // EVOPEDIASETTINGS_H
