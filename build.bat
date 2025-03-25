@echo off
echo Choose an option:
echo [1] For RGB
echo [2] For Gray
set /p choice="Enter your choice [1/2]: "

if "%choice%"=="1" (
    octave --persist compression.m cat_sample.jpg rgb
) else if "%choice%"=="2" (
    octave --persist compression.m cat_sample.jpg gray
) else (
    echo Invalid choice. Exiting.
)