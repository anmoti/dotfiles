import Quickshell
import Quickshell.Wayland
import QtQuick

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

      Image {
        anchors.fill: parent
        source: `file://${Quickshell.env("HOME")}/.nix-profile/share/wallpapers/01.jpeg`
        fillMode: Image.PreserveAspectCrop
      }
    }
  }
}
