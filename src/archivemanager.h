/*
===============================================================
  todo
===============================================================
 - make removal of local evopedias possible
 - fix dump parser

===============================================================
 how to find torrents
===============================================================
this regexp filter is needed to get all torrent links
  wikipedia_.._....-..-..\.torrent

source: dumpathome.evopedia.info/dumps/finished

===============================================================
 how to download
===============================================================
the evopedia::ArchiveManager tracks the installed evopedias based on the directory/name structure policy

wikipedia_de_2010-07-27.torrent <--> wikipedia_de_2010-07-27/
- if a new download (torrent) is started:
    then we check the evopedia::torrent_downloader history if
    a $whatever/wikipedia_de_2010-07-27_incomplete/ exists
    if so, we resume
 -> downloads have save/resume features, so the evopedia app can be
    started again later and the previous progress is not lost.
- if a download is complete, the directory is renamed:
  whatever/wikipedia_de_2010-07-27_incomplete/ <--> whatever/wikipedia_de_2010-07-27
  this step is important for seeding and not to download twice
  -> directories with '_incomplete' in the name can't be used

- wikipedia_de_2010-07-27.torrent - torrent files are stored in
  ~/.local/share/evopedia/torrents
  -> unused *.torrent files are removed if the respective archive
     is not found/existent anymore

===============================================================
 how to deploy
===============================================================
I) all files in a torrent, example:
  http://evopedia.info/dumps/wikipedia_en_2010-06-22.torrent
must be in a respective directory, example:
  wikipedia_en_2010-06-22/

II) all filename <-> in torrent filenames must match, that is:
   - language
   - date

an algorithm will be used to enforce the policies I and II

General:
 - if a download was started, resume it when this application is started
 - the netManager:
  - should only be started when the gui is actually shown (show())
  - can be 'refresh'ed manually using a button
 - the size/contents of the torrents can be queried when contacting the tracker

===============================================================
 new design:
===============================================================
 - an archive can be used as backend if it validates correctly
 - everything is an archive:
  - local evopedias (either valid or invalid)
  - a remote object (installation candidate)
  - torrentArchive or downloads (they are stored on program exit and restored on program start)
   - a active download (torrent)
   - a paused download (torrent)
   - a finished download (torrent) can potentially seed
 - if an archive quallifies as a valid backend, it's status changes 'by user authority' into a backend
  - downloads which have finished
  - achrives which have been added manually
  - if the newly added archive is the only archive represnting a language (as 'de') it is selected as default
    but if there are other (or at least one additional) 'de' installation the user has to pick which one to use
    the default is the newer one but if an older download finishes, a dialog is asking the user
*/

#ifndef ARCHIVEMANAGER_H
#define ARCHIVEMANAGER_H

#include <QList>
#include <QHash>
#include <QStandardItemModel>
#include <QStandardItem>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QMessageBox>
#include <QObject>

#include "storagebackend.h"
#include "archiveitem.h"

#define EVOPEDIA_URL "http://dumpathome.evopedia.info/dumps/finished"

class QStandardItemModel;

/*! manages different wikipedia dumps (called Archive)
** - this class should be instantiated only once
** - manages torrent downloads of archives
** - sets the default archives for each language
**   one may have installed several 'de' archives, but only
**   one can be used at a time.
** - manages archives, adds(downloads or removes them)
** - implements a QAbstractItemModel to visualize what is going on
*/
class ArchiveManager : public QObject {
Q_OBJECT
public:
    explicit ArchiveManager(QObject* parent);

    // functions to handle archives (invalid backends)
    bool setDefaultArchive(int identifier);
    ArchiveItem* addArchive(QString language, QString date, QString archiveDir, QString torrent, QUrl url, QString& ret);
    ArchiveItem* addArchive(QString dir, QString& ret);
    void updateRemoteArchives();

    // functions to handle backends (valid archives)
    StorageBackend *getBackend(const QString language, const QString date=QString()) const;
    StorageBackend *getRandomBackend() const;
    const QList<StorageBackend *> getBackends() const;
    bool hasLanguage(const QString language) const;
    QStandardItemModel* model();
signals:
    void backendsChanged(const QList<StorageBackend *> backends);

private slots:
        void networkFinished(QNetworkReply *reply);
        void updateBackends();
private:
    QStandardItemModel* m_model;
    QNetworkAccessManager netManager;
    ArchiveItem* addArchive(ArchiveItem* item);
};

#endif
