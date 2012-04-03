#include "harmattanevopediaapplication.h"

HarmattanEvopediaApplication::HarmattanEvopediaApplication(int& argc, char** argv)
    : QApplication(argc, argv) {

    titleListModel=QSharedPointer<TitleListModel>(new TitleListModel());
    languageList.reserve(1);
    searchPrefix=QString("");

    view = QSharedPointer<QDeclarativeView>(new QDeclarativeView());

    // Set up the models

    titleListModel->setTitleIterator(TitleIterator());

    foreach (LocalArchive *b, evopedia.getArchiveManager()->getDefaultLocalArchives())
    {
        qDebug() << b->getLanguage();
        lang = b->getLanguage(); //DEBUG
        languageList << b->getLanguage();
        on_languageChooser_currentIndexChanged(lang);
        refreshSearchResults();
    }
    languageListModel = QSharedPointer<QStringListModelForQML>(new QStringListModelForQML());
    languageListModel->setStringList(languageList);

    // Export some C++ objects to QML.
    view->rootContext()->setContextProperty("titlesModel", titleListModel.data());
    view->rootContext()->setContextProperty("languageSelectionModel", languageListModel.data());
    view->rootContext()->setContextProperty("evopedia", this);
    view->rootContext()->setContextProperty("evopediaSettings", &settings);

    view->setSource(QUrl("qrc:/Main.qml"));

    view->setAttribute(Qt::WA_OpaquePaintEvent);
    view->setAttribute(Qt::WA_NoSystemBackground);
    view->viewport()->setAttribute(Qt::WA_OpaquePaintEvent);
    view->viewport()->setAttribute(Qt::WA_NoSystemBackground);

    view->showFullScreen();
}

void HarmattanEvopediaApplication::on_languageChooser_currentIndexChanged(QString text)
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

void HarmattanEvopediaApplication::on_searchField_textChanged(QString text)
{
    searchPrefix=text;
    refreshSearchResults();
}


void HarmattanEvopediaApplication::refreshSearchResults()
{
    LocalArchive *backend = evopedia.getArchiveManager()->getLocalArchive(lang);
    TitleIterator it;
    if (backend != 0)
        it = backend->getTitlesWithPrefix(searchPrefix);

    titleListModel->setTitleIterator(it);
}

void HarmattanEvopediaApplication::on_listView_activated(QModelIndex index)
{
    openArticle(titleListModel->getTitleAt(index));
}

void HarmattanEvopediaApplication::on_title_selected(QString title)
{
    openArticle(titleListModel->getTitleFrom(title));
}

void HarmattanEvopediaApplication::openArticle(const QSharedPointer<Title> title){
    QUrl url = evopedia.getArticleUrl(title);
    QDesktopServices::openUrl(url);

    view->rootContext()->setProperty("titelUrl", url.toString());

    qDebug() << url.toString() << endl;
}

QString HarmattanEvopediaApplication::getArticleURL(QString title){
    return evopedia.getArticleUrl(titleListModel->getTitleFrom(title)).toString();
}
