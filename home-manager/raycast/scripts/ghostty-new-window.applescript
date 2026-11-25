#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Ghostty New Window
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 👻
# @raycast.description Open Ghostty new window.

# Documentation:
# @raycast.author chikuwasaurus
# @raycast.authorURL https://raycast.com/chikuwasaurus

if application "Ghostty" is running then
    tell application "Ghostty"
        set win to new window
        activate window win
    end tell
else
    tell application "Ghostty" to activate
end if
