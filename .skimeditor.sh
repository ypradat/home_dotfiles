#!bin/bash

file="$1"
line="$2"

[ "${file:0:1}" == "/" ] || file="${PWD}/$file"

exec osascript << EOF
  set ESC to ASCII character 27
  tell application "Vim" to activate
  tell application "System Events"
  tell process "Vim"
  keystroke ESC & ":set hidden" & return 
  keystroke ":if bufexists(\'$file\')" & return 
  keystroke ":exe \":buffer \" . bufnr(\'$file\')"  & return 
  keystroke ":else " & CR 
  keystroke ":    edit ${file// /\ }" & return 
  keystroke ":endif" & return 
  keystroke ":$line" & return 
  keystroke "zO" 
  end tell
  end tell
EOF
