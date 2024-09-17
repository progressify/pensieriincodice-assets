#!/bin/bash

NUMBER=$(zenity --entry --title="Episode Number" --text="Enter the episode number:")
WORKDIR=../covers/$NUMBER
FILE=tg_message.txt

rename_files() {
  selected_files=$(zenity --file-selection --multiple --separator=" " --title "Select Files to Rename" --filename="$WORKDIR")

  if [ -z "$selected_files" ]; then
    zenity --error --text "No files selected. Exiting."
    exit 1
  fi

  user_input=$(zenity --forms --title="Rename Files" --text="Enter rename options:" \
    --add-entry="Prefix" \
    --add-entry="Suffix" \
    --add-entry="Incremental Order (e.g., %03d)" \
    --add-entry="Counter Start Value (e.g., 1)")

  IFS='|' read -r prefix suffix incremental_format start_counter <<< "$user_input"

  counter=$start_counter
  for file in $selected_files; do
    file_extension="${file##*.}"

    new_filename="${prefix}$(printf "$incremental_format" $counter)${suffix}.$file_extension"

    if [ "$file" != "$new_filename" ]; then
      mv "$file" "$(dirname "$file")/$new_filename"
    fi

    ((counter++))
  done

  zenity --info --text "Files have been renamed successfully."
}

sel_file() {
  files=$(zenity --title "Select a one or more files:"  --file-selection --multiple --filename="$WORKDIR/")
  [[ "$files" ]] || exit 1
  echo $files | tr "|" "\n" | while read file
  do
    echo "$file" >> /tmp/files.txt
  done
}

scale() {
  sel_file

  scale_factor=$(zenity --entry --title "Enter the scale factor" --text "Enter the scale factor:")
  [ -z "$scale_factor" ] && exit 1
  SCALE_FOLDER="$WORKDIR/thumbs"

  mkdir -p "$SCALE_FOLDER"

  IFS=$'\n'
  for FILE in $(cat /tmp/files.txt); do
    FILENAME=$(basename "$FILE")
    FILE_EXTENSION="${FILENAME##*.}" # Extract file extension
    OUTPUT_FILE="$SCALE_FOLDER/${FILENAME%.*}.$FILE_EXTENSION"
    ffmpeg -i "$FILE" -vf "scale=iw/$scale_factor:ih/$scale_factor" -c:a copy "$OUTPUT_FILE"
    echo "Scaled $FILENAME and saved to $SCALE_FOLDER"
  done

  rm /tmp/files.txt
  echo "Temporary files removed!"
  export SCALE_FOLDER
}

# Choose a title for the gallery
TITLE=$(zenity --entry --title="Gallery Title" --text="Enter the title for the gallery:")

OUTPUT_HTML="$WORKDIR/README.md"
CSS_FILE="$WORKDIR/style.css"

write_gallery() {
    # Create CSS file if not exists
    [ ! -f "$CSS_FILE" ] && {
        cat <<CSS > "$CSS_FILE"
  .gallery { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 10px; }
  .thumbnail { width: 100%; height: auto; }
CSS
    }

    # Create HTML file
    cat <<HTML > "$OUTPUT_HTML"
## AUTHOR

- [Francesco Zubani](https://www.linkedin.com/in/francesco-zubani-5957081a6/)

## AKNOWLEDGEMENTS

Only FOSS software was used to generate the gallery.

This work was made possible by the following projects:

- [Stable Diffusion](https://github.com/CompVis/stable-diffusion) - [LICENSE](https://github.com/CompVis/stable-diffusion/blob/main/LICENSE)
- [ComfyUI](https://github.com/comfyanonymous/ComfyUI) - [LICENSE](https://github.com/comfyanonymous/ComfyUI/blob/master/LICENSE)
- [GIMP](https://www.gimp.org/)
- [Inkscape](https://inkscape.org/)

The cover's frame and logo were made by Daniele Galano.

[![License](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)

This work is licensed under the GPLv3 license.
See LICENSE file for more details.

## GALLERY

### $TITLE

<div class="gallery">
HTML

    # Generate gallery images
    for THUMB in "$SCALE_FOLDER"/*; do
        [ -f "$THUMB" ] || continue

        FILENAME=$(basename "$THUMB")
        THUMBS_DIR=./thumbs
        IMAGE_NAME="${FILENAME%.*}"
        IMAGE_PATH=$(find "$WORKDIR" -type f -iname "$IMAGE_NAME.*" -print -quit)
        RELATIVE_IMAGE_PATH="${FILENAME}"
        RELATIVE_THUMB_PATH="${THUMBS_DIR}/${FILENAME}"

        cat <<HTML >> "$OUTPUT_HTML"
  <a href="$RELATIVE_IMAGE_PATH"><img class="thumbnail" src="$RELATIVE_THUMB_PATH" alt="$IMAGE_NAME"></a>
HTML
    done

    # Close HTML tags
    cat <<HTML >> "$OUTPUT_HTML"
</div>
</body>
</html>
HTML

    zenity --info --title="Script Finished" --text="Gallery $TITLE generated successfully."
}

drafts_commit() {
    DRAFTS="../covers/$NUMBER"
    git pull
    echo ""
    git add "$DRAFTS" && git commit -m "Added PIC$NUMBER cover's drafts and thumbs"
    PROMPT_PUSH=$(zenity --question --title="Push changes?" --text="Push changes to remote?")
    [ $? -eq 0 ] && git push
}

# Function to write content to the file
write_to_file() {
  echo "$1" >> "$FILE"
}

# Write message body
body() {
  write_to_file "# $TITLE"
  write_to_file "__________"
  write_to_file ""
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
rename_files
scale
write_gallery
drafts_commit
