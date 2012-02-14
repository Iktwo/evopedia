import QtQuick 1.0
import com.nokia.meego 1.0

QueryDialog {
    id: aboutDialog

    titleText: "Evopedia" + " 0.1.0"
    icon: "qrc:/meego/harmattan/evopedia80.png"
    message: qsTr("Offline Wikipedia Viewer, ported to Harmattan by Peter Rhone, UI work by Iktwo, you can find the code in <br> https://github.com/Iktwo/evopedia")
}
