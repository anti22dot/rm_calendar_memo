#!/bin/bash
export PATH=$PATH:${NODE_ROOT}/bin

# Utility | Write the passed string into the log file
logline () {
  [[ "$RM_CALENDAR_APP_DEBUG" != true ]] && true || echo "$1"
}
png_create_tmp() {
  [[ "$RM_CALENDAR_APP_DEBUG" != true ]] && logline "cp ${1} ${CALENDAR_MEMO_ROOT}/${2}" &>> /dev/null || logline "cp ${1} ${CALENDAR_MEMO_ROOT}/${2}"
  [[ "$RM_CALENDAR_APP_DEBUG" != true ]] && cp ${1} ${CALENDAR_MEMO_ROOT}/${2} &>> /dev/null || cp ${1} ${CALENDAR_MEMO_ROOT}/${2}
}
png_get_metadata() {
  [[ "$RM_CALENDAR_APP_DEBUG" != true ]] && true || logline "** ${1}, and it's metadata:"
  [[ "$RM_CALENDAR_APP_DEBUG" != true ]] && node get_metadata.js ${1} &>> /dev/null || node get_metadata.js ${1}
}
png_prepare() {
  [[ "$RM_CALENDAR_APP_DEBUG" != true ]] && true || logline "node open_prepare_png.js ${1} ${2}"
  [[ "$RM_CALENDAR_APP_DEBUG" != true ]] && node open_prepare_png.js ${1} ${2} &>> /dev/null || node open_prepare_png.js ${1} ${2}
}
png_resize() {
  [[ "$RM_CALENDAR_APP_DEBUG" != true ]] && true || logline "node open_resize_png.js ${1}.png ${2}"
  [[ "$RM_CALENDAR_APP_DEBUG" != true ]] && node open_resize_png.js ${1} ${2} &>> /dev/null || node open_resize_png.js ${1} ${2}
}
png_compose() {
  [[ "$RM_CALENDAR_APP_DEBUG" != true ]] && true || logline "node open_composite_png.js ${1} ${2} ${3} ${4} ${5}"
  [[ "$RM_CALENDAR_APP_DEBUG" != true ]] && node open_composite_png.js ${1} ${2} ${3} ${4} ${5} &>> /dev/null || node open_composite_png.js ${1} ${2} ${3} ${4} ${5}
}

while true; do
  Y=$(date +%y)                                 # Current year.
  M=$(date +%m)                                 # Current month of the year.
  DOM=$(date +%d)                               # Current day of the month.
  TODAYS_FULL_DATE="FILE_${DOM}_${M}_${Y}_W"      # Full date, in the format: "FILE_day_month_year".
  TODAYS_FULL_DATE1="${!TODAYS_FULL_DATE}"            # Full date, in the format: "FILE_day_month_year_WEEK".
  TODAYS_FULL_DATE2="FILE_${DOM}_${M}_${Y}_MORNING"      # Full date, in the format: "FILE_day_month_year_MORNING".
  TODAYS_FULL_DATE3="FILE_${DOM}_${M}_${Y}_AFTERNOON"    # Full date, in the format: "FILE_day_month_year_AFTERNOON".
  TODAYS_FULL_DATE4="FILE_${DOM}_${M}_${Y}_EVENING"      # Full date, in the format: "FILE_day_month_year_EVENING".
  TODAYS_TODO_ORIG_ABSOLUTE_FILE1="/home/root/.local/share/remarkable/xochitl/${ORIGINAL_DOC_HASH_ID}.thumbnails/${!TODAYS_FULL_DATE1}.png"
  TODAYS_TODO_ORIG_ABSOLUTE_FILE2="/home/root/.local/share/remarkable/xochitl/${ORIGINAL_DOC_HASH_ID}.thumbnails/${!TODAYS_FULL_DATE2}.png"
  TODAYS_TODO_ORIG_ABSOLUTE_FILE3="/home/root/.local/share/remarkable/xochitl/${ORIGINAL_DOC_HASH_ID}.thumbnails/${!TODAYS_FULL_DATE3}.png"
  TODAYS_TODO_ORIG_ABSOLUTE_FILE4="/home/root/.local/share/remarkable/xochitl/${ORIGINAL_DOC_HASH_ID}.thumbnails/${!TODAYS_FULL_DATE4}.png"
  TODAYS_TODO_TMP_FILE_BASE=${DOM}.${M}.${Y}
  TODAYS_TODO_TMP_FILE1=${TODAYS_TODO_TMP_FILE_BASE}.week.png
  TODAYS_TODO_TMP_FILE2=${TODAYS_TODO_TMP_FILE_BASE}.morning.png
  TODAYS_TODO_TMP_FILE3=${TODAYS_TODO_TMP_FILE_BASE}.afternoon.png
  TODAYS_TODO_TMP_FILE4=${TODAYS_TODO_TMP_FILE_BASE}.evening.png
  TODAYS_TODO_RES_FILE_BASE=${TODAYS_TODO_TMP_FILE_BASE}.new
  export TODAYS_TODO_PREP_FILE1=${TODAYS_TODO_TMP_FILE_BASE}.week.notes.png
  export TODAYS_TODO_PREP_FILE2=${TODAYS_TODO_TMP_FILE_BASE}.morning.notes.png
  export TODAYS_TODO_PREP_FILE3=${TODAYS_TODO_TMP_FILE_BASE}.afternoon.notes.png
  export TODAYS_TODO_PREP_FILE4=${TODAYS_TODO_TMP_FILE_BASE}.evening.notes.png
  export TODAYS_TODO_RES_FILE1=${TODAYS_TODO_TMP_FILE_BASE}.week.notes.new.png
  export TODAYS_TODO_RES_FILE2=${TODAYS_TODO_TMP_FILE_BASE}.morning.notes.new.png
  export TODAYS_TODO_RES_FILE3=${TODAYS_TODO_TMP_FILE_BASE}.afternoon.notes.new.png
  export TODAYS_TODO_RES_FILE4=${TODAYS_TODO_TMP_FILE_BASE}.evening.notes.new.png
  export TODAYS_TODO_FINAL=${TODAYS_TODO_TMP_FILE_BASE}.final.notes.new.composited.png
  TODAYS_CAL_FILE=${TODAYS_TODO_TMP_FILE_BASE}_calendar.png

  sleep 0.5
  logline ""; logline "========";
  logline "Right now is $(date). Searching for the files."
  if [[ -f ${TODAYS_TODO_ORIG_ABSOLUTE_FILE1} && -f ${TODAYS_TODO_ORIG_ABSOLUTE_FILE2} && -f ${TODAYS_TODO_ORIG_ABSOLUTE_FILE3} && -f ${TODAYS_TODO_ORIG_ABSOLUTE_FILE4} ]] ; then
    cd ${CALENDAR_MEMO_ROOT};

    logline "* The files exist. Creating the temporary copy of the following files in the /home/root/rm_calendar_memo/ location: "
    logline "** ${TODAYS_TODO_ORIG_ABSOLUTE_FILE1}, ${TODAYS_TODO_ORIG_ABSOLUTE_FILE2}, ${TODAYS_TODO_ORIG_ABSOLUTE_FILE3}, ${TODAYS_TODO_ORIG_ABSOLUTE_FILE4} " 
    png_create_tmp ${TODAYS_TODO_ORIG_ABSOLUTE_FILE1} ${TODAYS_TODO_TMP_FILE1}; png_create_tmp ${TODAYS_TODO_ORIG_ABSOLUTE_FILE2} ${TODAYS_TODO_TMP_FILE2}
    png_create_tmp ${TODAYS_TODO_ORIG_ABSOLUTE_FILE3} ${TODAYS_TODO_TMP_FILE3}; png_create_tmp ${TODAYS_TODO_ORIG_ABSOLUTE_FILE4} ${TODAYS_TODO_TMP_FILE4}

    logline "* Here is the metadata of that newly copied files: "
    png_get_metadata "${TODAYS_TODO_TMP_FILE1}"; png_get_metadata "${TODAYS_TODO_TMP_FILE2}"; 
    png_get_metadata "${TODAYS_TODO_TMP_FILE3}"; png_get_metadata "${TODAYS_TODO_TMP_FILE4}"

    logline "* Preparing the PNGs. Removing top calendar from the page, to have only notes area: "
    png_prepare "${TODAYS_TODO_TMP_FILE1}" 1; png_prepare "${TODAYS_TODO_TMP_FILE2}" 2; 
    png_prepare "${TODAYS_TODO_TMP_FILE3}" 3; png_prepare "${TODAYS_TODO_TMP_FILE4}" 4;

    logline "* Resizing the newly modified PNGs: "
    png_resize "${TODAYS_TODO_PREP_FILE1}" 1; png_resize "${TODAYS_TODO_PREP_FILE2}" 2;
    png_resize "${TODAYS_TODO_PREP_FILE3}" 3; png_resize "${TODAYS_TODO_PREP_FILE4}" 4;

    logline "* As the result the new resized files created. The new resized absolute filenames and metadatas:"
    png_get_metadata "${TODAYS_TODO_RES_FILE1}"; png_get_metadata "${TODAYS_TODO_RES_FILE2}"
    png_get_metadata "${TODAYS_TODO_RES_FILE3}"; png_get_metadata "${TODAYS_TODO_RES_FILE4}"

    logline "* Creating the composited image by adding calendar image on top of the resized file of our TODO page: "
    png_compose "${TODAYS_CAL_FILE}" "${TODAYS_TODO_RES_FILE1}" "${TODAYS_TODO_RES_FILE2}" "${TODAYS_TODO_RES_FILE3}" "${TODAYS_TODO_RES_FILE4}"

    logline "* Copying the new resized file into the target location, while replacing the current 'suspended.png' file: "
    logline "cp ${TODAYS_TODO_FINAL} ${TODAYS_TODO_FINAL_ABSOLUTE_FILENAME}"; cp ${TODAYS_TODO_FINAL} ${TODAYS_TODO_FINAL_ABSOLUTE_FILENAME}

    logline "* Deleting the temporary copy of the original file, resized file, and the composited file:"
    logline "rm -f ${TODAYS_TODO_TMP_FILE1} ${TODAYS_TODO_TMP_FILE2} ${TODAYS_TODO_TMP_FILE3} ${TODAYS_TODO_TMP_FILE4}"
    logline "rm -f ${TODAYS_TODO_PREP_FILE1} ${TODAYS_TODO_PREP_FILE2} ${TODAYS_TODO_PREP_FILE3} ${TODAYS_TODO_PREP_FILE4}"
    logline "rm -f ${TODAYS_TODO_RES_FILE1} ${TODAYS_TODO_RES_FILE2} ${TODAYS_TODO_RES_FILE3} ${TODAYS_TODO_RES_FILE4} ${TODAYS_TODO_FINAL}"
    rm -f ${TODAYS_TODO_TMP_FILE1} ${TODAYS_TODO_TMP_FILE2} ${TODAYS_TODO_TMP_FILE3} ${TODAYS_TODO_TMP_FILE4}
    rm -f ${TODAYS_TODO_PREP_FILE1} ${TODAYS_TODO_PREP_FILE2} ${TODAYS_TODO_PREP_FILE3} ${TODAYS_TODO_PREP_FILE4}
    rm -f ${TODAYS_TODO_RES_FILE1} ${TODAYS_TODO_RES_FILE2} ${TODAYS_TODO_RES_FILE3} ${TODAYS_TODO_RES_FILE4} ${TODAYS_TODO_FINAL} 
    logline "========"

  else logline "* One or multiple of the following files do NOT exist:" 
    logline "** ${TODAYS_TODO_ORIG_ABSOLUTE_FILE1},"; logline "** ${TODAYS_TODO_ORIG_ABSOLUTE_FILE2}," 
    logline "** ${TODAYS_TODO_ORIG_ABSOLUTE_FILE3},"; logline "** ${TODAYS_TODO_ORIG_ABSOLUTE_FILE4}"; logline "** do NOT exist."
  fi

done
