QMAKEVERSION = $$[QMAKE_VERSION]
ISQT4 = $$find(QMAKEVERSION, ^[2-9])
isEmpty( ISQT4 ) {
error("Use the qmake include with Qt4.4 or greater, on Debian that is qmake-qt4");
}

symbian {
 TARGET.UID3 =  0xea2a762a
 TARGET.EPOCSTACKSIZE =  0x14000
 TARGET.EPOCHEAPSIZE =  0x020000  0x800000
}

TARGET = evopedia
TEMPLATE = app
include(src.pri)
symbian:include(bzlib.pri)
include(src/qmlapplicationviewer/qmlapplicationviewer.pri)

OTHER_FILES += \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/manifest.aegis \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog \
    resources/harmattan/evopedia.svg \
    resources/harmattan/evopedia80.png \
    resources/harmattan/evopedia64.png \
    src/ui/SearchPage.qml \
    src/ui/mapWindow.qml \
    src/ui/mainwindow.qml \
    src/ui/dumpSettings.qml \
    src/qml/SearchPage.qml \
    src/qml/mapWindow.qml \
    src/qml/mainwindow.qml \
    src/qml/dumpSettings.qml \
    src/qml/archiveDetailsDialog.qml \
    resources/harmattan/qml/SearchPage.qml \
    resources/harmattan/qml/mapWindow.qml \
    resources/harmattan/qml/mainwindow.qml \
    resources/harmattan/qml/dumpSettings.qml \
    resources/harmattan/qml/archiveDetailsDialog.qml \
    resources/harmattan/qml/TitlesDelegate.qml \
    resources/harmattan/qml/ArchiveDelegate.qml \
    resources/harmattan/qml/NoArchiveMsgBox.qml

HEADERS += \
    src/bzlib.h

#RESOURCES += \
#    resources/resources.qml















contains(MEEGO_EDITION,harmattan) {
    icon.files = evopedia.png
    icon.path = /usr/share/icons/hicolor/80x80/apps
    INSTALLS += icon
}

