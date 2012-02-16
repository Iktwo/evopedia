// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import QtWebKit 1.0

Page {
    id: titleViewerPage
    tools: webviewTools
    property string titleUrl

//    perhaps use a rich label instead of a WebView
    Flickable {
        WebView {
            id: webView
            url: titleUrl
            preferredWidth: parent.width //490
            preferredHeight: parent.height // 400
            scale: 0.5
            smooth: false
        }
    }
}
