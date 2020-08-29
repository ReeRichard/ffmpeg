<h1>How to reduce noise in audio streams.</h1>

first get latest FFMPEG from here:  
https://ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-latest-win64-static.zip  
or here:  
https://ffmpeg.zeranoe.com/builds/win32/static/ffmpeg-latest-win32-static.zip  


Background noise-reduction (such as microphone-static or over-powered (pre)amplifier - example included),  
combines both classic solution <code>highpass</code><sup><a href="https://ffmpeg.org/ffmpeg-filters.html#highpass">see here</a></sup> audio-filter,  
and <code>arnndn</code> audio-filter which uses Recurrent-neural-networks trained-model file from https://github.com/GregorR/rnnoise-models/ as explained in: https://jmvalin.ca/demo/rnnoise/ .  


As far as I can tell this is the only full (all included, no dependencies) example out there... (August 2020),  
although there are many (similar) suggestions, for example  
https://reddit.com/r/ffmpeg/comments/ga4a22/what_can_i_do_to_increase_listenability_of_bad/  
and https://github.com/GregorR/rnnoise-models/tree/master/beguiling-drafter-2018-08-30 .


This example will accept any audio/video file that is supported by FFMPEG,  
which you can drag&amp;drop over it (<code>ffmpeg_reduce_noise_in_audio.cmd</code>).  

The output will generate a similar file-name with the suffix of <code>__noise_reduced_audio_using_{your model file name}_model</code> for example <code>__noise_reduced_audio_using_bd.rnnn_model</code>,  
to the same folder as your input-file.  

You can change the model-file in the batch file (as well as anything else..).  

<hr/>

The output file is an MKV file (with only audio stream), instead of an m4a, mp3 or your own file-extension.  

<hr/>

This batch-file can also help extract audio from corrupt-files,  
it will skip (to through) errors, and not include the corrupt parts,  
it also clears meta-data from the file, rewrites timestamps (starting frames from zero),  
and instead of using an ATOM block at the start/end of the file - it uses a modern (although slightly wastful) way of fragmented block (usually more useful for streaming but with it ATOM block corruption is very rare).  

Along with meta-data the chapter-data is also removed and there will be a lot of info (loglevel can be changed from info to error...) in console.  

The <code>arnndn</code> does not report any information as far as I can tell.  


The 10-seconds example audio given here is the audio stream of the YouTube video:  
https://www.youtube.com/watch?v=ZVT38lQzqYI ("ASMR | Chamber of Secrets - Harry Potter Chps 1 & 2 - Whispered Reading" by "Library of Whispers ASMR") which, although relaxing, has some background noise from the microphone.  


I'm using short (8.3) file-names (and/or folder-path) for input-related stuff, and changing the working-folder to the scripts-current folder to help with "too long" file names or specifying exact-path in the FFMPEG argument for the plugin. The output file name is as long as needed.


<a href="https://paypal.me/e1adkarak0/5"><em>buy me a coffee ☕︎</em></a>