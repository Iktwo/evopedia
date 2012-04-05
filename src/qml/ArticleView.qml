import QtQuick 1.1
import com.nokia.meego 1.0
import QtWebKit 1.0

Page {

    property alias url: webView.url

    tools: articleTools

    ExtendedWebView {
        id: webView
        anchors.fill: parent
    }

    ToolBarLayout {
        id: articleTools
        ToolIcon {
            platformIconId: "toolbar-back";
            anchors.left: (parent === undefined) ? undefined : parent.left
            onClicked: {
                if (webView.back.enabled)
                    webView.back.trigger()
                else {
                    pageStack.pop()
                    pageStack.currentPage.focusSearchField()
                }
            }
        }
    }
}
