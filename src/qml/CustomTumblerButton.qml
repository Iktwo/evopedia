
import QtQuick 1.1
import com.nokia.extras 1.0
import "qml_constants.js" as UI

Item {
    id: tumblerbutton

    property string text: "Get Value"

    property alias pressed: mouse.pressed

    property alias iconWidth: icon.sourceSize.width

    property QtObject style: TumblerButtonStyle{}

    signal clicked

    height: UI.SIZE_BUTTON

    BorderImage {
        border { top: UI.CORNER_MARGINS; bottom: UI.CORNER_MARGINS;
            left: UI.CORNER_MARGINS; right: UI.CORNER_MARGINS }
        anchors.fill: parent
        source: mouse.pressed ?
                tumblerbutton.style.pressedBackground : tumblerbutton.enabled ?
                    tumblerbutton.style.background : tumblerbutton.style.disabledBackground;
    }

    MouseArea {
        id: mouse

        anchors.fill: parent
        enabled: parent.enabled
        onClicked: {
            parent.clicked()
        }
    }

    Image {
        id: icon

        anchors { right: (label.text != "") ? parent.right : undefined;
            rightMargin: UI.INDENT_DEFAULT;
            horizontalCenter: (label.text != "") ? undefined : parent.horizontalCenter;
            verticalCenter: parent.verticalCenter;
        }
        height: sourceSize.height
        width: sourceSize.width
        source: "image://theme/meegotouch-combobox-indicator" +
                (tumblerbutton.style.inverted ? "-inverted" : "") +
                (tumblerbutton.enabled ? "" : "-disabled") +
                (mouse.pressed ? "-pressed" : "")
    }

    Text {
        id: label

        anchors { left: parent.left; right: icon.left;
            leftMargin: UI.INDENT_DEFAULT; rightMargin: UI.INDENT_DEFAULT;
            verticalCenter: parent.verticalCenter }
        font { family: UI.FONT_FAMILY; pixelSize: UI.FONT_DEFAULT_SIZE;
            bold: UI.FONT_BOLD_BUTTON; capitalization: tumblerbutton.style.fontCapitalization }
        text: tumblerbutton.text
        color: (mouse.pressed) ? 
            tumblerbutton.style.pressedTextColor :
                (tumblerbutton.enabled) ?
                    tumblerbutton.style.textColor : tumblerbutton.style.disabledTextColor ;
        horizontalAlignment: Text.AlignLeft
        elide: Text.ElideRight
    }
}
