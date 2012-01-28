import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    Rectangle {
        id: noArchiveMsgBox
        width: 200
        height: 400
        anchors.fill: parent
        Text {
            id: archiveHeader
            anchors.top: parent.top
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: parent / 10
            font.bold: true
            text: "No Archives Configured"
        }
        Text {
            id: archiveText
            anchors.top: archiveHeader.top
            anchors.topMargin: 10
            anchors.left: parent.left
            wrapMode: Text.WordWrap
            anchors.leftMargin: 10
            text: "To be able to use evopedia you have to " +
                   "download a Wikipedia archive. "+
                   "This can be done from within evopedia "+
                   "via the menu option \"Archives\". "+
                   "If you only want to try out evopedia, "+
                   "you can use the language \"small\", which "+
                   "is a small version of the English Wikipedia.<br />"+
                   "Do you want to download an archive now?"
        }
    }
}
