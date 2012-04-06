import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: searchPage
    tools: commonTools

    property string selectedTitle: ""

    function acquireFocus() {
        searchField.focus = true
        searchField.selectAll()
    }

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
                width: parent.width - btnClear.width -btnSettings.width - parent.spacing * 2.5
                anchors.verticalCenter: parent.verticalCenter

                // Do not use predictive text (i.e. dictionary lookup) while typing.
                // This causes the onTextChanged signal to be emitted for each typed
                // character, instead of for each typed word.
                inputMethodHints: 32

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
                id: btnClear;
                width: 50
                anchors.verticalCenter: parent.verticalCenter

                iconSource: theme.inverted ?
                                (pressed ? "image://theme/icon-m-toolbar-backspace-white-selected"
                                         : "image://theme/icon-m-toolbar-backspace-white")
                              : (pressed ? "image://theme/icon-m-toolbar-backspace-selected"
                                         : "image://theme/icon-m-toolbar-backspace")
                onClicked: {
                    searchField.text = ""
                    searchField.focus = true
                }
            }
            Button {
                id: btnSettings;
                width: 50
                anchors.verticalCenter: parent.verticalCenter

                iconSource: theme.inverted ?
                                (pressed ? "image://theme/icon-m-toolbar-settings-white-selected"
                                         : "image://theme/icon-m-toolbar-settings-white")
                              : (pressed ? "image://theme/icon-m-toolbar-settings-selected"
                                         : "image://theme/icon-m-toolbar-settings")
                onClicked: {
                    pageStack.push(settingsPage);
                }
            }
        }

        Rectangle {
            width: parent.width
            height: parent.height - titleBar.height - searchBar.height
            color: (theme.inverted ? "black" : "light gray")

            ListView {
                anchors.fill: parent
                id: titlesView
                spacing: 1
                visible: searchField.text != ""

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
                                    pageStack.push(Qt.resolvedUrl("ArticleView.qml"), {url: url});
                                }
                            }
                        }
                    }

                ScrollDecorator {
                    flickableItem: titlesView
                }
            }

            Text {
                text: qsTr("No results")
                anchors.centerIn: parent
                visible: titlesView.visible && titlesView.count == 0
                font.pixelSize: 35
                color: theme.inverted ? "white" : "black"
            }

            ListView {
                anchors.fill: parent
                id: languageRadioList
                spacing: 1
                visible: searchField.text == ""

                // We don't want the list to be visible under the search button/field when dragged.
                clip: true

                cacheBuffer: 400;

                model: ListModel { }

                delegate:
                    RadioListItem {
                        text: name
                        checked: ListView.isCurrentItem
                        onClicked: {
                            evopediaSettings.languageIndex = index
                            languageRadioList.currentIndex = evopediaSettings.languageIndex
                            searchField.focus = true
                        }

                        onPressAndHold: {
                        }
                    }

                Component.onCompleted: {
                    model.clear()
                    var i = 0;
                    for (i = 0; i < languageListModel.size; i++)
                        model.append({name: languageListModel.get(i), index: i});
                    languageRadioList.currentIndex = evopediaSettings.languageIndex
                }
            }
        }
    }


    Timer {
        interval: 50
        running: true
        repeat: false
        onTriggered: acquireFocus()
    }
}
