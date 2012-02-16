import QtQuick 1.0
import com.nokia.meego 1.0

QueryDialog {
    id: aboutDialog

    titleText: "Evopedia" + " 0.1.0"
    icon: "qrc:/meego/harmattan/evopedia80.png"
    message: qsTr("Offline Wikipedia Viewer, developer by Christian Reitwießner ported to Harmattan by Peter Rhone and Iktwo, you can find the source code in <br> https://github.com/Iktwo/evopedia")
}
