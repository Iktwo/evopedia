#ifndef QMLINIT_H
#define QMLINIT_H

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

Q_DECLARE_METATYPE(QModelIndex)

class QmlInit : public QObject
{
    Q_OBJECT

public:
//    QmlInit(QWidget *parent = 0);
    QmlInit();
private:
    QSharedPointer<QDeclarativeView> view;
    QSharedPointer<QmlApplicationViewer> viewer;
    QSharedPointer<QDeclarativeContext> rootCtxt;
//    QDeclarativeContext *ctxt;

    QSharedPointer<TitleListModel> titleListModel;
    MapWindow *mapWindow;
    DumpSettings *dumpSettings;
    QSharedPointer<Evopedia> evopedia;
    QString lang;
    QString searchPrefix;
    QStringList languageList;
    QSharedPointer<QStringListModelForQML> languageListModel;

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
//    void on_listView_activated(int index);
    void on_searchField_textChanged(QString text);
//    void mapViewRequested(qreal lat, qreal lon, uint zoom);
//    void backendsChanged(QList<LocalArchive *>backends);
    void refreshSearchResults();
};

#endif // QMLINIT_H