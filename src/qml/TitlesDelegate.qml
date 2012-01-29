import QtQuick 1.1
import com.nokia.meego 1.0

Item {
  id: titlesDelegate
  height: 88
  width: parent.width

//  Row {
//      anchors.fill: parent


  Text {
    anchors.fill: parent
    text: name //+" ("+size+")"
  }
}
