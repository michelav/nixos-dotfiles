import Quickshell
import Quickshell.Services.Pipewire

ShellRoot {
    id: root

    // Pipewire only populates full node properties (audio.volume/muted) for
    // nodes that are explicitly tracked. Bind the default sink/source once,
    // globally, so every widget/panel can safely read Pipewire.defaultAudioSink.
    PwObjectTracker {
        objects: [
            Pipewire.defaultAudioSink,
            Pipewire.defaultAudioSource,
        ]
    }

    Bar {
        id: bar
    }
}
