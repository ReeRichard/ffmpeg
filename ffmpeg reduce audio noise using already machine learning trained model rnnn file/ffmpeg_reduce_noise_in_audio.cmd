@echo off
::---------------------- properly show Unicode characters on console.
chcp 65001 1>nul 2>nul
::---------------------- storing ffmpeg exit-code clean.
set "EXIT_CODE=0"

::---------------------- has argument?
if ["%~1"] EQU [""] ( goto ERROR_NOARG )

::---------------------- Recurrent-neural-networks trained-model files from https://github.com/GregorR/rnnoise-models/ as explained in: https://jmvalin.ca/demo/rnnoise/ .
set "FILE_RNNN=bd.rnnn"
::set "FILE_RNNN=cb.rnnn"
::set "FILE_RNNN=lq.rnnn"
::set "FILE_RNNN=mp.rnnn"

::---------------------- input/output. output file uses MKV container (instead of m4a or your own file-extension). The MKV-container can handle most (all) audio-stream formats.
set "FILE_INPUT=%~s1"
::set "FILE_OUTPUT=%~sdp1%~n1__noise_reduced_audio_using_%FILE_RNNN%_model%~x1"
set "FILE_OUTPUT=%~sdp1%~n1__noise_reduced_audio_using_%FILE_RNNN%_model.mkv"

::---------------------- change-dir to script-folder enables using just rnnn filename instead of full-path (which is problematic in Windows due to escaping of (back)slash-characters).
pushd "%~sdp0"

::---------------------- allow spread arguments over few lines.
set "ARGS="
set ARGS=%ARGS% -y -hide_banner -loglevel "info" -stats
set ARGS=%ARGS% -threads "16" -strict "experimental" -err_detect ignore_err
set ARGS=%ARGS% -flags    "+low_delay+global_header+loop-unaligned-ilme-cgop-output_corrupt"
set ARGS=%ARGS% -flags2   "+fast+ignorecrop+showall+export_mvs"
set ARGS=%ARGS% -fflags   "+autobsf+igndts+ignidx+genpts+nofillin+discardcorrupt-fastseek"
set ARGS=%ARGS% -i "%FILE_INPUT%" 
set ARGS=%ARGS% -movflags "+faststart+rtphint+dash+cmaf+empty_moov+frag_every_frame+frag_keyframe+separate_moof+disable_chpl"
set ARGS=%ARGS% -start_at_zero
set ARGS=%ARGS% -avoid_negative_ts "make_zero"
::set ARGS=%ARGS% -c:v copy -c:s copy
set ARGS=%ARGS% -vn -sn
set ARGS=%ARGS% -map_chapters "-1"
set ARGS=%ARGS% -map_metadata "-1"
::------------------------------ YouTube uses 44100. FFMPEG always wants to use 48000. Explicitly set 48000 (and stereo too..).
set ARGS=%ARGS% -ar 48000 -ac 2
set ARGS=%ARGS% -af "afifo,asetpts=PTS-STARTPTS,highpass=frequency=100,arnndn=m=%FILE_RNNN%"
::------------------------------ this is used for quick testing a sample of the entire stream (10 first seconds), I have already trimmed the input-stream so no need for this, unless you want it for your own input...
::set ARGS=%ARGS% -s "00:00:00.000" -to "00:00:10.000"
set ARGS=%ARGS% "%FILE_OUTPUT%"


::---------------------- execute FFMPEG with arguments (keep exit-code)
call "ffmpeg" %ARGS%
set "EXIT_CODE=%ErrorLevel%"

goto END

::--------------------------------------------------

:ERROR_NOARG
  set "EXIT_CODE=111"
  echo [ERROR] please provide a file as an argument. 1>&2
  goto END
  
:END
  echo [INFO] Done [EXIT_CODE: %EXIT_CODE%]
  pause
  popd
  exit /b %EXIT_CODE%



::I am using "short" (8.3) file/folder names for input-related stuff (helps with long file names).
::
::https://reddit.com/r/ffmpeg/comments/ga4a22/what_can_i_do_to_increase_listenability_of_bad/
::https://github.com/GregorR/rnnoise-models/tree/master/beguiling-drafter-2018-08-30
::Elad Karako August 2020.
