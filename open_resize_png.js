const sharp = require("sharp");
async function resizeImage() {
  try {
    await sharp(process.argv[2] + ".png")
      .resize(1620, 2156)
      .toFile(process.argv[2] + ".new.png");
  } catch (error) {
    console.log(error);
  }
}
resizeImage();
