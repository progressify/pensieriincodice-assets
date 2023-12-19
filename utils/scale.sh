#!/bin/bash
# This script depends on: bash zenity ffmpeg

sel_file() {
  files=$(zenity --title "Select a one or more files:"  --file-selection --multiple --filename=$(pwd)/)
  [[ "$files" ]] || exit 1
  echo $files | tr "|" "\n" | while read file
  do
    echo "$file" >> /tmp/files.txt
  done
}

scale() {
  sel_file

  scale_option=$(zenity --list --title "Scale Option" --text "Select a scale option:" \
    --column "SCALE OPTION:" "Increase" "Decrease" \
    --hide-header --width=275 --height=200 --ok-label="OK" --cancel-label="Cancel")

  case $scale_option in
    "Increase")
      scale_factor=$(zenity --entry --title "Enter the scale factor" --text "Enter the scale factor:")
      [ -z "$scale_factor" ] && exit 1
      SCALE_FOLDER="UPSCALED"
      ;;
    "Decrease")
      scale_factor=$(zenity --entry --title "Enter the scale factor" --text "Enter the scale factor:")
      [ -z "$scale_factor" ] && exit 1
      SCALE_FOLDER="thumbs"
      ;;
    *)
      exit 1
      ;;
  esac

  mkdir -p "$SCALE_FOLDER"

  IFS=$'\n'
  for FILE in $(cat /tmp/files.txt); do
    FILENAME=$(basename "$FILE")
    FILE_EXTENSION="${FILENAME##*.}" # Extract file extension
    OUTPUT_FILE="$SCALE_FOLDER/${FILENAME%.*}.$FILE_EXTENSION"

  if [ "$scale_option" = "Increase" ]; then
    ffmpeg -i "$FILE" -vf "scale=iw*$scale_factor:ih*$scale_factor" -c:a copy "$OUTPUT_FILE"
  elif [ "$scale_option" = "Decrease" ]; then
    ffmpeg -i "$FILE" -vf "scale=iw/$scale_factor:ih/$scale_factor" -c:a copy "$OUTPUT_FILE"
  fi

    echo "Scaled $FILENAME and saved to $SCALE_FOLDER"
  done

  rm /tmp/files.txt
  echo "Temporary files removed!"
}

scale
