import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: settingsPage;
    tools: settingsTools;

    TittleBar{
        id: tittleBar;
        anchors.top: parent.top
        color: "#1C1C1C";
        tittle: "Evopedia"
        author: "Settings"
    }

    Button{
        text: "Language";
        onClicked: langDialog.open()
        anchors.top: tittleBar.bottom
        anchors.topMargin: 20
    }

    Button{
        text: "Switch theme";
        anchors.top: tittleBar.bottom
        anchors.topMargin: 20
        onClicked: {
            theme.inverted=!theme.inverted;
        }
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

    Connections{
        target: languageSelectionModel
        onStringAdded: {
            langDialog.model.append({name: newString})
        }
    }
}
