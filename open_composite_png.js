const sharp = require("sharp");
async function compositeImages() {
  try {
    await sharp(process.argv[2] + ".png")
      .composite([ { input: './calendars/' + process.argv[3], gravity: 'north' }, ])
      .toFile(process.argv[2] + ".composited.png");
  } catch (error) {
    console.log(error);
  }
}

compositeImages();
