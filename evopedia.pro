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

!isEmpty(MEEGO_VERSION_MAJOR) {
    splash.files = resources/harmattan/splash.png
    splash.path = /usr/share/evopedia
    INSTALLS += splash
}

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
    src/qml/SettingsPage.qml \
    src/qml/AboutDialog.qml \
    src/qml/TittleBar.qml \
    src/qml/ArticleView.qml

HEADERS += \
    src/bzlib.h \
    src/qmlinit.h \
    qstringlistmodelforqml.h \
    src/evopediasettings.h


contains(MEEGO_EDITION,harmattan) {
    icon.files = evopedia.png
    icon.path = /usr/share/icons/hicolor/80x80/apps
    INSTALLS += icon
}

RESOURCES += \
    src/qml/qml.qrc \
#    resources/resources.qml

SOURCES += \
    src/qmlinit.cpp \
    qstringlistmodelforqml.cpp \
    src/evopediasettings.cpp


#OBJECTS_DIR = .obj
#MOC_DIR = .moc


