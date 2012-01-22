import QtQuick 1.1
import com.nokia.meego 1.0


Page {
    id: mapPage
    tools: mapMenu

    ToolBarLayout {
        id: mapTools
        visible: true
        ToolIcon {
            platformIconId: "toolbar-view-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: (toolsMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }
    Menu {
        id: mapMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem { text: qsTr("Show Articles") }
            MenuItem { text: qsTr("Go To GPS Position") }
            MenuItem { text: qsTr("Use GPS") }
            MenuItem { text: qsTr("Follow GPS") }
        }
    }
}
