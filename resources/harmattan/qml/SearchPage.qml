import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: searchPage
    tools: commonTools

//    Rectangle {
//        id: junk
//        anchors.fill: parent
//        color: "red"
//    }

    ListView {
        id: titleView
        anchors.fill: parent
        model: titlesModel
        delegate: TitlesDelegate{}
    }
}
