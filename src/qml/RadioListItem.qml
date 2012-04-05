import QtQuick 1.1
import com.nokia.meego 1.0
import Qt.labs.gestures 1.0

Rectangle {
    id: rectangle
    height: item.height + 16
    width: parent.width
    color: (theme.inverted
              ? (pressed ? "#555" : "black")
              : (pressed ? "#BBB" : "white" ))
    signal clicked
    signal pressAndHold
    property bool pressed: false
    property alias checked: checkbox.checked
    property alias text: item.text
    Row {
        anchors.fill: parent
        CheckBox {
            id: checkbox
            anchors.verticalCenter: parent.verticalCenter

            property string __invertedString: theme.inverted? "-inverted" : ""
            property string background: "image://theme/meegotouch-button-checkbox"+__invertedString+"-background"
            property string backgroundSelected: "image://theme/meegotouch-button-radiobutton"+__invertedString+"-background-selected"
            property string backgroundPressed: "image://theme/meegotouch-button-radiobutton"+__invertedString+"-background-pressed"
            property string backgroundDisabled: "image://theme/meegotouch-button-radiobutton"+__invertedString+"-background-disabled"

            __imageSource: !enabled ? backgroundDisabled :
                           pressed ? backgroundPressed :
                           checked ? backgroundSelected :
                           background

        }
        Text {
            id: item
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - checkbox.width
            font.pointSize: 32
            text: name
            color: (theme.inverted ? "white" : "black")
        }
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onPressedChanged: {
            if (!pressed)
                rectangle.pressed = false
        }
        onPressed:
            rectangle.pressed = true
        onReleased:
            rectangle.pressed = false
        onClicked:
            rectangle.clicked();
        onPressAndHold: {
            rectangle.pressed = false
            rectangle.pressAndHold()
        }
    }
}
