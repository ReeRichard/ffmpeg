ffmpeg -y -i "%~1" -an -vf "setpts=PTS-STARTPTS,vidstabdetect=result=data.trf"   -f null  nul
ffmpeg -y -i "%~1"     -vf "setpts=PTS-STARTPTS,vidstabtransform=input=data.trf" out.mp4

::---------------------------------------------------------------------------------------
::advance features (slower), in additional, the use of the 'unsharp' filter.
::  https://ffmpeg.org/ffmpeg-filters.html#toc-vidstabdetect-1
::  https://ffmpeg.org/ffmpeg-filters.html#toc-vidstabtransform-1
::ffmpeg -y -i "%~1" -to "00:10:00.000" -an -vf "setpts=PTS-STARTPTS,vidstabdetect=result=transforms.trf:shakiness=3:accuracy=10:stepsize=12:mincontrast=0.5:show=0"   -f null  nul
::ffmpeg -y -i "%~1" -to "00:10:00.000" -an -vf "setpts=PTS-STARTPTS,vidstabtransform=input=transforms.trf:smoothing=20:optalgo=gauss:maxshift=-1:maxangle=-1:crop=black:interpol=bicubic:zoom=5,unsharp=5:5:0.8:3:3:0.4" out.mkv
