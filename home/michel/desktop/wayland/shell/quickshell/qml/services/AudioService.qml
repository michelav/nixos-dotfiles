pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var source: Pipewire.defaultAudioSource
    readonly property bool sinkReady: sink !== null && sink.ready && sink.audio !== null
    readonly property bool sourceReady: source !== null && source.ready && source.audio !== null
    readonly property int volumePercent: sinkReady ? Math.round(sink.audio.volume * 100) : 0
    readonly property int microphonePercent: sourceReady ? Math.round(source.audio.volume * 100) : 0
    property int eventSerial: 0

    PwObjectTracker { objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource] }
    function setVolume(value) {
        if (!sinkReady) return;
        sink.audio.muted = false;
        sink.audio.volume = Math.max(0, Math.min(1.5, value));
        eventSerial++;
    }
    function stepVolume(delta) { setVolume((sinkReady ? sink.audio.volume : 0) + delta); }
    function toggleMute() { if (sinkReady) { sink.audio.muted = !sink.audio.muted; eventSerial++; } }
    function toggleMicMute() { if (sourceReady) { source.audio.muted = !source.audio.muted; eventSerial++; } }
}
