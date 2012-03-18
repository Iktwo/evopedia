#include "qmlinit.h"

QmlInit::QmlInit(QWidget* parent)
{

    titleListModel=QSharedPointer<TitleListModel>(new TitleListModel());
    languageList.reserve(1);
    searchPrefix=QString("");

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
    languageListModel->setStringList(languageList);

    // define the view and context for QML interaction
    view = QSharedPointer<QDeclarativeView>(new QDeclarativeView());
    view->rootContext()->setContextProperty("titlesModel", titleListModel.data());
    view->rootContext()->setContextProperty("languageSelectionModel", languageListModel.data());
    view->rootContext()->setContextProperty("QmlInit", this);
    view->rootContext()->setContextProperty("evopediaSettings", &settings);

    view->setSource(QUrl("qrc:/Main.qml"));

    view->setAttribute(Qt::WA_OpaquePaintEvent);
    view->setAttribute(Qt::WA_NoSystemBackground);
    view->viewport()->setAttribute(Qt::WA_OpaquePaintEvent);
    view->viewport()->setAttribute(Qt::WA_NoSystemBackground);

    view->showFullScreen();
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
    LocalArchive *backend = evopedia->getArchiveManager()->getLocalArchive(lang);
    TitleIterator it;
    if (backend != 0)
        it = backend->getTitlesWithPrefix(searchPrefix);

    titleListModel->setTitleIterator(it);
}

void QmlInit::on_listView_activated(QModelIndex index)
{
    (static_cast<EvopediaApplication *>(qApp))->openArticle(titleListModel->getTitleAt(index));
}

void QmlInit::on_title_selected(QString title)
{
    (static_cast<EvopediaApplication *>(qApp))->openArticle(titleListModel->getTitleFrom(title));
}

void QmlInit::on_open_url(QUrl url)
{

//    QDeclarativeEngine engine;
//    QDeclarativeComponent component(&engine, "qrc:/TitleViewer.qml");
//    QObject *object = component.create();

//    view->rootObject()->setProperty("titelUrl", url.toString());
//    QDeclarativeContext *rootCtxt = new QDeclarativeContext(view->rootContext());
//    rootCtxt->setProperty("titelUrl", url.toString());
    view->rootContext()->setProperty("titelUrl", url.toString());

    qDebug() << url << endl;
}

void QmlInit::on_show_html(QString &html)
{
    qDebug() << html << endl;
}

QString QmlInit::getArticleURL(QString title){
    return (static_cast<EvopediaApplication *>(qApp))->getArticleURL(titleListModel->getTitleFrom(title));;
}
