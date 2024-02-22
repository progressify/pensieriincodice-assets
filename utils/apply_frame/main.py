import click
import os
from PIL import Image, ImageOps


def apply_frame(image_path, frame_path):
    # applico la cornice
    frame = Image.open(frame_path)
    image = Image.open(image_path)
    image = ImageOps.fit(image, frame.size)
    image.paste(frame, (0, 0), frame.convert("RGBA"))
    image.save(image_path)


def compress_image(image_path, compression):
    # comprimo l'immagine
    image = Image.open(image_path)
    image = image.convert("RGB")
    image.save(image_path, quality=compression)


@click.command()
@click.argument("images", nargs=-1, type=str)
@click.option("--compression", default=75, type=int, help="Livello di compressione (da 1 a 100)")
def main(images, compression):
    frame_path = os.path.join("./media", "cornice.png")

    for image in images:
        image_path = os.path.join("./media", f"PIC_{image}.png")  # TODO

        apply_frame(image_path, frame_path)
        compress_image(image, compression)

        print(f"Immagine '{image}' compressa con successo!")


if __name__ == "__main__":
    main()
