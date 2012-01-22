import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: dumpSettingsPage
    tools: toolsMenu
    ListView {
        anchors.fill: parent
        id: archiveList
        model: archiveModel
        delegate: ArchiveDelegate{}
    }
    ToolBarLayout {
        id: settingsTools
        visible: true
        ToolIcon {
            platformIconId: "toolbar-view-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: (toolsMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }
    Menu {
        id: toolsMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem { text: qsTr("Manually Add Archive") }
            MenuItem { text: qsTr("Refresh Archive List") }
            MenuItem { text: qsTr("Change Default Archive Dir") }
            MenuItem { text: qsTr("Compact Layout") }
        }
    }
}
