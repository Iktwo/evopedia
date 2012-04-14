import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: settingsPage;
    tools: settingsTools;

    TitleBar{
        id: titleBar;
        anchors.top: parent.top
        color: "#1C1C1C";
        title: qsTr("Settings")
    }

    Label{
        id: lblTheme
        text: qsTr("Dark Theme")
        anchors.verticalCenter: swtTheme.verticalCenter
    }

    Switch {
        id: swtTheme;
        checked: evopediaSettings.darkTheme
        anchors.left: lblTheme.right
        anchors.leftMargin: 10
        anchors.top: titleBar.bottom
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
        text: qsTr("Use external browser")
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
}
