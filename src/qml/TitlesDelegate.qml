import QtQuick 1.1
import com.nokia.meego 1.0

Item {
  id: titlesDelegate
  height: titlesDelegate.ListView.view.height
  width: titlesDelegate.ListView.view.width

  Text {
    anchors.fill: parent;
    text: name //+" ("+size+")"
  }
}
