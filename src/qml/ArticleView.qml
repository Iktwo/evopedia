import QtQuick 1.1
import com.nokia.meego 1.0
import QtWebKit 1.0

Page {

    tools: articleTools

    function fixUrl(url)
    {
        webView.url=url
    }

    Flickable {
        property alias title: webView.title
        property alias icon: webView.icon
        property alias progress: webView.progress
        property alias url: webView.url
        property alias back: webView.back
        property alias stop: webView.stop
        property alias reload: webView.reload
        property alias forward: webView.forward

        id: flickable
        anchors.fill: parent
        contentWidth: Math.max(parent.width,webView.width)
        contentHeight: Math.max(parent.height,webView.height)
        pressDelay: 200

        onWidthChanged : {
            if (width > webView.width*webView.contentsScale && webView.contentsScale < 1.0)
                webView.contentsScale = width / webView.width * webView.contentsScale;
        }

        PinchArea {
            anchors.fill: parent
            pinch.minimumScale: 1.0

            function calcZoomDelta(zoom, percent) {
                return zoom + Math.log(percent)/Math.log(2)
            }
            onPinchStarted: {
                webView.scale = webView.contentsScale
                webView.contentsScale = 1.0
            }
            onPinchUpdated: {
                if (pinch.scale > 1.0) {
                    webView.scale += 0.05
                }
                if (pinch.scale < 1.0 && webView.scale >= 1.0) {
                    webView.scale -= 0.05
                }
            }
            onPinchFinished: {
                webView.contentsScale = webView.scale
                webView.scale = 1.0
            }

            WebView {
                id: webView
                transformOrigin: Item.TopLeft

                //url: fixUrl(webBrowser.urlString)
                smooth: false // We don't want smooth scaling, since we only scale during (fast) transitions
                focus: true

                onAlert: console.log(message)

                function doZoom(zoom,centerX,centerY)
                {
                    if (centerX) {
                        var sc = zoom*contentsScale;
                        scaleAnim.to = sc;
                        flickVX.from = flickable.contentX
                        flickVX.to = Math.max(0,Math.min(centerX-flickable.width/2,webView.width*sc-flickable.width))
                        finalX.value = flickVX.to
                        flickVY.from = flickable.contentY
                        flickVY.to = Math.max(0,Math.min(centerY-flickable.height/2,webView.height*sc-flickable.height))
                        finalY.value = flickVY.to
                        quickZoom.start()
                    }
                }



                Keys.onLeftPressed: webView.contentsScale -= 0.1
                Keys.onRightPressed: webView.contentsScale += 0.1

                preferredWidth: flickable.width
                preferredHeight: flickable.height
                contentsScale: 1.0
                scale: 1.0
//                onContentsSizeChanged: {
                  //   zoom out
//                    contentsScale = Math.min(1,flickable.width / contentsSize.width)
//                }
                onUrlChanged: {
                    // got to topleft
                    flickable.contentX = 0
                    flickable.contentY = 0
                    //                if (url != null) { header.editUrl = url.toString(); }
                }
                onDoubleClick: {
                    if (!heuristicZoom(clickX,clickY,2.5)) {
                        var zf = flickable.width / contentsSize.width
                        if (zf >= contentsScale)
                            zf = 2.0*contentsScale // zoom in (else zooming out)
                        doZoom(zf,clickX*zf,clickY*zf)
                    }
                }

                SequentialAnimation {
                    id: quickZoom

                    PropertyAction {
                        target: webView
                        property: "renderingEnabled"
                        value: false
                    }
                    ParallelAnimation {
                        NumberAnimation {
                            id: scaleAnim
                            target: webView
                            property: "contentsScale"
                            // the to property is set before calling
                            easing.type: Easing.Linear
                            duration: 200
                        }
                        NumberAnimation {
                            id: flickVX
                            target: flickable
                            property: "contentX"
                            easing.type: Easing.Linear
                            duration: 200
                            from: 0 // set before calling
                            to: 0 // set before calling
                        }
                        NumberAnimation {
                            id: flickVY
                            target: flickable
                            property: "contentY"
                            easing.type: Easing.Linear
                            duration: 200
                            from: 0 // set before calling
                            to: 0 // set before calling
                        }
                    }
                    // Have to set the contentXY, since the above 2
                    // size changes may have started a correction if
                    // contentsScale < 1.0.
                    PropertyAction {
                        id: finalX
                        target: flickable
                        property: "contentX"
                        value: 0 // set before calling
                    }
                    PropertyAction {
                        id: finalY
                        target: flickable
                        property: "contentY"
                        value: 0 // set before calling
                    }
                    PropertyAction {
                        target: webView
                        property: "renderingEnabled"
                        value: true
                    }
                }
                onZoomTo: doZoom(zoom,centerX,centerY)
            }
        }
    }

}
