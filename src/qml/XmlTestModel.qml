import QtQuick 1.1
import com.nokia.meego 1.0

XmlListModel
{
    id: xmlModel
//    source: "qrc:/testmodel.xml"
    source: "testmodel.xml"
    query: "/rss/language/item"

    XmlRole {name: "title"; query: "title/string()" }
    XmlRole {name: "url"; query: "url/string()" }
}
