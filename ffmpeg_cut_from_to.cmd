@echo off
::------------------------
:: trying to cut properly (not accurate) to 
::   avoid sync-issues/audio over blank video-frame.
:: -noaccurate_seek 
:: -fflags "+fastseek"
:: -copypriorss 0
:: (and not  '-copyinkf')
:: -shortest
::------------------------
chcp 65001 2>nul >nul
set "EXIT_CODE=0"

pushd "%~dp0"

::------------------------------------------------------- looking-for an argument
if ["%~1"] EQU [""] ( goto ERROR_NOARG )
if not exist "%~1"  ( goto ERROR_NOARG )
::--------------------------------------------------------------------------------


set "FILE_INPUT=%~s1"
set "FILE_OUTPUT=%~sdp1%~n1___.mkv"


::---------------------------------------------------------------------------- Time Cuts
echo [INFO]-------------------------------------------------------
call ffprobe -hide_banner -format "duration" -i "%FILE_INPUT%"
echo [INFO]-------------------------------------------------------
echo.
echo [INFO] Enter cut times (format is 00:00:00.000 - empty [ENTER] means skip)
set /p "TIME_START_INPUT_PRE=Enter Pre-Input Start Time (-ss before -i):  "
set /p "TIME_START_INPUT_POST=Enter Post-Input Start Time (-ss after -i):  "
set /p "TIME_END=Enter The End Time (-to after -i):  "
::-------------------------------------------------------------------------------------------


set "ARGS="
set  ARGS=%ARGS% -y -hide_banner -loglevel verbose -err_detect ignore_err
set  ARGS=%ARGS% -threads 16 -strict experimental 
set  ARGS=%ARGS% -flags  "+low_delay+global_header+loop-unaligned-ilme-cgop-output_corrupt"
set  ARGS=%ARGS% -flags2 "+fast+ignorecrop+showall+export_mvs"
set  ARGS=%ARGS% -fflags "+fastseek+autobsf+igndts+ignidx+genpts+nofillin+discardcorrupt"
if ["%TIME_START_INPUT_PRE%"] NEQ [""] ( 
  set  ARGS=%ARGS% -ss "%TIME_START_INPUT_PRE%"
) 
set  ARGS=%ARGS% -noaccurate_seek 
set  ARGS=%ARGS% -i "%FILE_INPUT%"
if ["%TIME_START_INPUT_POST%"] NEQ [""] ( 
  set  ARGS=%ARGS% -ss "%TIME_START_INPUT_POST%"
) 
set  ARGS=%ARGS% -movflags "+faststart+rtphint+dash+cmaf+frag_every_frame+frag_keyframe+separate_moof+empty_moov+default_base_moof+skip_sidx-global_sidx-write_colr-prefer_icc-write_gama+use_metadata_tags+disable_chpl"
set  ARGS=%ARGS% -tune zerolatency
::set  ARGS=%ARGS% -copyinkf
set  ARGS=%ARGS% -copypriorss 0
set  ARGS=%ARGS% -start_at_zero
set  ARGS=%ARGS% -avoid_negative_ts "make_zero"
set  ARGS=%ARGS% -segment_time_metadata    "1"
set  ARGS=%ARGS% -force_duplicated_matrix  "1"
set  ARGS=%ARGS% -map_chapters             "-1"
set  ARGS=%ARGS% -map_metadata             "-1"
set  ARGS=%ARGS% -codec copy
set  ARGS=%ARGS% -shortest
if ["%TIME_END%"] NEQ [""] ( 
  set  ARGS=%ARGS% -to "%TIME_END%"
)  
set  ARGS=%ARGS% "%FILE_OUTPUT%"

call ffmpeg %ARGS%
set "EXIT_CODE=%ErrorLevel%
goto END


:ERROR_NOARG
  set "EXIT_CODE=222"
  echo [ERROR] no argument   1>&2
  goto END

:END
  echo [INFO] [EXIT_CODE: %EXIT_CODE%] 1>&2
  pause
  exit /b %EXIT_CODE%
