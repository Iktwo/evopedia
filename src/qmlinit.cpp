#include "qmlinit.h"

//QmlInit::QmlInit(QWidget *parent)
QmlInit::QmlInit()
{

    titleListModel=QSharedPointer<TitleListModel>(new TitleListModel());

// set up the evopedia specifics
    titleListModel->setTitleIterator(TitleIterator());
    evopedia = (static_cast<EvopediaApplication *>(qApp))->evopedia();
    foreach (LocalArchive *b, evopedia->getArchiveManager()->getDefaultLocalArchives())
    {
       qDebug() << b->getLanguage();
       lang = b->getLanguage();
//       on_languageChooser_currentIndexChanged(lang);
       refreshSearchResults();
    }


// define the view and context for QML interaction
    view = QSharedPointer<QDeclarativeView>(new QDeclarativeView());
    QDeclarativeContext *rootCtxt = view->rootContext();

// set the model up in the list view to use the titleListModel
    rootCtxt->setContextProperty("titlesModel", titleListModel.data());

    view->setSource(QUrl("qrc:/Main.qml"));
    view->show();
}

void QmlInit::on_languageChooser_currentIndexChanged(const QString &text)
{
//    Qt::LayoutDirection dir = getLayoutDirection(text);
//    ui->listView->setLayoutDirection(dir);
//    ui->searchField->setLayoutDirection(dir);
    refreshSearchResults();
}

void QmlInit::refreshSearchResults()
{
//    Evopedia *evopedia = (static_cast<EvopediaApplication *>(qApp))->evopedia();
    QSharedPointer<Evopedia> evopedia = (static_cast<EvopediaApplication *>(qApp))->evopedia();
//    LocalArchive *backend = evopedia->getArchiveManager()->getLocalArchive(ui->languageChooser->currentText());
    LocalArchive *backend = evopedia->getArchiveManager()->getLocalArchive(lang);
    TitleIterator it;
    if (backend != 0)
//        it = backend->getTitlesWithPrefix(ui->searchField->text());
        it = backend->getTitlesWithPrefix("");
    titleListModel->setTitleIterator(it);
}
