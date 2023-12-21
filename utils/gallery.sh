#!/bin/bash

# Choose a title for the gallery
TITLE=$(zenity --entry --title="Gallery Title" --text="Enter the title for the gallery:")

# Choose a directory for thumbnails
THUMBS_DIR_FULL=$(zenity --file-selection --directory --title="Select Thumbs Directory")
THUMBS_DIR=$(basename "$THUMBS_DIR_FULL")

# Choose a directory for images
IMAGES_DIR_FULL=$(zenity --file-selection --directory --title="Select Images Directory")
IMAGES_DIR=$(basename "$IMAGES_DIR_FULL")

OUTPUT_HTML="README.md"
CSS_FILE="$IMAGES_DIR_FULL/style.css"

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
    for THUMB in "$THUMBS_DIR_FULL"/*; do
        [ -f "$THUMB" ] || continue

        FILENAME=$(basename "$THUMB")
        IMAGE_NAME="${FILENAME%.*}"
        IMAGE_PATH=$(find "$IMAGES_DIR_FULL" -type f -iname "$IMAGE_NAME.*" -print -quit)
        RELATIVE_IMAGE_PATH="${FILENAME}"
        RELATIVE_THUMB_PATH="thumbs/${FILENAME}"

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

clipboard() {
    local output_html="$1"
    wl-copy --type text/html < "$output_html"
}

write_gallery
clipboard "$OUTPUT_HTML"
