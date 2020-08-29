call "D:\dos\parallel_aria2\aria2c.exe" --split=8 --file-allocation=prealloc --remote-time=true --async-dns=false --continue=true --max-concurrent-downloads=16 --max-connection-per-server=16 --http-user="%unam%" --http-passwd="%pasw%" --timeout=120 --connect-timeout=120 --min-split-size=2M --max-tries=0 --log="log.txt" --referer=%sRedirected% --disable-ipv6=true --human-readable=true --retry-wait=1 --user-agent=%sUserAgent% --enable-http-keep-alive=true --enable-http-pipelining=true --rpc-secure=false --check-integrity=false --check-certificate=false --http-auth-challenge=false --allow-overwrite=true --dir="%CD%" --console-log-level="notice" --log-level="notice" %sURL%

aria2c.exe --split=10 --file-allocation=falloc --continue=true --max-connection-per-server=16 --http-user=music --http-passwd=music --timeout=120 --connect-timeout=120 --max-tries=0 --log=log.txt --referer="eladkarako.com" --disable-ipv6=true --human-readable=true --retry-wait=1 --user-agent="Mozilla/5" --enable-http-keep-alive=true --enable-http-pipelining=true  "http://eladkarako.com/download/_res/N920CXXU2BPD6_N920COJK2BPD6_ILO.zip"


"D:\dos\parallel_aria2\aria2c.exe"  --split=10 --rpc-secure=false --check-integrity=false --check-certificate=false --http-auth-challenge=false https://storage.googleapis.com/chromium-browser-snapshots/Win_x64/425595/mini_installer.exe

------------------------------------------------------------------------------------------------------------------------
@echo off
rem .           Eset Antivirus Update [New version 4]  (download.eset.com)
rem .  ------------------------------------------------------------------------

rem .  (command switches, Eset Secure Login)
::set unam=EAV-0121697007
::set pasw=9xedjr7462
::set unam=EAV-0140173669
::set pasw=tmtep63j2f
set unam=EAV-0176070087
set pasw=3du3jv75aa
set expr=02.12.2

rem .  (command switches, wGet Download Related Switches)
set sSecureLogin=
::set sURL="http://download.eset.com/download/win/eav/eav_nt64_enu.msi"
set sURL=http://%unam%:%pasw%@download.eset.com/download/win/eav/eav_nt64_enu.exe
set sUserAgent="Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; MathPlayer 2.20; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; .NET4.0C; .NET4.0E)"
set sRedirected="about:blank"

rem .  (download)
rem res\wget.exe --directory-prefix=. --referer=%sRedirected% --timestamping --debug --http-user=%unam% --http-passwd=%pasw% --user-agent=%sUserAgent% %sURL%
rem call C:\PROGRA~2\ORBITD~1\orbitdm.exe "%url%"
call "D:\dos\parallel_aria2\aria2c.exe" --split=8 --file-allocation=prealloc --remote-time=true --async-dns=false --continue=true --max-concurrent-downloads=16 --max-connection-per-server=16 --http-user="%unam%" --http-passwd="%pasw%" --timeout=120 --connect-timeout=120 --min-split-size=2M --max-tries=0 --log="log.txt" --referer=%sRedirected% --disable-ipv6=true --human-readable=true --retry-wait=1 --user-agent=%sUserAgent% --enable-http-keep-alive=true --enable-http-pipelining=true --rpc-secure=false --check-integrity=false --check-certificate=false --http-auth-challenge=false --allow-overwrite=true --dir="%CD%" --console-log-level="notice" --log-level="notice" %sURL%


pause
------------------------------------------------------------------------------------------------------------------------