#ifndef HARMATTAN_EVOPEDIA_APPLICATION_H
#define HARMATTAN_EVOPEDIA_APPLICATION_H

#include <QTimer>
#include <QString>
#include <QtDeclarative>
#include <QSharedPointer>
#include <QStringList>
#include <QStringListModel>

#include "localarchive.h"
#include "titlelistmodel.h"
#include "evopedia.h"
#include "dumpsettings.h"
#include "qmlapplicationviewer/qmlapplicationviewer.h"
#include "evopediaapplication.h"
#include "qstringlistmodelforqml.h"
#include "utils.h"
#include "defines.h"

#include "evopediasettings.h"

Q_DECLARE_METATYPE(QModelIndex)

class HarmattanEvopediaApplication : public QApplication
{
    Q_OBJECT    

public:

    Q_PROPERTY(QString searchPrefix
               READ getSearchPrefix
               WRITE setSearchPrefix
               NOTIFY searchPrefixChanged)

    HarmattanEvopediaApplication(int& argc, char** argv);

    QString getSearchPrefix() const;
    void setSearchPrefix(QString s);

signals:
    void searchPrefixChanged();

private:
    void openArticle(const QSharedPointer<Title> title);

private:
    QSharedPointer<QDeclarativeView> view;

    QSharedPointer<Evopedia> evopedia;
    QSharedPointer<EvopediaSettings> settings;

    QSharedPointer<QStringListModelForQML> languageListModel;
    QSharedPointer<TitleListModel> titleListModel;

    QString searchPrefix;

protected:
    void closeEvent(QCloseEvent *event);

public slots:
    void on_listView_activated(QModelIndex index);
    void on_title_selected(QString title);
    QString getArticleURL(QString title);
    void refreshSearchResults();

};

#endif // HARMATTAN_EVOPEDIA_APPLICATION_H
