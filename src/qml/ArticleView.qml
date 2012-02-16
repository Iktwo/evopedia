import QtQuick 1.0
import com.nokia.meego 1.0
import QtWebKit 1.0

Page {

    tools: articleTools

    function fixUrl(url){
        webView.url = url;
    }

    Flickable{
        id: flickable
        anchors.fill: parent
        contentWidth: Math.max(parent.width,webView.width)
        contentHeight: Math.max(parent.height,webView.height)
        pressDelay: 200

        onWidthChanged : {
            if (width > webView.width*webView.contentsScale && webView.contentsScale < 1.0)
                webView.contentsScale = width / webView.width * webView.contentsScale;
        }
        WebView{
            id: webView
            anchors.fill: parent
            //url: "http://google.com"
            smooth: false
            focus: true
            preferredWidth: flickable.width
            preferredHeight: flickable.height

            onContentsSizeChanged: {
                // zoom out
                contentsScale = Math.min(1,flickable.width / contentsSize.width)
            }

            onUrlChanged: {
                // got to topleft
                flickable.contentX = 0
                flickable.contentY = 0
                //if (url != null) { header.editUrl = url.toString(); }
            }

            function doZoom(zoom,centerX,centerY){
                if (centerX){
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
