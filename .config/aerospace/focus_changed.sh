#!/bin/bash
LOCK=/tmp/aerospace_focus.lock
if mkdir "$LOCK" 2>/dev/null; then
  trap "rm -rf $LOCK" EXIT
  sleep 0.15
  /opt/homebrew/bin/sketchybar --trigger front_app_switched
  /opt/homebrew/bin/sketchybar --trigger window_mode_changed MODE=$(aerospace list-windows --focused --format %{window-layout})
fi
