import QtQuick 2.0

Item {
    id: window
    width: 600
    height: 600

    Rectangle {
        id: wideScene
        width: 1800
        height: 200
        color: "black"
        layer.enabled: true

        Row {
            id: shit
            height: parent.height
            Image { id: photo; source: "http://static.ddmcdn.com/gif/recipes/mona-lisa-200x200-140502.jpg" }
            Image { source: "http://static.ddmcdn.com/gif/recipes/mona-lisa-200x200-140502.jpg" }
            Image { source: "http://static.ddmcdn.com/gif/recipes/mona-lisa-200x200-140502.jpg" }
            Image { source: "http://static.ddmcdn.com/gif/recipes/mona-lisa-200x200-140502.jpg" }
            Image { source: "http://static.ddmcdn.com/gif/recipes/mona-lisa-200x200-140502.jpg" }

            NumberAnimation {
                id: shitAnim
                target: shit
                property: "x"
                from: -1000
                to: wideScene.width
                duration: 5000
                running: true
                easing.type: Easing.InOutSine
                loops: Animation.Infinite
            }

            onWidthChanged: {
                console.log('Width changed to:' + width)
                shitAnim.from = -width;
            }
        }
    }

    // Magic
    ShaderEffectSource {
        id: wideSceneAsTexture
        sourceItem: wideScene
        width: wideScene.width
        height: wideScene.height
    }

    ShaderEffect {
        anchors.fill: parent
        property real rowCount: 5.0
        property variant source: wideSceneAsTexture
        fragmentShader: "
            varying highp vec2 qt_TexCoord0;
            uniform sampler2D source;
            uniform lowp float qt_Opacity;
            uniform lowp float rowCount;
            void main() {
                highp vec2 tc;
                float row = floor(qt_TexCoord0.t * rowCount);
                tc.s = qt_TexCoord0.s / rowCount + row / rowCount;
                tc.t = mod(qt_TexCoord0.t, 1.0 / rowCount) * rowCount;
                lowp vec4 tex = texture2D(source, tc);
                gl_FragColor = vec4(tex.rgb, 1.0);
            }
        "

    }
}
