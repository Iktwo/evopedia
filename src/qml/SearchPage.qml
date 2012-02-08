import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: searchPage
    tools: commonTools

    ListView {
        id: titlesView
        anchors {
            top: parent.top
            bottom: searchField.top
            left: parent.left
            right: parent.right
        }

        model: titlesModel
        delegate: Text { text: name }
    }

    TextField {
        id: searchField
        placeholderText: "Searchterm..."
        anchors.bottom: parent.bottom
    }

    Button {
        id: languageButton
        text: "xx"
        anchors.left: searchField.right
        anchors.bottom: parent.bottom
        onClicked: langDialog.open()
    }

    ScrollDecorator {
        flickableItem: titlesView
    }

    SelectionDialog {
        id: langDialog
        titleText: qsTr("Language")
        model: ListModel {
            ListElement { name: "first" }
            ListElement { name: "second" }
        }

//        title: Rectangle {
//            id: titleField
//            height: 2
//            width: parent.width
//            color: "white"
//        }

//        content:Item {
//            id: name
//            height: 50
//            width: parent.width
//            Text {
//                id: text
//                font.pixelSize: 22
//                anchors.centerIn: parent
//                color: "white"
//                text: qsTr("Language")
//            }
//        }
    }
}
