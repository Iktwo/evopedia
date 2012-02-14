import QtQuick 1.1
import com.nokia.meego 1.0

PageStackWindow {
    id: rootWindow

    initialPage: searchPage

    SearchPage {
        id: searchPage
        Component.onCompleted: {
            theme.inverted=true;
        }
    }

    ToolBarLayout {
        id: commonTools
        visible: true
        ToolIcon {
            platformIconId: "toolbar-settings"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: {
                pageStack.push(settingsPage);
                //(myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
            }
        }
    }

    ToolBarLayout {
        id: settingsTools
        visible: false;
        ToolIcon {
            platformIconId: "toolbar-back";
            onClicked: {settingsMenu.close(); pageStack.pop() }
        }
        ToolIcon {
            platformIconId: "toolbar-view-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: (settingsMenu.status == DialogStatus.Closed) ? settingsMenu.open() : settingsMenu.close()
        }
    }

    /*Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem {
                text: qsTr("Settings")
                onClicked: {
                    pageStack.push(settingsPage);
                }
            }
        }
    }*/

    Menu {
        id: settingsMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem {
                text: qsTr("About")
                onClicked: {
                    aboutDialog.open();
                }
            }
        }
    }

    SettingsPage{
        id: settingsPage;
    }

    AboutDialog{
        id: aboutDialog;
    }
}
