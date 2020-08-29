@echo off
chcp 65001 2>nul >nul
set "EXIT_CODE=0"

pushd "%~dp0"


::------------------------------------------------------- looking-for 'ffmpeg.exe'
set "FFMPEG=%~sdp0ffmpeg.exe"
if exist "%FFMPEG%" ( goto CONTINUE )
for /f "tokens=*" %%a in ('where ffmpeg.exe 2^>nul') do ( set "FFMPEG=%%a" )
if ["%ErrorLevel%"] NEQ ["0"] ( goto ERROR_NO_FFMPEG )
if ["%FFMPEG%"] EQU [""]      ( goto ERROR_NO_FFMPEG )
if not exist "%FFMPEG%"       ( goto ERROR_NO_FFMPEG )
:CONTINUE
::--------------------------------------------------------------------------------


::------------------------------------------------------- looking-for an argument
if ["%~1"] EQU [""] ( goto ERROR_NOARG )
if not exist "%~1"  ( goto ERROR_NOARG )
::--------------------------------------------------------------------------------


set "FILE_INPUT=%~s1"
set "FILE_OUTPUT=%~sdp1%~n1_fixed.mkv"


set "ARGS="
set  ARGS=%ARGS% -y -hide_banner -loglevel verbose -err_detect ignore_err
set  ARGS=%ARGS% -threads 16 -strict experimental 
set  ARGS=%ARGS% -flags  "+low_delay+global_header+loop-unaligned-ilme-cgop-output_corrupt"
set  ARGS=%ARGS% -flags2 "+fast+ignorecrop+showall+export_mvs"
set  ARGS=%ARGS% -fflags "+fastseek+autobsf+igndts+ignidx+genpts+nofillin+discardcorrupt"
set  ARGS=%ARGS% -noaccurate_seek
set  ARGS=%ARGS% -i "%FILE_INPUT%"
set  ARGS=%ARGS% -movflags "+faststart+rtphint+dash+cmaf+frag_every_frame+frag_keyframe+separate_moof+empty_moov+default_base_moof+skip_sidx-global_sidx-write_colr-prefer_icc-write_gama+use_metadata_tags+disable_chpl"
set  ARGS=%ARGS% -tune zerolatency
::set  ARGS=%ARGS% -copyinkf
set  ARGS=%ARGS% -copypriorss 0
set  ARGS=%ARGS% -max_muxing_queue_size 9999
set  ARGS=%ARGS% -start_at_zero
set  ARGS=%ARGS% -avoid_negative_ts "make_zero"
set  ARGS=%ARGS% -segment_time_metadata    "1"
set  ARGS=%ARGS% -force_duplicated_matrix  "1"
set  ARGS=%ARGS% -map_metadata             "-1"
set  ARGS=%ARGS% -map_chapters             "-1"
set  ARGS=%ARGS% -crf 28
set  ARGS=%ARGS% -preset ultrafast
set  ARGS=%ARGS% -c:v libx265
set  ARGS=%ARGS% -vf "fifo,setpts=PTS-STARTPTS,format=yuv420p"
set  ARGS=%ARGS% -c:a copy
::set  ARGS=%ARGS% -to "00:0:03.000"
set  ARGS=%ARGS% -shortest
set  ARGS=%ARGS% "%FILE_OUTPUT%"

call ffmpeg %ARGS%
set "EXIT_CODE=%ErrorLevel%
goto END

:ERROR_NO_FFMPEG
  set "EXIT_CODE=111"
  echo [ERROR] no ffmpeg.exe 1>&2
  goto END

:ERROR_NOARG
  set "EXIT_CODE=222"
  echo [ERROR] no argument   1>&2
  goto END

:END
  echo [INFO] [EXIT_CODE: %EXIT_CODE%] 1>&2
  pause
  exit /b %EXIT_CODE%
