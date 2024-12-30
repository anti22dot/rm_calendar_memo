const sharp = require("sharp");
async function compositeImages() {
  try {
    await sharp('blank.png')
      .composite([ 
        { input: './calendars/' + process.argv[2], gravity: 'north' }, 
        { input: process.argv[3], top: 715, left: 20 },
        { input: process.argv[4], top: 715, left: 827 },
        { input: process.argv[5], top: 1453, left: 20 },
        { input: process.argv[6], top: 1453, left: 827 },
        {input: './labels/label.week.png', top: 705, left: 325 },
        {input: './labels/label.morning.png', top: 705, left: 1098 },
        {input: './labels/label.afternoon.png', top: 1443, left: 260 },
        {input: './labels/label.evening.png', top: 1443, left: 1098 },
      ])
      .toFile(process.env.TODAYS_TODO_FINAL);
  } catch (error) {
    console.log(error);
  }
}

compositeImages();