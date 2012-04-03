import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0

Page {
    id: searchPage
    tools: commonTools

    signal signalLanguageChanged(string lang);
    signal signalSearchTextChanged(string text);
    property string selectedTitle: ""

    TitleBar{
        id: titleBar;
        anchors.top: parent.top
        color: "#1C1C1C";
        title: "Evopedia"
        z:1
    }

    TextField {
        id: searchField
        placeholderText: "Search term..."
        anchors.top: titleBar.bottom
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.right: btnSearch.left
        //width: parent.width
        z:1
        onTextChanged: {
            searchPage.signalSearchTextChanged(searchField.text)
            evopedia.on_searchField_textChanged(searchField.text)
        }

        platformSipAttributes: SipAttributes{
            actionKeyIcon: "qrc:/meego/search_sip_attribute.png"
            actionKeyLabel: "Search"
            actionKeyHighlighted: true
        }
    }

    Button {
        id: btnSearch;
        anchors.top: titleBar.bottom
        anchors.topMargin: 10
        width: 110
        //height: txtFldSearch.height
        anchors.right: parent.right
        Image{
            x: parent.width/2-width/2
            y: parent.height/2 - height/2
            source: "qrc:/meego/search_sip_attribute.png"
            //FIXME: set an icon that work it both light and dark them
        }
        /*onClicked: {
            if (txtFldSearch.text.length>0){
                QMLAccess.clearResultList();
                QMLAccess.searchSongs(txtFldSearch.text);
            }
        }*/
    }

    /*Button {
        id: languageButton
        text: "Language"
        anchors.left: searchField.right
        anchors.right: parent.right
        anchors.top: parent.top
        onClicked: langDialog.open()
    }*/

    ListView {
        id: titlesView
        anchors {
            top: searchField.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        cacheBuffer: 400;

        model: titlesModel

        delegate:
            Rectangle {
                id: delegateRectangle
                property int titleSize: 32
                property color titleColor: theme.inverted ? "#ffffff" : "#282828"
                property color titleColorPressed: theme.inverted ? "#797979" : "#797979"

                height: 64
                width: parent.width
                color: (mouseArea.pressed ? "#BBB" : "white")

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

                        if (evopediaSettings.useExternalBrowser){
                            evopedia.on_title_selected(selectedTitle)
                        } else{
                            articleView.fixUrl(evopedia.getArticleURL(selectedTitle));
                            pageStack.push(articleView);
                        }
                    }
                }
            }

    }

    ScrollDecorator {
        flickableItem: titlesView
    }

    ArticleView{
        id: articleView
    }

}
