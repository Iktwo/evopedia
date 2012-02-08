import QtQuick 1.1
import com.nokia.meego 1.0

PageStackWindow {
    id: rootWindow

    initialPage: searchPage

    SearchPage {
        id: searchPage
    }

    ToolBarLayout {
        id: commonTools
        visible: true
        ToolIcon {
            platformIconId: "toolbar-back";
            onClicked: {myMenu.close(); pageStack.pop() }
        }
        ToolIcon {
            platformIconId: "toolbar-view-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }
    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem { text: qsTr("Settings") }
        }
    }
}
