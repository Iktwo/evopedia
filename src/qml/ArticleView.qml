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
}
