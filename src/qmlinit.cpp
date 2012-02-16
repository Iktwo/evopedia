#include "qmlinit.h"

QmlInit::QmlInit(QWidget* parent)
{

    titleListModel=QSharedPointer<TitleListModel>(new TitleListModel());
    languageList.reserve(1);
    searchPrefix=QString("");

// define the view and context for QML interaction
    view = QSharedPointer<QDeclarativeView>(new QDeclarativeView());
//    rootCtxt = QSharedPointer<QDeclarativeContext>(view->rootContext());
//    QDeclarativeContext *rootCtxt = new QDeclarativeContext(view->rootContext());

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
//    rootCtxt->setContextProperty("titlesModel", titleListModel.data());
//    rootCtxt->setContextProperty("languageSelectionModel", languageListModel.data());
    view->rootContext()->setContextProperty("titlesModel", titleListModel.data());
    view->rootContext()->setContextProperty("languageSelectionModel", languageListModel.data());

    view->setSource(QUrl("qrc:/Main.qml"));
    view->showFullScreen();

//    rootCtxt->setContextProperty("QmlInit",this);
    view->rootContext()->setContextProperty("QmlInit",this);

    languageListModel->setStringList(languageList);

    QSettings *settings = new QSettings(QDir::homePath()+"/.evopediarc",QSettings::IniFormat);
    useExternalBrowser = (settings->value("useExternalBrowser",false).toBool());
    darkTheme = (settings->value("darkTheme",true).toBool());
    view->rootContext()->setContextProperty("darkTheme",darkTheme);
    view->rootContext()->setContextProperty("useExternalBrowser",useExternalBrowser);
    delete settings;
}

//QmlInit::~QmlInit()
//{
//    if rootC
//}

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

void QmlInit::setUseExternalBrowser(bool value){
    useExternalBrowser = value;
    view->rootContext()->setContextProperty("useExternalBrowser", useExternalBrowser);

    QSettings *settings = new QSettings(QDir::homePath()+"/.evopediarc",QSettings::IniFormat);
    settings->setValue("useExternalBrowser",useExternalBrowser);
    delete settings;
}

void QmlInit::setDarkTheme(bool value){
    darkTheme = value;
    view->rootContext()->setContextProperty("darkTheme", darkTheme);

    QSettings *settings = new QSettings(QDir::homePath()+"/.evopediarc",QSettings::IniFormat);
    settings->setValue("darkTheme",darkTheme);
    delete settings;
}
