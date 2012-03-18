import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: settingsPage;
    tools: settingsTools;

    TitleBar{
        id: titleBar;
        anchors.top: parent.top
        color: "#1C1C1C";
        title: "Evopedia"
        author: "Settings"
    }

    Button{
        id: btnLanguage
        text: "Language";
        onClicked: langDialog.open()
        anchors.top: titleBar.bottom
        anchors.topMargin: 10
    }

    Label{
        id: lblTheme
        text: "Dark Theme"
        anchors.verticalCenter: swtTheme.verticalCenter
    }

    Switch {
        id: swtTheme;
        checked: evopediaSettings.darkTheme
        anchors.left: lblTheme.right
        anchors.leftMargin: 10
        anchors.top: btnLanguage.bottom
        anchors.topMargin: 10
        /*platformStyle: SwitchStyle {
            switchOn: "image://theme/color2-meegotouch-switch-on"
        }*/

        onCheckedChanged: {
            theme.inverted = checked
            evopediaSettings.darkTheme = checked
        }
    }

    Label{
        id: lblExternalBrowser
        text: "Use external browser"
        anchors.verticalCenter: swtExternalBrowser.verticalCenter
    }

    Switch {
        id: swtExternalBrowser;
        checked: evopediaSettings.useExternalBrowser
        anchors.left: lblExternalBrowser.right
        anchors.leftMargin: 10
        anchors.top: swtTheme.bottom
        anchors.topMargin: 10
        /*platformStyle: SwitchStyle {
            switchOn: "image://theme/color2-meegotouch-switch-on"
        }*/

        onCheckedChanged: {
            evopediaSettings.useExternalBrowser = checked
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
