#!/bin/bash
# This script depends on: bash zenity wl-clipboard

# Ask for the episode number
PIC_NUMBER=$(zenity --entry --title="TG Message" --text="Episode number:")
FILE="tg_message.txt"

# Function to write content to the file
write_to_file() {
  echo "$1" >> "$FILE"
}

# Write message body
body() {
  write_to_file " *PIC$PIC_NUMBER*"
  write_to_file "___"
  write_to_file ""
  write_to_file "[Episodes gallery](https://github.com/valeriogalano/pensieriincodice-assets/tree/main/covers/$PIC_NUMBER/#GALLERY)"
  write_to_file ""
}

# Copy content to clipboard
clipboard() {
  wl-copy --type text/plain < "$FILE"
  rm "$FILE"
}

# Execute functions
body
clipboard
