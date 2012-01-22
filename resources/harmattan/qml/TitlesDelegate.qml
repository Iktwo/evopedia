import QtQuick 1.0

Item {
  id: delegate
  height: delegate.ListView.view.height
  width: delegate.ListView.view.width

  Text {
    anchors.fill: parent;
    text: name //+" ("+size+")"
  }
}
