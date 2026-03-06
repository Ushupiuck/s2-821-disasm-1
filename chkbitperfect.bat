@echo off
call tool/md5 s2built.bin md5
if "%md5%" equ "4f779c3e0ee0bd0686aab8f9e16a4002" (
	echo MD5 identical!
) else (
	echo MD5 does not match.
)
pause