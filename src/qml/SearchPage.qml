import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0

Page {
    id: searchPage
    tools: commonTools

    property string selectedTitle: ""

    Column {
        anchors.fill: parent
        TitleBar{
            id: titleBar;
            width: parent.width
            color: "#1C1C1C";
            title: "Evopedia"
        }

        Row {
            id: searchBar
            width: parent.width
            anchors.topMargin: 10
            anchors.bottomMargin: 10
            height: searchField.height + 8
            spacing: 8

            TextField {
                id: searchField
                text: evopedia.searchPrefix
                placeholderText: qsTr("Search term...")
                width: parent.width - btnSearch.width - parent.spacing
                anchors.verticalCenter: parent.verticalCenter

                Keys.onReturnPressed: {
                    titlesView.focus = true
                }

                onTextChanged: {
                    evopedia.searchPrefix = searchField.text
                }

                platformSipAttributes: SipAttributes{
                    actionKeyIcon: "qrc:/meego/search_sip_attribute.png"
                    actionKeyLabel: qsTr("Search")
                    actionKeyHighlighted: true
                }
            }

            Button {
                id: btnSearch;
                width: 110
                anchors.verticalCenter: parent.verticalCenter

                iconSource: theme.inverted ?
                                (pressed ? "image://theme/icon-m-toolbar-search-white-selected"
                                         : "image://theme/icon-m-toolbar-search-white")
                              : (pressed ? "image://theme/icon-m-toolbar-search-selected"
                                         : "image://theme/icon-m-toolbar-search")
            }
        }

        ListView {
            id: titlesView
            width: parent.width
            height: parent.height - titleBar.height - searchBar.height
            spacing: 1

            // We don't want the list to be visible under the search button/field when dragged.
            clip: true

            cacheBuffer: 400;

            model: titlesModel

            delegate:
                Rectangle {
                    id: delegateRectangle
                    property int titleSize: 32
                    property color titleColor: theme.inverted ? "#ffffff" : "#282828"
                    property color titleColorPressed: theme.inverted ? "#797979" : "#797979"
                    property color titleBackground: theme.inverted ? "#000" : "#fff"
                    property color titleBackgroundPressed: theme.inverted ? "#555" : "#BBB"

                    height: 64
                    width: parent.width
                    color: (mouseArea.pressed ? titleBackgroundPressed : titleBackground)

                    Label {
                        id: titleText
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width
                        text: name
                        font.pixelSize: delegateRectangle.titleSize
                        color: mouseArea.pressed ? delegateRectangle.titleColorPressed : delegateRectangle.titleColor
                        wrapMode: Text.NoWrap
                    }
                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        onClicked: {
                            selectedTitle = name

                            var url = evopedia.getArticleURL(selectedTitle)

                            if (evopediaSettings.useExternalBrowser){
                                Qt.openUrlExternally(url)
                            } else {
                                articleView.url = url
                                pageStack.push(articleView);
                            }
                        }
                    }
                }

            ScrollDecorator {
                flickableItem: titlesView
            }

            Text {
                text: qsTr("No results")
                anchors.centerIn: parent
                visible: titlesView.count == 0
                font.pixelSize: 35
                color: theme.inverted ? "white" : "black"
            }
        }
    }

    ArticleView {
        id: articleView
    }
}
