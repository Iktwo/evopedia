import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import "qml_constants.js" as UI

Page {
    id: searchPage
    tools: commonTools

    property bool landscape: screen.rotation == 0

    property string selectedTitle: ""

    function acquireFocus() {
        searchField.focus = true
        searchField.selectAll()
    }

    Column {
        anchors.fill: parent

        Rectangle {
            id: searchBar
            width: parent.width
            anchors.topMargin: 10
            anchors.bottomMargin: 10

            property int spacing: 8
            property int rowHeight: searchField.implicitHeight + 8
            height: searchPage.landscape ? rowHeight : 2*rowHeight
            color: (theme.inverted ? "black" : "light gray")

            Rectangle {
                property int preferredTumblerWidth: 50

                id: tumblerRow
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: parent.spacing
                anchors.rightMargin: parent.spacing
                width: searchPage.landscape ? preferredTumblerWidth + 2*parent.spacing: parent.width
                height: parent.rowHeight
                color: parent.color

                SelectionDialog {
                    id: archiveDialog
                    titleText: qsTr("Archive")

                    selectedIndex: evopediaSettings.languageIndex

                    model: ListModel { }

                    onAccepted: {
                        evopediaSettings.languageIndex = selectedIndex
                        searchField.focus = true
                    }
                }

                CustomTumblerButton {
                    id: tumblerButton
                    width: parent.width - 2*parent.parent.spacing
                    anchors.verticalCenter: parent.verticalCenter

                    text: evopediaSettings.languageList[evopediaSettings.languageIndex]
                    onClicked: archiveDialog.open()
                }

                Text {
                    id: helper
                    width: 0
                    height: 0
                    visible: false
                    font.family: UI.FONT_FAMILY
                    font.pixelSize: UI.FONT_DEFAULT_SIZE;
                }

                Component.onCompleted: {
                    archiveDialog.model.clear()
                    var i = 0;
                    var s = "";
                    var maxWidth = 0
                    for (i = 0; i < languageListModel.size; i++) {
                        s = languageListModel.get(i);
                        archiveDialog.model.append({name: s});
                        helper.text = s;
                        maxWidth = Math.max(maxWidth, helper.paintedWidth)
                    }
                    preferredTumblerWidth = maxWidth + tumblerButton.iconWidth + 4*UI.INDENT_DEFAULT
                }
            }

            Row {
                anchors.leftMargin: landscape ? 0 : parent.spacing
                anchors.rightMargin: parent.spacing
                anchors.left: landscape ? tumblerRow.right : parent.left
                anchors.top: landscape ? parent.top : tumblerRow.bottom
                width: landscape ? parent.width - tumblerButton.width : parent.width
                height: parent.rowHeight

                spacing: parent.spacing

                TextField {
                    id: searchField
                    text: evopedia.searchPrefix
                    placeholderText: qsTr("Search term...")
                    width: parent.width - btnClear.width - btnSettings.width - parent.spacing * (landscape ? 6 : 4)
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
        }

        Rectangle {
            id: border
            color: (theme.inverted ? "white" : "black")
            width: parent.width
            height: 1
        }

        Rectangle {

            Rectangle {
                id: shadow
                width: parent.width
                height: 7
                anchors.top: parent.top
                z: 10

                gradient: Gradient {
                    GradientStop {color: "#99000000"; position: 0.0}
                    GradientStop {color: "#00000000"; position: 1.0}
                }
            }

            width: parent.width
            height: parent.height - border.height - searchBar.height
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
        }
    }


    Timer {
        interval: 50
        running: true
        repeat: false
        onTriggered: acquireFocus()
    }
}
