import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: searchPage
    tools: commonTools

    signal signalLanguageChanged(string lang);
    signal signalSearchTextChanged(string text);
    property string selectedTitle: ""

    ListView {
        id: titlesView
        anchors {
            top: parent.top
            bottom: searchField.top
            left: parent.left
            right: parent.right
        }
        model: visualTitlesModel

        VisualDataModel {
            id: visualTitlesModel
            model: titlesModel
            delegate:  Text {
                id: titleText
                text: "<b>" + name + "</b>"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        selectedTitle = name
                        console.log(selectedTitle)
//                        QmlInit.on_listView_activated(modelIndex[titlesView.model.selectedIndex])
//                        QmlInit.on_listView_activated(titlesView.currentIndex)
                        QmlInit.on_title_selected(selectedTitle)
                    }
                }
            }
        }
    }

    TextField {
        id: searchField
        placeholderText: "Searchterm..."
        anchors.bottom: parent.bottom
        onTextChanged: {
            searchPage.signalSearchTextChanged(searchField.text)
            QmlInit.on_searchField_textChanged(searchField.text)
        }
    }

    Button {
        id: languageButton
        text: "x"
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
        selectedIndex: 0
        model: ListModel { }
        onAccepted: {
            languageButton.text = langDialog.model.get(langDialog.selectedIndex).name
            searchPage.signalLanguageChanged(langDialog.model.get(langDialog.selectedIndex).name)
            QmlInit.on_languageChooser_currentIndexChanged(langDialog.model.get(langDialog.selectedIndex).name)
        }

        onRejected: {
            selectedIndex = 0
            searchPage.signalLanguageChanged(langDialog.model.get(langDialog.selectedIndex).name)
        }
    }

    Connections {
           target: languageSelectionModel
           onStringAdded: {
               langDialog.model.append({name: newString})
           }
       }
}
