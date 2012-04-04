/****************************************************************************
**
** Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the QtDeclarative module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** No Commercial Usage
** This file contains pre-release code and may not be distributed.
** You may use this file in accordance with the terms and conditions
** contained in the Technology Preview License Agreement accompanying
** this package.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Nokia gives you certain additional
** rights.  These rights are described in the Nokia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** If you have questions regarding the use of this file, please contact
** Nokia at qt-info@nokia.com.
**
**
**
**
**
**
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 1.1
import com.nokia.meego 1.0
import QtWebKit 1.0

Flickable {
    property alias title: webView.title
    property alias icon: webView.icon
    property alias progress: webView.progress
    property alias url: webView.url
    property alias back: webView.back
    property alias stop: webView.stop
    property alias reload: webView.reload
    property alias forward: webView.forward
    property bool interactiveSuspended: false
    
    id: flickable
    width: parent.width
    contentWidth: Math.max(parent.width,webView.width)
    contentHeight: Math.max(parent.height,webView.height)
    pressDelay: 200

    PinchArea {
        width:webView.width
        height: webView.height
        property real startScale
        onPinchStarted: {
            startScale = webView.contentsScale
            webView.renderingEnabled = false
            flickable.smooth = false
        }
        onPinchUpdated: {
                flickable.contentY += pinch.previousCenter.y - pinch.center.y + flickable.contentY*(pinch.scale - pinch.previousScale)
                flickable.contentX += pinch.previousCenter.x - pinch.center.x + flickable.contentX*(pinch.scale - pinch.previousScale)
                webView.contentsScale = startScale * pinch.scale
                
                return
                flickable.contentX = Math.max(0,Math.min(pinch.center.x-flickable.width/2,webView.width*webView.contentsScale-flickable.width))
                flickable.contentY = Math.max(0,Math.min(pinch.center.y-flickable.height/2,webView.height-flickable.height))
            }
        onPinchFinished: {
            if (webView.contentsScale < 1.0)
                webView.contentsScale = 1.0

            // After zooming, only show blank space if the page doesn't occupy the whole screen.
            // Otherwise, move the page in order to cover all the screen.

            if (flickable.contentX < 0.0)
                flickable.contentX = 0.0
            if (flickable.contentY < 0.0)
                flickable.contentY = 0.0

            if (flickable.contentX > flickable.contentWidth - flickable.width)
                flickable.contentX = flickable.contentWidth - flickable.width;
            if (flickable.contentY > flickable.contentHeight - flickable.height)
                flickable.contentY = flickable.contentHeight - flickable.height;

            webView.renderingEnabled = true
            flickable.smooth = true
        }
        WebView {
            id: webView
            objectName: "webViewImplementation"
            transformOrigin: Item.TopLeft
            //settings.pluginsEnabled: true

            smooth: false // We don't want smooth scaling, since we only scale during (fast) transitions
            focus: true

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

            // When not zoomed, prevent left/right scrolling
            width: contentsScale == 1 ? flickable.width : undefined

            contentsScale: 1
            onContentsSizeChanged: {
                // zoom out
                contentsScale = 1
            }
            onUrlChanged: {
                // got to topleft
                flickable.contentX = 0
                flickable.contentY = 0

                // zoom out
                contentsScale = 1
            }
            onDoubleClick: {
                var zoom = 2.0
                if (contentsScale >= 2.0)
                    zoom = 1/2.0

                doZoom(zoom, clickX*zoom, clickY*zoom)
            }

            SequentialAnimation {
                id: quickZoom

                PropertyAction {
                    target: webView
                    property: "renderingEnabled"
                    value: false
                }
                PropertyAction {
                    target: flickable
                    property: "smooth"
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
                PropertyAction {
                    target: flickable
                    property: "smooth"
                    value: true
                }
            }
            onZoomTo: doZoom(zoom,centerX,centerY)

            onLoadFinished: {
                webView.evaluateJavaScript("document.body.style.marginLeft=\"10px\"")
                webView.evaluateJavaScript("document.body.style.marginRight=\"5px\"")
            }
        }
    }

    Component.onCompleted: {
        back.enabled = false
        forward.enabled = false
        reload.enabled = false
        stop.enabled = false
    }
}
