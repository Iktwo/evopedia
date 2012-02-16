#include "qmlinit.h"

QmlInit::QmlInit()
{

    titleListModel=QSharedPointer<TitleListModel>(new TitleListModel());
    languageList.reserve(1);
    searchPrefix=QString("");

// define the view and context for QML interaction
    view = QSharedPointer<QDeclarativeView>(new QDeclarativeView());
    QDeclarativeContext *rootCtxt = view->rootContext();

    // set up the evopedia specifics
    titleListModel->setTitleIterator(TitleIterator());
    evopedia = (static_cast<EvopediaApplication *>(qApp))->evopedia();
    foreach (LocalArchive *b, evopedia->getArchiveManager()->getDefaultLocalArchives())
    {
        qDebug() << b->getLanguage();
        lang = b->getLanguage(); //DEBUG
        languageList << b->getLanguage();
        on_languageChooser_currentIndexChanged(lang);
        refreshSearchResults();
    }
    //    languageList << "spanish" << "german";




    languageListModel = QSharedPointer<QStringListModelForQML>(new QStringListModelForQML());

    // set the model up in the list view to use the titleListModel
    rootCtxt->setContextProperty("titlesModel", titleListModel.data());
    rootCtxt->setContextProperty("languageSelectionModel", languageListModel.data());

    view->setSource(QUrl("qrc:/Main.qml"));
    view->showFullScreen();

    QObject *rootObject= view->rootObject();
    view->rootContext()->setContextProperty("QmlInit",this);

    languageListModel->setStringList(languageList);
}

void QmlInit::on_languageChooser_currentIndexChanged(QString text)
{
    //    QDeclarativeContext *rootCtxt = view->rootCtxt();
    QObject* rootObject = view->rootObject();
    if(rootObject!=NULL)
        rootObject->setProperty("languageButtonText",QVariant(text));

//    Qt::LayoutDirection dir = getLayoutDirection(text);
//    ui->listView->setLayoutDirection(dir);
//    ui->searchField->setLayoutDirection(dir);
    lang = text;
    refreshSearchResults();
}

void QmlInit::on_searchField_textChanged(QString text)
{
    searchPrefix=text;
    refreshSearchResults();
}


void QmlInit::refreshSearchResults()
{
    QSharedPointer<Evopedia> evopedia = (static_cast<EvopediaApplication *>(qApp))->evopedia();
//    LocalArchive *backend = evopedia->getArchiveManager()->getLocalArchive(ui->languageChooser->currentText());
    LocalArchive *backend = evopedia->getArchiveManager()->getLocalArchive(lang);
    TitleIterator it;
    if (backend != 0)
        it = backend->getTitlesWithPrefix(searchPrefix);

    titleListModel->setTitleIterator(it);
}

void QmlInit::on_listView_activated(QModelIndex index)
//void QmlInit::on_listView_activated(int index)
{
    (static_cast<EvopediaApplication *>(qApp))->openArticle(titleListModel->getTitleAt(index));
}

void QmlInit::on_title_selected(QString title)
{
    (static_cast<EvopediaApplication *>(qApp))->openArticle(titleListModel->getTitleFrom(title));
}

QString QmlInit::getArticleURL(QString title){
    return (static_cast<EvopediaApplication *>(qApp))->getArticleURL(titleListModel->getTitleFrom(title));;
}

