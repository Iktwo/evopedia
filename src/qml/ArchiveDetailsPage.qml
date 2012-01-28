import QtQuick 1.0
import com.nokia.meego 1.0

Page {
    id: archiveDetailsPage
    tools: commonTools

    Rectangle {
        height: 300
        width: 200
        anchors.fill: parent
        Text {
            id: langdateLabel
            text: "Lang. + Date: "
        }
        Text {
            id: langdateText
            text: ""
            horizontalAlignment: Text.AlignRight
        }
        Text {
            id: sizeLabel
            text: "Size: "
            verticalAlignment: Text.AlignVCenter
        }
        Text {
            id: sizeText
            text: ""
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
        }
        Text {
            id: stateLabel
            text: "State: "
            verticalAlignment: Text.AlignBottom
        }
        Text {
            id: stateText
            text: ""
            verticalAlignment: Text.AlignBottom
            horizontalAlignment: Text.AlignRight
        }
    }
}
