::@echo off
::*************************************************************
:: drag and drop two files, one audio (mp3,m4a,aac,oga,ogg,flac),  
:: and one image (jpg,jpeg,png,gif).  
:: this batch-file will figure-out the audio and image and  
:: will run the ffmpeg command properly.
::*************************************************************
:: output format format is: 
::    H.265 in MKV container.
:: output path is:   
::    "folderofaudiofile/audiofilename_imagefilename.mkv"
::*************************************************************

chcp 65001 2>nul >nul
set "EXIT_CODE=111"
pushd "%~sdp0"

if ["%~1"] EQU [""] ( goto ERROR_NOARGS ) 
if ["%~2"] EQU [""] ( goto ERROR_NOARG2 ) 

set "FILE_AUDIO="
set "FILE_IMAGE="

echo."%~x1" | findstr /I /C:".MP3" /C:".M4A" /C:".AAC" /C:".OGA" /C:".OGG" /C:".FLAC" 2>nul 1>nul
if ["%ErrorLevel%"] EQU ["0"] ( goto AUDIO1 )

echo."%~x1" | findstr /I /C:".JPG" /C:".JPEG" /C:".PNG" /C:".GIF" 2>nul 1>nul
if ["%ErrorLevel%"] EQU ["0"] ( goto IMAGE1 )

:AUDIO1
  set "FILE_AUDIO=%~f1"
  echo [INFO] FILE_AUDIO === %FILE_AUDIO%
  echo."%~x2" | findstr /I /C:".JPG" /C:".JPEG" /C:".PNG" /C:".GIF" 2>nul 1>nul
  if ["%ErrorLevel%"] NEQ ["0"] ( goto ERROR_NOIMAGE ) 
  set "FILE_IMAGE=%~f2"
  echo [INFO] FILE_IMAGE === %FILE_IMAGE%
  goto PROCESS

:IMAGE1
  set "FILE_IMAGE=%~f1"
  echo [INFO] FILE_IMAGE === %FILE_IMAGE%
  echo."%~x2" | findstr /I /C:".MP3" /C:".M4A" /C:".AAC" /C:".OGA" /C:".OGG" /C:".FLAC" 2>nul 1>nul
  if ["%ErrorLevel%"] NEQ ["0"] ( goto ERROR_NOAUDIO ) 
  set "FILE_AUDIO=%~f2"
  echo [INFO] FILE_AUDIO === %FILE_AUDIO%
  goto PROCESS

:PROCESS
  set "FILE_OUT="
  for /f %%a in ("%FILE_AUDIO%") do ( set "FILE_OUT=%%~dpa"           ) 
  pushd "%FILE_OUT%"
  for /f %%a in ("%FILE_AUDIO%") do ( set "FILE_OUT=%FILE_OUT%%%~na"  ) 
  for /f %%a in ("%FILE_IMAGE%") do ( set "FILE_OUT=%FILE_OUT%_%%~na"  ) 
  set "FILE_OUT=%FILE_OUT%.mkv"
  echo [INFO] FILE_OUT   === %FILE_OUT%
  
::set "FILE_IMAGE=%FILE_IMAGE:\=/%"

  title %FILE_OUT%
  echo "ffmpeg.exe" -y -hide_banner -loglevel "info" -strict "experimental" -threads "16" -stats -fflags "+autobsf" -loop 1 -i "%FILE_IMAGE%" -i "%FILE_AUDIO%" -c:v libx265 -preset ultrafast -crf 30 -b:v "0" -c:a copy -shortest -vf "fifo,format=pix_fmts=yuv420p,fps=fps=25" %FILE_OUT%"
  call "ffmpeg.exe" -y -hide_banner -loglevel "info" -strict "experimental" -threads "16" -stats -fflags "+autobsf" -loop 1 -i "%FILE_IMAGE%" -i "%FILE_AUDIO%" -c:v libx265 -preset ultrafast -crf 30 -b:v "0" -c:a copy -shortest -vf "fifo,format=pix_fmts=yuv420p,fps=fps=25" %FILE_OUT%"
  set "EXIT_CODE=%ErrorLevel%"

  goto END

::---------------------------------------------------

:ERROR_NOARGS
  set "EXIT_CODE=222"
  echo [ERROR] missing arguments.       1>&2
  goto END
  
:ERROR_NOARG2
  set "EXIT_CODE=333"
  echo [ERROR] missing 2nd-argument.    1>&2
  goto END

:ERROR_NOIMAGE
  set "EXIT_CODE=444"
  echo [ERROR] missing image.           1>&2
  goto END

:ERROR_NOAUDIO
  set "EXIT_CODE=555"
  echo [ERROR] missing audio.           1>&2
  goto END

:END
  if ["%EXIT_CODE%"] EQU ["111"] ( 
    echo [ERROR] process killed.
  ) 
  echo [INFO] Done. [EXIT_CODE: %EXIT_CODE%]
  pause
  popd
  popd
  exit /b %EXIT_CODE%