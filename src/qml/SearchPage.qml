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
        model: visualTitlesModel
        cacheBuffer: 400;

        VisualDataModel {
            id: visualTitlesModel
            model: titlesModel

            delegate:
                ListDelegate{

                Label {
                    id: titleText
                    text: name
                    anchors.verticalCenter: parent.verticalCenter
                }

                onClicked: {
                    selectedTitle = name

                    if (evopediaSettings.useExternalBrowser){
                        evopedia.on_title_selected(selectedTitle)
                    }else{
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
