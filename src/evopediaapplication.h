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

#ifndef EVOPEDIAAPPLICATION_H
#define EVOPEDIAAPPLICATION_H

#include <QApplication>
#include <QDesktopServices>
#include <QtDeclarative>
#include <QSharedPointer>
#include "evopedia.h"
#include "mainwindow.h"

class EvopediaApplication : public QApplication
{
    Q_OBJECT
public:
    explicit EvopediaApplication(int &argc, char **argv);
    ~EvopediaApplication();

    QSharedPointer<Evopedia> evopedia() { return m_evopedia; }

    void openArticle(const QSharedPointer<Title> title){
        QDesktopServices::openUrl(m_evopedia->getArticleUrl(title));
        emit openUrl(m_evopedia->getArticleUrl(title));
    }
//    void getArticleHtml(const QSharedPointer<Title> title)
//    {
//        emit showHtml(m_evopedia->getArticleHtml());
//    }

    QString getArticleURL(const QSharedPointer<Title> title){
        return m_evopedia->getArticleUrl(title).toString();
    }


signals:
    void openUrl(QUrl url);
//    void showHtml(QString& html);

public slots:
private:
    QSharedPointer<Evopedia> m_evopedia;
    MainWindow *m_mainwindow;

};

#endif // EVOPEDIAAPPLICATION_H
