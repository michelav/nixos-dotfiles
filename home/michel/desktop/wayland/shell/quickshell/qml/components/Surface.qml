import QtQuick
import ".."

Rectangle {
    Theme { id: theme }
    color: theme.surfaceContainer
    radius: theme.radiusMd
    border.width: 1
    border.color: theme.outline
}
