#include "qmlinit.h"

//QmlInit::QmlInit(QWidget *parent)
QmlInit::QmlInit()
{

    titleListModel=QSharedPointer<TitleListModel>(new TitleListModel());

//    viewer=QSharedPointer<QmlApplicationViewer>(new QmlApplicationViewer(QmlApplicationViewer::create()));
//    ctxt = viewer->rootContext();
//    ctxt->setContextProperty("",);

//    viewer->setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
//    viewer->setSource(QUrl("qrc:/Main.qml"));
//    viewer->showExpanded();

// set up the evopedia specifics
    titleListModel->setTitleIterator(TitleIterator());
//    Evopedia *evopedia = (static_cast<EvopediaApplication *>(qApp))->evopedia();
    evopedia = (static_cast<EvopediaApplication *>(qApp))->evopedia();
    foreach (LocalArchive *b, evopedia->getArchiveManager()->getDefaultLocalArchives())
//       ui->languageChooser->addItem(b->getLanguage());
       qDebug() << b->getLanguage();

// define the view and context for QML interaction
    view = QSharedPointer<QDeclarativeView>(new QDeclarativeView());
    QDeclarativeContext *rootCtxt = view->rootContext();

// set the model up in the list view to use the titleListModel
    rootCtxt->setContextProperty("titlesModel", titleListModel.data());


    view->setSource(QUrl("qrc:/Main.qml"));
    view->show();
}
