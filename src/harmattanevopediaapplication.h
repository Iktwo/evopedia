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
    HarmattanEvopediaApplication(int& argc, char** argv);

private:
    void openArticle(const QSharedPointer<Title> title);

private:
    QSharedPointer<QDeclarativeView> view;

    QSharedPointer<TitleListModel> titleListModel;
//    MapWindow *mapWindow;
//    DumpSettings *dumpSettings;
    Evopedia evopedia;
    QString lang;
    QString searchPrefix;
    QStringList languageList;
    QSharedPointer<QStringListModelForQML> languageListModel;
//    QDeclarativeContext *rootCtxt;

    EvopediaSettings settings;

protected:
    void closeEvent(QCloseEvent *event);

public slots:
//    void on_actionDeny_toggled(bool v);
//    void on_actionAllow_toggled(bool v);
//    void on_actionAuto_toggled(bool v);
//    void on_actionConfigure_Dumps_triggered();
//    void on_actionMap_triggered();
//    void on_actionAbout_triggered();
    void on_languageChooser_currentIndexChanged(QString text);
    void on_listView_activated(QModelIndex index);
    void on_title_selected(QString title);
    QString getArticleURL(QString title);
//    void on_listView_activated(int index);
    void on_searchField_textChanged(QString text);
//    void mapViewRequested(qreal lat, qreal lon, uint zoom);
//    void backendsChanged(QList<LocalArchive *>backends);
    void refreshSearchResults();

};

#endif // HARMATTAN_EVOPEDIA_APPLICATION_H
