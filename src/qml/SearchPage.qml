import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: searchPage
    tools: commonTools

    ListView {
        id: titlesView
        anchors.fill: parent

        model: titlesModel
        delegate: Text { text: title } //+ ": " + url }

//        model: XmlTestModel { }
//        delegate: Text { text: title + ": " + url }

//        delegate: TitlesDelegate { }

//        MouseArea {
//            id: mouseArea
//            anchors.fill: parent
//            onClicked: {
//            }
//        }
    }
    ScrollDecorator {
        flickableItem: titlesView
    }

}
