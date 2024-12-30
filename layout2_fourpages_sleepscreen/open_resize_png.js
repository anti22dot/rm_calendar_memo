const sharp = require("sharp");
async function resizeImage() {
  try {
    await sharp(process.argv[2])
      // .resize(1620, 2156)
      // .resize(800, 733)
      .resize(767, 703)
      .toFile(process.env["TODAYS_TODO_RES_FILE" + process.argv[3]]);
  } catch (error) {
    console.log(error);
  }
}
resizeImage();
