@echo off
setlocal enabledelayedexpansion

SET P=\\micro.intra\projekt\P0863$\P0863_Gem\batch
pushd "%P%"

SET RUNR=TRUE
SET RFILE=batch.R

SET RUNSTATA=TRUE
SET STATAFILE=batch.do

SET LOG=cmdlog
call :sub >"logs\%LOG%.log" 2>&1

popd
endlocal
exit 0

:sub
echo "!time!: Starting batch file..."
IF "%RUNR%"=="TRUE" (
	echo "!time!: Starting R script..."
	"C:\Program Files\R\R\bin\Rscript.exe" %RFILE%
)
IF "%RUNSTATA%"=="TRUE" (
	echo "!time!: Starting Stata..."
	cd logs
	"C:\Program Files (x86)\Stata15\StataMP-64.exe" /e /q do %P%/%STATAFILE%
)
echo "!time!: Batch file done..."