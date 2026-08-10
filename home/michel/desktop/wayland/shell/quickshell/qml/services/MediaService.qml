pragma Singleton

import Quickshell
import Quickshell.Services.Mpris

Singleton {
    readonly property var players: Mpris.players.values
    readonly property var player: {
        for (const candidate of players) if (candidate.isPlaying) return candidate;
        return players.length > 0 ? players[0] : null;
    }
}
