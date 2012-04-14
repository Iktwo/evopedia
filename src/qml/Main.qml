import QtQuick 1.1
import com.nokia.meego 1.0

PageStackWindow {
    initialPage: searchPage

    // Show status bar in portrait mode only.
    showStatusBar: screen.rotation != 0

    SearchPage {
        id: searchPage
        Component.onCompleted: {
            theme.inverted = evopediaSettings.darkTheme;
        }
    }
}
