import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id: archiveDelegate

    height: archiveDelegate.ListView.view.height
    width: archiveDelegate.ListView.view.width

    Text {
        anchors.fill: parent;
        text: name +" ("+date+")"
    }
}
