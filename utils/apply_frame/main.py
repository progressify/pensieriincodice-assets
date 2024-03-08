import click
import os
from PIL import Image, ImageOps
from tqdm import tqdm


def apply_frame(frame_path, image_path):
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


def is_image_3000x3000(image_path):
    image = Image.open(image_path)
    width, height = image.size
    return width == 3000 and height == 3000


@click.command()
@click.argument("frame", type=str)
@click.argument("folder", type=str)
@click.option("--compression", default=75, type=int, help="Livello di compressione (da 1 a 100)")
def main(frame, folder, compression):
    if not os.path.exists(frame):
        raise Exception(f"La cornice '{frame}' non esiste")

    if not is_image_3000x3000(frame):
        raise Exception("La cornice deve avere dimensioni 3000x3000")

    if not os.path.exists(folder):
        raise Exception(f"La cartella '{folder}' non esiste")

    images = os.listdir(folder)
    for image in tqdm(images):
        image_path = os.path.join(folder, image)
        if not is_image_3000x3000(image_path):
            print(f"L'immagine {image} non è di dimensioni 3000x3000\nskipping...")
            continue

        apply_frame(frame, image_path)
        compress_image(image_path, compression)


if __name__ == "__main__":
    main()
