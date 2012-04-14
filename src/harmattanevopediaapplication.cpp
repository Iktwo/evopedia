#include "harmattanevopediaapplication.h"
#include <applauncherd/MDeclarativeCache>

HarmattanEvopediaApplication::HarmattanEvopediaApplication(int& argc, char** argv)
    : application(MDeclarativeCache::qApplication(argc, argv)),
      view(MDeclarativeCache::qDeclarativeView()),
      evopedia(new Evopedia()),
      settings(new EvopediaSettings(evopedia.data())),
      languageListModel(new QStringListModelForQML("name")),
      titleListModel(new TitleListModel()){

    searchPrefix = "";

    // Set up the models
    languageListModel->setStringList(settings->getLanguageList());
    titleListModel->setTitleIterator(TitleIterator());

    // Export some C++ objects to QML.
    view->rootContext()->setContextProperty("languageListModel", languageListModel.data());
    view->rootContext()->setContextProperty("titlesModel", titleListModel.data());
    view->rootContext()->setContextProperty("evopedia", this);
    view->rootContext()->setContextProperty("evopediaSettings", settings.data());

    // Set up the view
    view->setSource(QUrl("qrc:/Main.qml"));
    view->setAttribute(Qt::WA_OpaquePaintEvent);
    view->setAttribute(Qt::WA_NoSystemBackground);
    view->viewport()->setAttribute(Qt::WA_OpaquePaintEvent);
    view->viewport()->setAttribute(Qt::WA_NoSystemBackground);

    view->showFullScreen();

    connect(settings.data(), SIGNAL(languageIndexChanged()), this, SLOT(refreshSearchResults()));
    connect(this, SIGNAL(searchPrefixChanged()), this, SLOT(refreshSearchResults()));

    refreshSearchResults();
}

QString HarmattanEvopediaApplication::getSearchPrefix() const {
    return searchPrefix;
}

void HarmattanEvopediaApplication::setSearchPrefix(QString s) {
    QString oldSearchPrefix = searchPrefix;

    searchPrefix = s;

    if (searchPrefix != oldSearchPrefix)
        emit searchPrefixChanged();
}

void HarmattanEvopediaApplication::refreshSearchResults()
{
    if (settings->getLanguageIndex() == -1 || searchPrefix.isEmpty()) {
        titleListModel->setTitleIterator(TitleIterator());
        return;
    }

    QString lang = settings->getLanguageList()[settings->getLanguageIndex()];

    LocalArchive *backend = evopedia->getArchiveManager()->getLocalArchive(lang);

    if (backend == NULL) {
        titleListModel->setTitleIterator(TitleIterator());
        return;
    }

    TitleIterator it = backend->getTitlesWithPrefix(searchPrefix);
    titleListModel->setTitleIterator(it);
}

QString HarmattanEvopediaApplication::getArticleURL(QString title){
    return evopedia->getArticleUrl(titleListModel->getTitleFrom(title)).toString();
}
