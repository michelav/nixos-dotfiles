//@ pragma UseQApplication

import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Io
import "services"
import "osd"
import "state"

ShellRoot {
    id: root

    IpcHandler {
        target: "shell"
        function toggle(panel: string): void { ShellState.togglePanel(panel, null); }
        function close(): void { ShellState.closePanels(); }
    }

    IpcHandler {
        target: "osd"
        function volumeUp(): void { AudioService.stepVolume(0.05); }
        function volumeDown(): void { AudioService.stepVolume(-0.05); }
        function toggleMute(): void { AudioService.toggleMute(); }
        function toggleMicMute(): void { AudioService.toggleMicMute(); }
        function brightnessUp(): void { BrightnessService.step(5); }
        function brightnessDown(): void { BrightnessService.step(-5); }
    }

    Variants {
        model: Quickshell.screens

        Bar {
            required property var modelData
            screen: modelData
        }
    }

    Variants {
        model: Quickshell.screens
        Osd {
            required property var modelData
            modelScreen: modelData
        }
    }
}
