import QtQuick 1.1
import com.nokia.meego 1.0

Column {

        property alias title: mainPageTitleText.text;
        property alias author: mainPageAuthorText.text;

        property alias color: mainPageTitle.color;
        property alias titleLink: titleLink.text;
        property alias authorLink: authorLink.text;

        id: mainPageColumn
        width: parent.width
        height: 72

        Rectangle {
            id: mainPageTitle
            width: parent.width
            height: 72

            Label {
                id: mainPageTitleText
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 35
                color:  "white"
                MouseArea {
                    id: mouse_area_title
                    anchors.fill: parent
                    onClicked: Qt.openUrlExternally(titleLink.text);
                }
            }

            Label {
                id: mainPageAuthorText
                x: mainPageTitle.width-10-mainPageAuthorText.width
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 30
                color:  "white"
                MouseArea {
                    id: mouse_area_author
                    anchors.fill: parent
                    onClicked: Qt.openUrlExternally(authorLink.text);
                }
            }

            Text {
                id: authorLink
                opacity: 0
            }

            Text {
                id: titleLink
                opacity: 0
            }
        }
    }
