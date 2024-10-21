#!/bin/bash
export PATH=$PATH:${NODE_ROOT}/bin
# Utility | Write the passed string into the log file
logline () {
 [[ "$RM_CALENDAR_APP_DEBUG" != true ]] && true || echo "$1" &>> /home/root/rm_calendar_memo/rm_calendar_memo.log
}

while true; do

  # Day of the month
  DOM=$(date +%d)
  TODAYS_TODO_OLD_ABSOLUTE_FILENAME=/home/root/.local/share/remarkable/xochitl/${ORIGINAL_DOC_HASH_ID}.thumbnails/${DOM}.png
  TODAYS_TODO_TMP_ABSOLUTE_FILENAME=${CALENDAR_MEMO_ROOT}/${DOM}.png.new

  sleep 5
  logline ""; logline "========";
  logline "Right now is $(date). Searching for the ${DOM}.png file"
  if [ -f ${TODAYS_TODO_OLD_ABSOLUTE_FILENAME} ] ; then
    cd ${CALENDAR_MEMO_ROOT};
    logline "* The file ${TODAYS_TODO_OLD_ABSOLUTE_FILENAME} exist."
    logline "* Creating the temporary copy of this file in the /home/root/rm_calendar_memo/ location: "
    logline "cp ${TODAYS_TODO_OLD_ABSOLUTE_FILENAME} ${CALENDAR_MEMO_ROOT}/;"
    cp ${TODAYS_TODO_OLD_ABSOLUTE_FILENAME} ${CALENDAR_MEMO_ROOT}/;
    logline "* Here is the metadata of that newly copied file: "
    [[ "$RM_CALENDAR_APP_DEBUG" != true ]] && node get_metadata.js ${DOM}.png &>> /dev/null || node get_metadata.js ${DOM}.png
    logline "* Resizing this temporary copy: "
    logline "node png_open_resize.js ${DOM}.png"
    [[ "$RM_CALENDAR_APP_DEBUG" != true ]] && node open_resize_png.js ${DOM}.png &>> /dev/null || node open_resize_png.js ${DOM}.png
    logline "* As the result the new resized file created. The new resized absolute filename: ${TODAYS_TODO_TMP_ABSOLUTE_FILENAME}, and it's metadata: "
    [[ "$RM_CALENDAR_APP_DEBUG" != true ]] && node get_metadata.js ${DOM}.png.new &>> /dev/null || node get_metadata.js ${DOM}.png.new
    logline "* Copying the new resized file into the target location, while replacing the current 'suspended.png' file: "
    logline "cp ${TODAYS_TODO_TMP_ABSOLUTE_FILENAME} ${TODAYS_TODO_NEW_ABSOLUTE_FILENAME}"
    cp ${TODAYS_TODO_TMP_ABSOLUTE_FILENAME} ${TODAYS_TODO_NEW_ABSOLUTE_FILENAME}
    logline "* Deleting the temporary copy of the original file, as well as resized file"
    logline "rm -f ${TODAYS_TODO_TMP_ABSOLUTE_FILENAME} ${CALENDAR_MEMO_ROOT}/${DOM}.png"
    rm -f ${TODAYS_TODO_TMP_ABSOLUTE_FILENAME} ${CALENDAR_MEMO_ROOT}/${DOM}.png
    logline "========"

  else logline "* The file ${TODAYS_TODO_OLD_ABSOLUTE_FILENAME} does NOT exist."
  fi

done