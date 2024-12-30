const sharp = require("sharp");
async function prepareImage() {
  try {
    await sharp(process.argv[2])
      .extract({ left: 17, top: 182, width: 357, height: 327})
      .toFile(process.env["TODAYS_TODO_PREP_FILE" + process.argv[3]]);
  } catch (error) {
    console.log(error);
  }
}
prepareImage();

