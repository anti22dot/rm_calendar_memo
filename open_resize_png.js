const sharp = require("sharp");
async function resizeImage() {
  try {
    await sharp(process.argv[2])
      .resize({
        width: 1620,
        height: 2156,
      })
      .toFile(process.argv[2] + ".new");
  } catch (error) {
    console.log(error);
  }
}
resizeImage();