/*
 * evopedia: An offline Wikipedia reader.
 *
 * Copyright (C) 2010-2011 evopedia developers
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#include "evopediaapplication.h"

#include <QTranslator>
#include <QLibraryInfo>
#include <QtGui/QApplication>
#include <QtDeclarative>

#include "qmlapplicationviewer/qmlapplicationviewer.h"
#include "mainwindow.h"
#include "utils.h"
#include "qmlinit.h"

EvopediaApplication::EvopediaApplication(int &argc, char **argv) :
    QApplication(argc, argv)
{
#if defined(Q_WS_X11)
    QApplication::setGraphicsSystem("raster");
#endif
    m_mainwindow=NULL;

    QTranslator *qtTranslator = new QTranslator(this);
    qtTranslator->load("qt_" + QLocale::system().name(), QLibraryInfo::location(QLibraryInfo::TranslationsPath));
    installTranslator(qtTranslator);

    qtTranslator = new QTranslator(this);
    qtTranslator->load(":tr/evopedia_" + QLocale::system().name());
    installTranslator(qtTranslator);


    m_evopedia = QSharedPointer<Evopedia>(new Evopedia(this));
//    QmlInit *setupQml = new QmlInit();
//    m_mainwindow = new MainWindow();

#if defined(Q_WS_S60)
//    m_mainwindow->showMaximized();
#else
//    m_mainwindow->show();
#endif
}

EvopediaApplication::~EvopediaApplication()
{
    if(m_mainwindow!=NULL)
        delete m_mainwindow;
}

Q_DECL_EXPORT main(int argc, char *argv[])
{
    /* initialize random number generator */

    QScopedPointer<EvopediaApplication> app(new EvopediaApplication(argc,argv));

    QSharedPointer<QmlInit> setupQml= QSharedPointer<QmlInit>(new QmlInit());

    QObject::connect(app.data(),SIGNAL(openUrl(QUrl)),setupQml.data(),SLOT(on_open_url(QUrl)));
//    QObject::connect(app.data(),SIGNAL(showHtml(QString&)),setupQml.data(),SLOT(on_show_html(QString&)));

    return app->exec();
}
