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

#ifndef TITLEITERATOR_H
#define TITLEITERATOR_H

#include <QIODevice>
#include <QString>
#include <QSharedPointer>

#include "title.h"

class TitleIterator
{
public:
    TitleIterator();
//    ~TitleIterator();
//    TitleIterator(QIODevice *device, const QString &prefix=QString(), const QString &language=QString());
    TitleIterator(QSharedPointer<QIODevice> device, const QString &prefix=QString(), const QString &language=QString());
    bool hasNext() const;
    QSharedPointer<Title> next();
private:
    void checkHasNext();

    QString language;
//    QIODevice *device;
    QSharedPointer<QIODevice> device;
    QString prefix;
    QSharedPointer<Title> nextTitle;
};

#endif // TITLEITERATOR_H
