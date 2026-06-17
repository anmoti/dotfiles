import Quickshell
import Quickshell.Wayland
import QtQuick

ShellRoot {
    Variants {
        model: Quickshell.screens

        delegate: Component {
            PanelWindow { // qmllint disable uncreatable-type
                required property var modelData
                screen: modelData

                WlrLayershell.layer: WlrLayer.Background
                WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

                exclusionMode: ExclusionMode.Ignore

                anchors {
                    top: true
                    bottom: true
                    left: true
                    right: true
                }

                color: "transparent"

                Item {
                    id: crossfade
                    anchors.fill: parent

                    property string dir: `file://${Quickshell.env("HOME")}/.nix-profile/share/wallpapers/`
                    property bool showB: false

                    Image {
                        id: imgA
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectCrop
                        Behavior on opacity {
                            NumberAnimation {
                                duration: 1500
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }

                    Image {
                        id: imgB
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectCrop
                        opacity: 0
                        Behavior on opacity {
                            NumberAnimation {
                                duration: 1500
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }

                    Component.onCompleted: {
                        imgA.source = crossfade.dir + Wallpaper.files[Wallpaper.index];
                    }

                    Connections {
                        target: Wallpaper
                        function onIndexChanged() {
                            const src = crossfade.dir + Wallpaper.files[Wallpaper.index];
                            if (!crossfade.showB) {
                                imgB.source = src;
                                imgB.opacity = 1;
                                imgA.opacity = 0;
                            } else {
                                imgA.source = src;
                                imgA.opacity = 1;
                                imgB.opacity = 0;
                            }
                            crossfade.showB = !crossfade.showB;
                        }
                    }
                }
            }
        }
    }
}
