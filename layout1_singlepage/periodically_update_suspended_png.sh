#!/bin/bash
export PATH=$PATH:${NODE_ROOT}/bin

# Utility | Write the passed string into the log file
logline () {
 [[ "$RM_CALENDAR_APP_DEBUG" != true ]] && true || echo "$1" &>> /home/root/rm_calendar_memo/rm_calendar_memo.log
}

while true; do
  Y=$(date +%y)                                 # Current year.
  M=$(date +%m)                                 # Current month of the year.
  DOM=$(date +%d)                               # Current day of the month.
  TODAYS_FULL_DATE="FILE_${DOM}_${M}_${Y}"      # Full date, in the format: "FILE_day_month_year".
  TODAYS_TODO_ORIGINAL_ABSOLUTE_FILENAME="/home/root/.local/share/remarkable/xochitl/${ORIGINAL_DOC_HASH_ID}.thumbnails/${!TODAYS_FULL_DATE}.png"
  TODAYS_TODO_TMP_FILE_BASE=${DOM}.${M}.${Y}
  TODAYS_TODO_TMP_FILE=${TODAYS_TODO_TMP_FILE_BASE}.png
  TODAYS_TODO_RES_FILE_BASE=${TODAYS_TODO_TMP_FILE_BASE}.new
  TODAYS_TODO_RES_FILE=${TODAYS_TODO_TMP_FILE_BASE}.new.png
  TODAYS_TODO_RES_CMP_FILE=${TODAYS_TODO_TMP_FILE_BASE}.new.composited.png
  TODAYS_CAL_FILE=${TODAYS_TODO_TMP_FILE_BASE}_calendar.png

  sleep 0.5
  logline ""; logline "========";
  logline "Right now is $(date). Searching for the ${TODAYS_TODO_ORIGINAL_ABSOLUTE_FILENAME} file"
  if [ -f ${TODAYS_TODO_ORIGINAL_ABSOLUTE_FILENAME} ] ; then
    cd ${CALENDAR_MEMO_ROOT};
    logline "* The file ${TODAYS_TODO_ORIGINAL_ABSOLUTE_FILENAME} exist."
    logline "* Creating the temporary copy of this file in the /home/root/rm_calendar_memo/ location: "
    logline "cp ${TODAYS_TODO_ORIGINAL_ABSOLUTE_FILENAME} ${CALENDAR_MEMO_ROOT}/${TODAYS_TODO_TMP_FILE}"
    cp ${TODAYS_TODO_ORIGINAL_ABSOLUTE_FILENAME} ${CALENDAR_MEMO_ROOT}/${TODAYS_TODO_TMP_FILE}
    logline "* Here is the metadata of that newly copied file: "
    [[ "$RM_CALENDAR_APP_DEBUG" != true ]] && node get_metadata.js ${TODAYS_TODO_TMP_FILE} &>> /dev/null || node get_metadata.js ${TODAYS_TODO_TMP_FILE}
    logline "* Resizing this temporary copy: "
    logline "node open_resize_png.js ${TODAYS_TODO_TMP_FILE}.png"
    [[ "$RM_CALENDAR_APP_DEBUG" != true ]] && node open_resize_png.js ${TODAYS_TODO_TMP_FILE_BASE} &>> /dev/null || node open_resize_png.js ${TODAYS_TODO_TMP_FILE_BASE}
    logline "* As the result the new resized file created. The new resized absolute filename: ${TODAYS_TODO_RES_FILE}, and it's metadata: "
    [[ "$RM_CALENDAR_APP_DEBUG" != true ]] && node get_metadata.js ${TODAYS_TODO_RES_FILE} &>> /dev/null || node get_metadata.js ${TODAYS_TODO_RES_FILE}
    logline "* Create the composited image by adding calendar image on top of the resized file of our TODO page: "
    logline "node open_composite_png.js ${TODAYS_TODO_RES_FILE_BASE} ${TODAYS_CAL_FILE}"
    [[ "$RM_CALENDAR_APP_DEBUG" != true ]] && node open_composite_png.js ${TODAYS_TODO_RES_FILE_BASE} ${TODAYS_CAL_FILE} &>> /dev/null || node open_composite_png.js ${TODAYS_TODO_RES_FILE_BASE} ${TODAYS_CAL_FILE}
    logline "* As the result the new composited file created with the filename: ${TODAYS_TODO_RES_CMP_FILE}, and it's metadata: "
    [[ "$RM_CALENDAR_APP_DEBUG" != true ]] && node get_metadata.js ${TODAYS_TODO_RES_CMP_FILE} &>> /dev/null || node get_metadata.js ${TODAYS_TODO_RES_CMP_FILE}
    logline "* Copying the new resized file into the target location, while replacing the current 'suspended.png' file: "
    logline "cp ${TODAYS_TODO_RES_CMP_FILE} ${TODAYS_TODO_FINAL_ABSOLUTE_FILENAME}"
    cp ${TODAYS_TODO_RES_CMP_FILE} ${TODAYS_TODO_FINAL_ABSOLUTE_FILENAME}
    logline "* Deleting the temporary copy of the original file, resized file, and the composited file:"
    logline "rm -f ${TODAYS_TODO_TMP_FILE} ${TODAYS_TODO_RES_CMP_FILE} ${TODAYS_TODO_RES_CMP_FILE}"
    rm -f ${TODAYS_TODO_TMP_FILE} ${TODAYS_TODO_RES_FILE} ${TODAYS_TODO_RES_CMP_FILE}
    logline "========"
  else logline "* The file ${TODAYS_TODO_ABSOLUTE_FILENAME} does NOT exist."
  fi

done
