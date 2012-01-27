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

#include "titleiterator.h"

#include <QByteArray>

#include "localarchive.h"

TitleIterator::TitleIterator()
    : device(0), prefix(QString())
{
    checkHasNext();
}

//TitleIterator::~TitleIterator()
//{
//    if(device!=NULL)
//        delete device;
//}

//TitleIterator::TitleIterator(QIODevice *device_ini, const QString &prefix, const QString &language)
TitleIterator::TitleIterator(QSharedPointer<QIODevice> device_ini, const QString &prefix, const QString &language)
    : language(language), device(device_ini), prefix(LocalArchive::normalize(prefix))
{
    checkHasNext();
}

bool TitleIterator::hasNext() const
{
    if(nextTitle==NULL)
        return false;

    return !nextTitle->getName().isNull();
}

void TitleIterator::checkHasNext()
{
    if (device == 0 || device->atEnd()) {
        nextTitle =QSharedPointer<Title>();
    } else {
        QByteArray line = device->readLine();
        nextTitle = QSharedPointer<Title>(new Title(line.left(line.length() - 1), language));
        if (!prefix.isNull()) {
            QString tn = LocalArchive::normalize(nextTitle->getName());
            if (!tn.startsWith(prefix))
                nextTitle = QSharedPointer<Title>();
        }
    }
}

QSharedPointer<Title> TitleIterator::next()
{
    QSharedPointer<Title> t;
    t = QSharedPointer<Title>(new Title(nextTitle->encTitle, language));
    checkHasNext();
    return t;
}
