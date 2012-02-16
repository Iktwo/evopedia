import QtQuick 1.1
import com.nokia.meego 1.0

Dialog {
    id: myDialog
    title: Text{text:"No Archives Configured"}

    content:Item {
        id: name
        height: 50
        width: parent.width
        Text {
            id: text
            font.pixelSize: 22
            anchors.centerIn: parent
            color: "white"
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

    buttons: ButtonRow {
        style: ButtonStyle { }
        anchors.horizontalCenter: parent.horizontalCenter
        Button {text: "OK"; onClicked: myDialog.accept()}
    }
}
