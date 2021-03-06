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

#include "bzreader.h"

#include <QByteArray>
#include <QFile>

BZReader::BZReader()
{
}


const QByteArray BZReader::readAt(QFile &f, quint32 blockStart, quint32 blockOffset, quint32 dataLength)
{
    memset(&stream, 0, sizeof(stream));
    if (BZ2_bzDecompressInit(&stream, 0, 0) != BZ_OK)
        return QByteArray();

    f.seek(blockStart);
    QByteArray outbuffer(blockOffset + dataLength, '\0');
    /* actually we do not need to save the first blockOffset bytes */
    stream.avail_out = outbuffer.size();
    stream.next_out = outbuffer.data();

    QByteArray inbuffer;
    do {
        QByteArray newData = f.read(20480);
        if (newData.length() == 0)
            break;
        inbuffer += newData;
        stream.avail_in = inbuffer.length();
        stream.next_in = inbuffer.data();

        if (BZ2_bzDecompress(&stream) != BZ_OK)
            break;

        inbuffer = inbuffer.right(stream.avail_in);
    } while (stream.avail_out != 0);

    BZ2_bzDecompressEnd(&stream);

    return outbuffer.mid(blockOffset, dataLength);
}
