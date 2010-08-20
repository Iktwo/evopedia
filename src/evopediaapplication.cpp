#include "evopediaapplication.h"

#include <QTranslator>

#include "mainwindow.h"

EvopediaApplication::EvopediaApplication(int &argc, char **argv) :
    QApplication(argc, argv)
{
#if defined(Q_WS_X11)
    QApplication::setGraphicsSystem("raster");
#endif

    QTranslator *qtTranslator = new QTranslator(this);
    qtTranslator->load(":tr/evopedia_" + QLocale::system().name());
    installTranslator(qtTranslator);

    m_evopedia = new Evopedia(this);
    m_mainwindow = new MainWindow();

#if defined(Q_WS_S60)
    m_mainwindow->showMaximized();
#else
    m_mainwindow->show();
#endif
}

EvopediaApplication::~EvopediaApplication()
{
    delete m_mainwindow;
}

int main(int argc, char *argv[])
{
    EvopediaApplication app(argc, argv);
    return app.exec();
}