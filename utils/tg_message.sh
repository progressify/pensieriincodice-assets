#!/bin/bash
# This script depends on: bash zenity wl-clipboard

# Ask for the episode number
PIC_NUMBER=$(zenity --entry --title="TG Message" --text="Episode number:")
FILE=tg_message.txt

# Function to write content to the file
write_to_file() {
  echo "$1" >> "$FILE"
}

# Write message body
body() {
  write_to_file "#sceglilacover #sondaggio"
  write_to_file ""
  write_to_file "Scegli tu le cover degli episodi di Pensieri in codice!"
  write_to_file ""
  write_to_file "L'episodio di oggi è https://pensieriincodice.it/$PIC_NUMBER"
  write_to_file ""
  write_to_file "Le cover candidate realizzate da @fatualux sono qui:"
  write_to_file "https://github.com/valeriogalano/pensieriincodice-assets/tree/main/covers/$PIC_NUMBER/#GALLERY"
  write_to_file ""
  write_to_file "Vota la tua preferita nel sondaggio che seguirà!"
  write_to_file ""
  write_to_file ""
}

# Write poll section
poll() {
  write_to_file "Fra le immagini elencate, quale preferisci per l'episodio $PIC_NUMBER?"
  write_to_file ""
}

# Copy content to clipboard
clipboard() {
  wl-copy --type text/plain < "$FILE"
  rm "$FILE"
}

# Execute functions
body
poll
clipboard
