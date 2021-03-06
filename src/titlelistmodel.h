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

#ifndef TITLELISTMODEL_H
#define TITLELISTMODEL_H

#include <QAbstractListModel>
#include <QSharedPointer>
#include <QFile>

#include "title.h"
#include "titleiterator.h"

class TitleListModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ rowCount)

public:

    enum TitleRoles {
        NameRole = Qt::UserRole +1,
        LengthRole = Qt::UserRole +2
    };

    TitleListModel(QObject *parent = 0);
    ~TitleListModel();
    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    QSharedPointer<Title> getTitleAt(const QModelIndex &index) const;
    QSharedPointer<Title> getTitleFrom(const QString &title) const;
//    QSharedPointer<Title> getTitleAt(int row) const;
    Q_INVOKABLE QSharedPointer<Title> get(int index) {
        if(index<titles.size())
            return titles.at(index);
        else return QSharedPointer<Title>();
    }

protected:
    bool canFetchMore(const QModelIndex &parent) const;
    void fetchMore(const QModelIndex &parent);

signals:
    void numberPopulated(int number);

public slots:
    void setTitleIterator(TitleIterator iter);

private:
    TitleIterator titleIter;
    QList<QSharedPointer<Title> > titles;

};

#endif // TITLELISTMODEL_H
